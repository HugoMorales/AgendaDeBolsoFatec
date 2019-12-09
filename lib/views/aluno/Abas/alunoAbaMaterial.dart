import 'package:agenda_fatec/utils.dart';
import 'package:flutter/material.dart';
import 'package:agenda_fatec/models/Turma.dart';
import 'package:agenda_fatec/models/Data.dart';
import 'package:agenda_fatec/views/professor/view_visualizarData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:agenda_fatec/models/Material.dart' as files;
import 'package:folder_picker/folder_picker.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<String> downloadFile(files.Material arquivo, Turma turma) async {
  StorageReference ref = FirebaseStorage.instance.ref().child(arquivo.storageReference);
  String downloadURL = arquivo.publicURL;
  final http.Response downloadData = await http.get(downloadURL);
    Directory appRoot = await getExternalStorageDirectory();
    Directory downloadDirectory = new Directory(appRoot.path + "/" + turma.nomeTurma);
    bool dirExists = await downloadDirectory.exists();
    
    if(!dirExists){
      await downloadDirectory.create();
    }

    final File tempFile = File('${downloadDirectory.path}/' + arquivo.nomeArquivo);
    if (tempFile.existsSync()) {
      await tempFile.delete();
    }
    await tempFile.create();
    final StorageFileDownloadTask task = ref.writeToFile(tempFile);
    final int byteCount = (await task.future).totalByteCount;
    var bodyBytes = downloadData.bodyBytes;
    final String name = await ref.getName();
    final String path = await ref.getPath();
    print(
      'Success!\nDownloaded $name \nUrl: $downloadURL'
      '\npath: $path \nBytes Count :: $byteCount',
    );

    return (tempFile.path);
}

Widget createListTileData(BuildContext context, files.Material arquivo, Turma turma) {
  String title = arquivo.nomeArquivo;

  return new Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(width: 1.5, color: Theme.of(context).accentColor)),
      child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
          child: ListTile(
            leading: Icon(Icons.description,
                color: Theme.of(context).accentColor, size: 40),
            trailing: IconButton(
              icon: Icon(Icons.cloud_download,
                  color: Theme.of(context).accentColor, size: 30),
              onPressed: () async {
                createDialog("Arquivo será baixado\nEspere o diálogo de confirmação ao final do download", context);
                String filePath = await downloadFile(arquivo, turma);
                createDialog("download concluído!\nO arquivo se encontra em " + filePath, context);
              },
            ),
            title: Text(title,
                maxLines: 3,
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 20)),
          )));
}

Widget buildAbaMaterial(BuildContext context, Turma turma) {
  return Container(
      height: 510,
      child: Scaffold(
          body: Container(
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
                        List<DocumentSnapshot> documents =
                            snapshot.data.documents;
                        List<files.Material> arquivos = new List();
                        files.Material aux;

                        if (documents.length == 0) {
                          return Column(children: <Widget>[
                            Center(
                                child: Icon(Icons.error_outline,
                                    size: 250,
                                    color: Theme.of(context).accentColor)),
                            Text('NENHUM MATERIAL NA NUVEM',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            Container(
                                padding: EdgeInsets.only(left: 30, right: 30),
                                child: Text(
                                    'O material disponibilizado pelo seu professor aparecerá aqui',
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
                              return createListTileData(context, arquivos[i], turma);
                            },
                          );
                        }
                      }
                  }
                  return null;
                }),
          )));
}
