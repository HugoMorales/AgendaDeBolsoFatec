import 'package:agenda_fatec/models/Disciplina.dart';
import 'package:agenda_fatec/models/Professor.dart';
import 'package:flutter/material.dart';
import 'package:agenda_fatec/views/professor/view_novaDisciplina.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agenda_fatec/views/professor/view_listaTurmas.dart';

Widget createListTile(BuildContext context, Disciplina disciplina, Professor professor) {
  String title = disciplina.nome;
  String leading = disciplina.sigla;

  return new Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(width: 1.5, color: Theme.of(context).accentColor)),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal:15),
        title: Text(title,
            maxLines: 2,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20)),
        leading: Text(leading,
            maxLines: 1,
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        onTap: () {
          Navigator.push(context,
                MaterialPageRoute(builder: (context) => ListaTurmas(disciplina: disciplina, professor: professor)));
        },
      ));
}

Widget createListView(List<DocumentSnapshot> docs, Professor professor) {
  Disciplina auxAdd;
  List<Disciplina> disciplinas = new List();

  for (int i = 0; i < docs.length; i++) {
    auxAdd = new Disciplina();
    auxAdd.fromSnapshot(docs[i]);
    disciplinas.add(auxAdd);
  }

  return new ListView.builder(
    itemCount: disciplinas.length,
    itemBuilder: (context, i) {
      return createListTile(context, disciplinas[i], professor);
    },
  );
}

class ListaDisciplinasProf extends StatefulWidget {
  ListaDisciplinasProf({Key key, this.title, this.professor}) : super(key: key);
  final String title;
  final Professor professor;

  @override
  State<StatefulWidget> createState() => new _ListaDisciplinasProfState();
}

class _ListaDisciplinasProfState extends State<ListaDisciplinasProf> {
  //Variables
  List<Disciplina> listaDisciplinas;
  Firestore refDb = Firestore.instance;

  //Edges
  final EdgeInsets edgesLeftRight = EdgeInsets.only(left: 5, right: 5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Disciplinas'),
        centerTitle: true,
        textTheme:
            Theme.of(context).appBarTheme.textTheme,
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => NovaDisciplina(professor: widget.professor)));
          },
          backgroundColor: Theme.of(context).accentColor,
          child: Icon(
            Icons.add,
            color: Colors.white,
          )),
      body: SingleChildScrollView(
          padding: edgesLeftRight,
          child: Column(
            children: <Widget>[
              Container(
                  height: 550,
                  padding: EdgeInsets.only(top: 5),
                  child: new FutureBuilder(
                    future: refDb.collection('Disciplinas').where('idProfessor', isEqualTo: widget.professor.idUsuario).getDocuments(),
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
                                Center(child: Icon(Icons.error_outline, size: 250, color: Theme.of(context).accentColor)),
                                Text('NENHUMA DISCIPLINA CRIADA', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                Container(
                                    padding: EdgeInsets.only(left: 30, right: 30),
                                    child: Text('Toque no botão abaixo para criar uma nova disciplina', textAlign: TextAlign.center, style: TextStyle(fontSize: 20)) 
                                )
                              ]);
                            } else {
                              return createListView(documents, widget.professor);
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
