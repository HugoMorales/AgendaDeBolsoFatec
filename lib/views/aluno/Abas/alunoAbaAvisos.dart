import 'package:flutter/material.dart';
import 'package:agenda_fatec/models/Turma.dart';
import 'package:agenda_fatec/models/Aviso.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agenda_fatec/views/aluno/view_visualizarAviso.dart';

Widget createListTileAviso(BuildContext context, Aviso aviso) {
  String title = aviso.titulo;

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
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => VisualisarAviso(aviso: aviso)));
        },
      ));
}

Widget buildAbaAvisos(BuildContext context, Turma turma) {
  return Container(
      height: 500,
        padding: EdgeInsets.only(top: 5, bottom: 5),
        child: FutureBuilder(
            future: Firestore.instance
                .collection('Avisos')
                .where('idTurma', isEqualTo: turma.idTurma)
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
                    List<DocumentSnapshot> documents = snapshot.data.documents;
                    if (documents.length == 0) {
                      return Column(children: <Widget>[
                        Center(
                            child: Icon(Icons.error_outline,
                                size: 250,
                                color: Theme.of(context).accentColor)),
                        Text('NENHUM AVISO PUBLICADO',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        Container(
                            padding: EdgeInsets.only(left: 30, right: 30),
                            child: Text(
                                'Os avisos publicados pelo seu professor vão aparecer aqui',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 20)))
                      ]);
                    } else {
                      List<Aviso> avisos = new List();
                      Aviso auxAviso;

                      for (int i = 0; i < documents.length; i++) {
                        auxAviso = new Aviso();
                        auxAviso.fromSnapshot(documents[i]);
                        avisos.add(auxAviso);
                      }

                      return new ListView.builder(
                        itemCount: avisos.length,
                        itemBuilder: (context, i) {
                          return createListTileAviso(context, avisos[i]);
                        },
                      );
                    }
                  }
              }
              return null;
            }),
    );
}