import 'package:agenda_fatec/models/Professor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:agenda_fatec/views/professor/view_codTurma.dart';
import 'package:agenda_fatec/models/Disciplina.dart';
import 'package:agenda_fatec/models/Turma.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agenda_fatec/utils.dart';

class NovaTurma extends StatefulWidget {
  NovaTurma({Key key, this.title, this.disciplina, this.professor}) : super(key: key);
  final String title;
  final Disciplina disciplina;
  final Professor professor;

  @override
  State<StatefulWidget> createState() => new _NovaTurmaState();
}

class _NovaTurmaState extends State<NovaTurma> {
  //Variables
  Turma novaTurma;
  Firestore refDb = Firestore.instance;

  //Edges
  final EdgeInsets edgesLeftRight = EdgeInsets.only(left: 25, right: 25);

  //Controllers
  final TextEditingController ctrlrTurma = new TextEditingController();

  //Input decorations
  final InputDecoration decTurma = InputDecoration(
      border: OutlineInputBorder(), hintText: 'Nome da turma');

  //Button properties
  final BorderRadius radButton = new BorderRadius.circular(30);
  final double wdtButton = 150;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('Nova turma'),
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
                        //TextField Turma
                        inputFormatters: [LengthLimitingTextInputFormatter(25)],
                        decoration: decTurma,
                        controller: ctrlrTurma)),
                Container(
                  padding: EdgeInsets.only(top: 25, bottom: 5),
                  width: wdtButton,
                  child: RaisedButton(
                      //RaisedButton Criar disciplina
                      child: Text('Criar turma'),
                      onPressed: () async {
                        novaTurma = new Turma();
                        novaTurma.nomeTurma = ctrlrTurma.text;
                        novaTurma.siglaDiscTurma = widget.disciplina.sigla;
                        novaTurma.discTurma = widget.disciplina.nome;
                        novaTurma.idDiscTurma = widget.disciplina.docId;
                        novaTurma.nomeProfessor = widget.professor.nome;
                        novaTurma.listaAlunos = new List();
                        novaTurma.codTurma = await newCodTurma();

                        await refDb
                            .collection('Turmas')
                            .add(novaTurma.toJson());

                        ctrlrTurma.text = '';
                        
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
