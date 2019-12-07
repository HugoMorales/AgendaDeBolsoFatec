import 'package:flutter/material.dart';
import 'package:agenda_fatec/models/Turma.dart';
import 'package:agenda_fatec/models/Data.dart';
import 'package:agenda_fatec/views/professor/view_visualizarData.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agenda_fatec/models/Material.dart' as files;

Widget buildAbaMaterial(BuildContext context, Turma turma) {
  return Container(
    height: 500,
    padding: EdgeInsets.only(top: 5, bottom: 5),
    child: FutureBuilder(
        future: Firestore.instance
            .collection('Material')
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
                List<files.Material> arquivos = new List();
                files.Material aux;

                if (documents.length == 0) {
                  return Column(children: <Widget>[
                    Center(
                        child: Icon(Icons.error_outline,
                            size: 250, color: Theme.of(context).accentColor)),
                    Text('NENHUM MATERIAL NA NUVEM',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    Container(
                        padding: EdgeInsets.only(left: 30, right: 30),
                        child: Text(
                            'Toque no botão abaixo realizar o upload de arquivos',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20)))
                  ]);
                } else {
                  for (int i = 0; i < documents.length; i++) {
                    aux = new files.Material();
                    aux.fromSnapshot(documents[i]);
                    arquivos.add(aux);
                  }

                  return new ListView.builder(
                    itemCount: arquivos.length,
                    itemBuilder: (context, i) {
                      String title = arquivos[i].nomeArquivo;

                      return new Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                              side: BorderSide(
                                  width: 1.5,
                                  color: Theme.of(context).accentColor)),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            leading: Icon(Icons.description,
                                color: Theme.of(context).accentColor, size: 40),
                            trailing: IconButton(
                              icon: Icon(Icons.delete,
                                  color: Colors.red, size: 30),
                              onPressed: () async {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: Text(
                                            'Tem certeza que deseja excluir ' +
                                                arquivos[i].nomeArquivo +
                                                '?'),
                                        actions: <Widget>[
                                          new FlatButton(
                                            child: Text('Cancelar'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          new FlatButton(
                                            child: Text('Sim'),
                                            onPressed: () async {
                                              StorageReference refStorage =
                                                  FirebaseStorage.instance
                                                      .ref()
                                                      .child(arquivos[i]
                                                          .storageReference);
                                              await refStorage.delete();
                                              await Firestore.instance
                                                  .collection('Material')
                                                  .document(arquivos[i].idDoc)
                                                  .delete();
                                              Navigator.of(context).pop();
                                            },
                                          )
                                        ],
                                      );
                                    });
                               arquivos.remove(i);
                              },
                            ),
                            title: Text(title,
                                maxLines: 2,
                                textAlign: TextAlign.left,
                                style: TextStyle(fontSize: 20)),
                          ));
                    },
                  );
                }
              }
          }
          return null;
        }),
  );
}
