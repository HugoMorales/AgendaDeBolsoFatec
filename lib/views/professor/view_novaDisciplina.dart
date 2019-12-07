import 'package:agenda_fatec/models/Professor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:agenda_fatec/views/professor/view_codTurma.dart';
import 'package:agenda_fatec/models/Disciplina.dart';
import 'package:agenda_fatec/models/Turma.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agenda_fatec/utils.dart';

class NovaDisciplina extends StatefulWidget {
  NovaDisciplina({Key key, this.title, this.professor}) : super(key: key);
  final String title;
  final Professor professor;

  @override
  State<StatefulWidget> createState() => new _NovaDisciplinaState();
}

class _NovaDisciplinaState extends State<NovaDisciplina> {
  //Variables
  Disciplina novaDisc;
  Turma novaTurma;
  Firestore refDb = Firestore.instance;

  //Edges
  final EdgeInsets edgesLeftRight = EdgeInsets.only(left: 25, right: 25);

  //Controllers
  final TextEditingController ctrlrDisciplina = new TextEditingController();
  final TextEditingController ctrlrSigla = new TextEditingController();
  final TextEditingController ctrlrTurma = new TextEditingController();

  //Input decorations
  final InputDecoration decDisciplina = InputDecoration(
      border: OutlineInputBorder(), hintText: 'Nome da disciplina');
  final InputDecoration decSigla = InputDecoration(
      border: OutlineInputBorder(), hintText: 'Sigla da disciplina');
  final InputDecoration decTurma = InputDecoration(
      border: OutlineInputBorder(), hintText: 'Nome da primeira turma');

  //Button properties
  final BorderRadius radButton = new BorderRadius.circular(30);
  final double wdtButton = 150;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('Nova disciplina'),
            centerTitle: true,
            textTheme: Theme.of(context).appBarTheme.textTheme),
        resizeToAvoidBottomInset: true,
        resizeToAvoidBottomPadding: true,
        body: SingleChildScrollView(
            padding: edgesLeftRight,
            child: Column(
              children: <Widget>[
                Container(
                    padding: EdgeInsets.only(top: 35, bottom: 5),
                    child: TextField(
                        //TextField Disciplina
                        inputFormatters: [LengthLimitingTextInputFormatter(32)],
                        decoration: decDisciplina,
                        controller: ctrlrDisciplina)),
                Container(
                    padding: EdgeInsets.only(top: 5, bottom: 5),
                    child: TextField(
                        //TextField Sigla
                        inputFormatters: [LengthLimitingTextInputFormatter(6)],
                        decoration: decSigla,
                        controller: ctrlrSigla)),
                Container(
                    padding: EdgeInsets.only(top: 5, bottom: 5),
                    child: TextField(
                        //TextField Turma
                        inputFormatters: [LengthLimitingTextInputFormatter(25)],
                        decoration: decTurma,
                        controller: ctrlrTurma)),
                Container(
                  padding: EdgeInsets.only(top: 25, bottom: 5),
                  width: wdtButton,
                  child: RaisedButton(
                      //RaisedButton Criar disciplina
                      child: Text('Criar disciplina'),
                      onPressed: () async {
                        novaDisc = new Disciplina();
                        novaTurma = new Turma();
                        novaDisc.sigla = formatSigla(ctrlrSigla.text);
                        novaDisc.nome = ctrlrDisciplina.text;
                        novaDisc.nomeProfessor = widget.professor.nome;
                        novaDisc.idProfessor = widget.professor.idUsuario;
                        novaTurma.nomeTurma = ctrlrTurma.text;
                        novaTurma.siglaDiscTurma = formatSigla(ctrlrSigla.text);
                        novaTurma.discTurma = ctrlrDisciplina.text;
                        novaTurma.codTurma = await newCodTurma();

                        DocumentReference newDisc = await refDb
                            .collection('Disciplinas')
                            .add(novaDisc.toJson());

                        novaTurma.idDiscTurma = newDisc.documentID;
                        novaTurma.nomeProfessor = widget.professor.nome;
                        novaTurma.listaAlunos = new List();
                        DocumentReference newTurma = await refDb
                            .collection('Turmas')
                            .add(novaTurma.toJson());
                        if (newDisc.path.length > 0 &&
                            newTurma.documentID.length > 0) {
                          createDialog(
                              'Disciplina criada com sucesso', context);
                          ctrlrDisciplina.text = '';
                          ctrlrSigla.text = '';
                          ctrlrTurma.text = '';
                        } else {
                          createDialog(
                              'Erro inesperado ao criar a disciplina', context);
                        }
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    CodTurma(codTurma: novaTurma.codTurma)));
                      },
                      shape: RoundedRectangleBorder(borderRadius: radButton),
                      color: Theme.of(context).accentColor,
                      textColor: Colors.white),
                )
              ],
            )));
  }
}
