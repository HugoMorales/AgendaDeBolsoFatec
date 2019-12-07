import 'package:agenda_fatec/models/Solicitacao.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:agenda_fatec/utils.dart';
import '../../models/Aluno.dart';
import '../../models/Turma.dart';

class EntradaCodTurma extends StatefulWidget {
  EntradaCodTurma({Key key, this.title, this.aluno}) : super(key: key);
  final String title;
  final Aluno aluno;

  @override
  State<StatefulWidget> createState() => new _EntradaCodTurmaState();
}

class _EntradaCodTurmaState extends State<EntradaCodTurma> {
  //Variables
  Firestore refDb = Firestore.instance;
  bool stateButton = true;

  //Controllers
  final TextEditingController ctrlrCodTurma = new TextEditingController();

  //Input decorations
  final InputDecoration decCodTurma = InputDecoration(
      border: OutlineInputBorder(borderSide: BorderSide(width: 5)));

  //Edges
  final EdgeInsets edgesLeftRight = EdgeInsets.only(left: 5, right: 5);

  //Button properties
  final BorderRadius radButton = new BorderRadius.circular(30);
  final double wdtButton = 150;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Entrar em uma turma'),
          centerTitle: true,
          textTheme: Theme.of(context).appBarTheme.textTheme,
        ),
        body: SingleChildScrollView(
          padding: edgesLeftRight,
          child: Column(
            children: <Widget>[
              Container(
                  padding: EdgeInsets.only(top: 100),
                  child: Center(
                    child: Text('CÓDIGO DE TURMA',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  )),
              Container(
                  padding: EdgeInsets.only(
                      left: 100, right: 100, top: 10, bottom: 10),
                  child: TextField(
                      textAlign: TextAlign.center,
                      enabled: stateButton,
                      controller: ctrlrCodTurma,
                      decoration: decCodTurma)),
              Container(
                  padding:
                      EdgeInsets.only(top: 5, bottom: 5, left: 40, right: 40),
                  child: Text(
                      'Insira o código de turma informado pelo seu professor',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20))),
              Container(
                  height: 60,
                  child: Center(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.only(top: 5, bottom: 5),
                          width: wdtButton,
                          child: RaisedButton(
                              child: Text('Confirmar'),
                              onPressed: () async {
                                if (ctrlrCodTurma.text == "") {
                                  createDialog(
                                      "Insira um código de turma", context);
                                } else {
                                  String codTurma =
                                      ctrlrCodTurma.text.toUpperCase();
                                  QuerySnapshot query = await refDb
                                      .collection("Turmas")
                                      .where('codTurma', isEqualTo: codTurma)
                                      .getDocuments();
                                  if (query.documents.length == 0) {
                                    createDialog(
                                        'Código de turma inválido', context);
                                  } else {
                                    Turma turma = new Turma();
                                    turma.fromSnapshot(query.documents[0]);
                                    Solicitacao solicitacao = new Solicitacao();
                                    solicitacao.idAluno =
                                        widget.aluno.idUsuario;
                                    solicitacao.idTurma = turma.idTurma;
                                    solicitacao.nomeAluno = widget.aluno.nome;
                                    solicitacao.raAluno = widget.aluno.ra;
                                    solicitacao.turnoAluno = widget.aluno.turno;
                                    solicitacao.semestreMatAluno =
                                        widget.aluno.semestreMat;

                                    await refDb
                                        .collection('Solicitacoes')
                                        .add(solicitacao.toJson());

                                    createDialog(
                                        'Solicitação enviada para o professor',
                                        context);
                                    setState(() {
                                      stateButton = false;
                                    });
                                  }
                                }
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: radButton),
                              color: Theme.of(context).accentColor,
                              textColor: Colors.white)),
                    ],
                  )))
            ],
          ),
        ));
  }
}
