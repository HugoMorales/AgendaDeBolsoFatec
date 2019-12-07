import 'package:flutter/material.dart';
import 'package:agenda_fatec/models/Turma.dart';
import 'package:agenda_fatec/models/Data.dart';
import 'package:agenda_fatec/views/aluno/view_visualizarData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Widget createListTileData(BuildContext context, Data data) {
  String title = data.titulo;
  String trailing = data.formatDataMarcada();

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
        trailing: Text(trailing, 
            maxLines: 1,
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 14)),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => VisualisarData(data: data)));
        },
      ));
}

Widget buildAbaDatas(BuildContext context, Turma turma) {
  return Container(
    height: 500,
    padding: EdgeInsets.only(top: 5, bottom: 5),
    child: FutureBuilder(
        future: Firestore.instance
            .collection('Datas')
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
                            size: 250, color: Theme.of(context).accentColor)),
                    Text('NENHUMA DATA MARCADA',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    Container(
                        padding: EdgeInsets.only(left: 30, right: 30),
                        child: Text(
                            'As datas marcadas pelo seu professor vão aparecer aqui',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20)))
                  ]);
                } else {
                  List<Data> datas = new List();
                  Data auxData;

                  for (int i = 0; i < documents.length; i++) {
                    auxData = new Data();
                    auxData.fromSnapshot(documents[i]);
                    datas.add(auxData);
                  }

                  return new ListView.builder(
                    itemCount: datas.length,
                    itemBuilder: (context, i) {
                      return createListTileData(context, datas[i]);
                    },
                  );
                }
              }
          }
          return null;
        }),
  );
}
