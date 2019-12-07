import 'package:agenda_fatec/models/Professor.dart';
import 'package:flutter/material.dart';
import 'package:agenda_fatec/models/Disciplina.dart';
import 'package:agenda_fatec/models/Turma.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agenda_fatec/views/professor/view_telaPrincipalTurma.dart';
import 'package:agenda_fatec/views/professor/view_novaTurma.dart';

Widget createListTile(BuildContext context, Disciplina disciplina, Turma turma,
    List<Turma> turmas) {
  String title = turma.nomeTurma;

  return new Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(width: 1.5, color: Theme.of(context).accentColor)),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        title: Text(title,
            maxLines: 2,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20)),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TelaPrincipalTurma(
                      disciplina: disciplina, turma: turma, turmas: turmas)));
        },
      ));
}

Widget createListView(List<DocumentSnapshot> docs, Disciplina disciplina) {
  Turma auxAdd;
  List<Turma> turmas = new List();

  for (int i = 0; i < docs.length; i++) {
    auxAdd = new Turma();
    auxAdd.fromSnapshot(docs[i]);
    turmas.add(auxAdd);
  }

  return new ListView.builder(
    itemCount: turmas.length,
    itemBuilder: (context, i) {
      return createListTile(context, disciplina, turmas[i], turmas);
    },
  );
}

class ListaTurmas extends StatefulWidget {
  ListaTurmas({Key key, this.title, this.disciplina, this.professor})
      : super(key: key);
  final String title;
  final Disciplina disciplina;
  final Professor professor;

  @override
  State<StatefulWidget> createState() => new _ListaTurmasState();
}

class _ListaTurmasState extends State<ListaTurmas> {
  //Variables
  List<Turma> listaturmas;
  Firestore refDb = Firestore.instance;

  //Edges
  final EdgeInsets edgesLeftRight = EdgeInsets.only(left: 5, right: 5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Turmas'),
        centerTitle: true,
        textTheme: Theme.of(context).appBarTheme.textTheme,
      ),
      floatingActionButton: Container(
          padding: EdgeInsets.only(left: 21, right: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            verticalDirection: VerticalDirection.up,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 5),
                    child: FloatingActionButton.extended(
                        heroTag: null,
                        label: Text(
                          'Excluir Disciplina',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {},
                        backgroundColor: Colors.red,
                        icon: Icon(
                          Icons.delete_sweep,
                          color: Colors.white,
                        )),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(bottom: 10),
                    child: FloatingActionButton.extended(
                        heroTag: null,
                        label: Text(
                          'Publicar aviso',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {},
                        backgroundColor: Theme.of(context).accentColor,
                        icon: Icon(
                          Icons.subject,
                          color: Colors.white,
                        )),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                 Container(
                   
                    padding: EdgeInsets.only(bottom: 10),
                    child: FloatingActionButton.extended(
                      heroTag: null,
                        label: Text(
                          'Nova turma',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NovaTurma(
                                      disciplina: widget.disciplina,
                                      professor: widget.professor)));
                        },
                        backgroundColor: Theme.of(context).accentColor,
                        icon: Icon(
                          Icons.add,
                          color: Colors.white,
                        )),
                  ),
                ],
              )
            ],
          )),
      body: SingleChildScrollView(
          padding: edgesLeftRight,
          child: Column(
            children: <Widget>[
              Container(
                  height: 600,
                  padding: EdgeInsets.only(top: 5),
                  child: new FutureBuilder(
                    future: refDb
                        .collection('Turmas')
                        .where('idDiscTurma',
                            isEqualTo: widget.disciplina.docId)
                        .getDocuments(),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return Center(child: CircularProgressIndicator());
                        case ConnectionState.active:
                          return Center(child: CircularProgressIndicator());
                        case ConnectionState.none:
                          return Center(child: CircularProgressIndicator());
                        case ConnectionState.done:
                          {
                            List<DocumentSnapshot> documents =
                                snapshot.data.documents;
                            if (documents.length == 0) {
                              return Column(children: <Widget>[
                                Center(
                                    child: Icon(Icons.error_outline,
                                        size: 250,
                                        color: Theme.of(context).accentColor)),
                                Text('NENHUMA TURMA CRIADA',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                Container(
                                    padding:
                                        EdgeInsets.only(left: 30, right: 30),
                                    child: Text(
                                        'Toque no botão abaixo para criar uma nova turma',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 20)))
                              ]);
                            } else {
                              return createListView(
                                  documents, widget.disciplina);
                            }
                          }
                      }
                      return null;
                    },
                  ))
            ],
          )),
    );
  }
}
