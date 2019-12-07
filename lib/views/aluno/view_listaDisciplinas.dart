import 'package:agenda_fatec/models/Aluno.dart';
import 'package:agenda_fatec/models/Turma.dart';
import 'package:flutter/material.dart';
import 'package:agenda_fatec/views/aluno/view_telaPrincipalTurma.dart';
import 'package:agenda_fatec/views/aluno/view_agendaAcademica.dart';
import 'package:agenda_fatec/views/aluno/view_entradaCodTurma.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Widget createListTile(BuildContext context, Turma turma, Aluno aluno) {
  String title = turma.discTurma;
  String leading = turma.siglaDiscTurma;
  String subtitle = turma.nomeTurma;

  return new Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(width: 1.5, color: Theme.of(context).accentColor)),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        title: Text(title,
            maxLines: 2,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20)),
        leading: Text(leading,
            maxLines: 1,
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        subtitle: Text(
          subtitle,
          maxLines: 1,
          textAlign: TextAlign.center,
        ),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      TelaPrincipalTurma(turma: turma, aluno: aluno)));
        },
      ));
}

Widget createListView(List<DocumentSnapshot> docs, Aluno aluno) {
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
      return createListTile(context, turmas[i], aluno);
    },
  );
}

class ListaDisciplinasAluno extends StatefulWidget {
  ListaDisciplinasAluno({Key key, this.title, this.aluno}) : super(key: key);
  final String title;
  final Aluno aluno;

  @override
  State<StatefulWidget> createState() => new _ListaDisciplinasAlunoState();
}

class _ListaDisciplinasAlunoState extends State<ListaDisciplinasAluno> {
  //Variables
  List<Turma> listaTurmas;
  Firestore refDb = Firestore.instance;

  //Edges
  final EdgeInsets edgesLeftRight = EdgeInsets.only(left: 5, right: 5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Disciplinas'),
        centerTitle: true,
        textTheme: Theme.of(context).appBarTheme.textTheme,
      ),
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        verticalDirection: VerticalDirection.up,
        children: <Widget>[
          Container(
              padding: EdgeInsets.only(top: 10),
              child: FloatingActionButton.extended(
                  heroTag: null,
                  onPressed: () {
                    Navigator.push(
                    context,
                        MaterialPageRoute(
                          builder: (context) => EntradaCodTurma(aluno: widget.aluno)));
                  },
                  backgroundColor: Theme.of(context).accentColor,
                  label: Text('Entrar em uma turma',
                      style: TextStyle(color: Colors.white)),
                  icon: Icon(
                    Icons.add,
                    color: Colors.white,
                  ))),
          FloatingActionButton.extended(
              heroTag: null,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            AgendaAcademica(aluno: widget.aluno)));
              },
              backgroundColor: Theme.of(context).accentColor,
              label: Text('Agenda', style: TextStyle(color: Colors.white)),
              icon: Icon(
                Icons.calendar_today,
                color: Colors.white,
              ))
        ],
      ),
      body: SingleChildScrollView(
          padding: edgesLeftRight,
          child: Column(
            children: <Widget>[
              Container(
                  height: 550,
                  padding: EdgeInsets.only(top: 5),
                  child: new FutureBuilder(
                    future: refDb
                        .collection('Turmas')
                        .where('listaAlunos',
                            arrayContains: widget.aluno.idUsuario)
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
                                Text(
                                  'VOCÊ NÃO FAZ PARTE DE NENHUMA DISCIPLINA',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                                Container(
                                    padding:
                                        EdgeInsets.only(left: 30, right: 30),
                                    child: Text(
                                        'Toque no botão abaixo para entrar com um código de turma',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 20)))
                              ]);
                            } else {
                              return createListView(documents, widget.aluno);
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
