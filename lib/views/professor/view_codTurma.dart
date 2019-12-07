import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:agenda_fatec/utils.dart';

class CodTurma extends StatefulWidget {
  CodTurma({Key key, this.title, this.codTurma}) : super(key: key);
  final String title;
  final String codTurma;

  @override
  State<StatefulWidget> createState() => new _CodTurmaState();
}

class _CodTurmaState extends State<CodTurma> {
  //Variables
  Firestore refDb = Firestore.instance;

  //Controllers
  final TextEditingController ctrlrCodTurma = new TextEditingController();

  //Input decorations
  final InputDecoration decCodTurma = InputDecoration(
      border: OutlineInputBorder(borderSide: BorderSide(width: 5)));
  //Edges
  final EdgeInsets edgesLeftRight = EdgeInsets.only(left: 5, right: 5);

  @override
  void initState() {
    super.initState();
    ctrlrCodTurma.text = widget.codTurma;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Código de turma'),
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
                      enabled: false,
                      controller: ctrlrCodTurma,
                      decoration: decCodTurma)),
              Container(
                  padding:
                      EdgeInsets.only(top: 5, bottom: 5, left: 40, right: 40),
                  child: Text(
                      'Copie e compartilhe o código de turma para os alunos de sua turma, ou toque no botão direito para gerar um novo',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20))),
              Container(
                  height: 60,
                  child: Center(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                        padding: EdgeInsets.only(left: 10, right: 5),
                        icon: Icon(
                          Icons.assignment,
                          color: Theme.of(context).accentColor,
                        ),
                        iconSize: 50,
                        onPressed: () {
                          Clipboard.setData(
                              new ClipboardData(text: ctrlrCodTurma.text));
                        },
                      ),
                      IconButton(
                        padding: EdgeInsets.only(left: 5, right: 10),
                        icon: Icon(Icons.autorenew,
                            color: Theme.of(context).accentColor),
                        iconSize: 50,
                        onPressed: () async {
                          String novoCod;
                          novoCod = await newCodTurma();
                          QuerySnapshot query = await refDb.collection('Turmas').where('codTurma', isEqualTo: ctrlrCodTurma.text).getDocuments();
                          DocumentSnapshot docTurma = query.documents[0];
                          await refDb.collection('Turmas').document(docTurma.documentID).updateData({"codTurma": novoCod});
                          ctrlrCodTurma.text = novoCod;
                        },
                      )
                    ],
                  )))
            ],
          ),
        ));
  }
}
