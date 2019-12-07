import 'dart:io';
import 'package:agenda_fatec/models/Aluno.dart';
import 'package:agenda_fatec/models/Data.dart';
import 'package:agenda_fatec/models/Turma.dart';
import 'package:agenda_fatec/utils.dart';
import 'package:agenda_fatec/views/aluno/view_visualizarData.dart';
import 'package:flutter/material.dart';
import 'package:agenda_fatec/views/aluno/view_visualizarData.dart';
import 'package:flutter/services.dart';
import 'package:agenda_fatec/models/Material.dart' as files;
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

Future<List<files.Material>> uploadFiles(
    List<files.Material> toUpload) async {
  StorageUploadTask uploadTask;
  for (int i = 0; i < toUpload.length; i++) {
    StorageReference storageRef = FirebaseStorage.instance
        .ref()
        .child(toUpload[i].idTurma + "/" + toUpload[i].nomeArquivo);
    uploadTask = storageRef.putFile(toUpload[i].file);
    StorageTaskSnapshot uploadedFile = await uploadTask.onComplete;
    toUpload[i].publicURL = await uploadedFile.ref.getDownloadURL();
    toUpload[i].storageReference = uploadedFile.ref.path;
    await Firestore.instance.collection('Material').add(toUpload[i].toJson());
  }

  return toUpload;
}

class UploadMaterial extends StatefulWidget {
  UploadMaterial({Key key, this.title, this.turma}) : super(key: key);
  final String title;
  final Turma turma;
  //final List<Turma> turmas;

  @override
  State<StatefulWidget> createState() => new _UploadMaterialState();
}

class _UploadMaterialState extends State<UploadMaterial> {
  //Variables
  StorageReference refStorage = FirebaseStorage.instance.ref();
  List<File> filesUpload = new List();
  List<files.Material> listaArquivos = new List();
  bool _uploading = false;

  int countList(List<files.Material> list) {
    if (list == null) {
      return 0;
    } else {
      return list.length;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !_uploading,
      child:Scaffold(
        appBar: AppBar(
          title: Text('Upload de material'),
          centerTitle: true,
          textTheme: Theme.of(context).appBarTheme.textTheme,
        ),
        floatingActionButton: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          verticalDirection: VerticalDirection.up,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 5),
              child: FloatingActionButton.extended(
                heroTag: null,
                backgroundColor: Theme.of(context).accentColor,
                icon: Icon(Icons.cloud_upload, color: Colors.white),
                label: Text(
                  'Realizar upload de arquivos',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  if (countList(listaArquivos) == 0) {
                    createDialog(
                        'Selecione pele menos um arquivo para upload', context);
                  } else {
                    setState(() {
                      _uploading = true;
                    });
                    await uploadFiles(listaArquivos);
                    setState(() {
                      _uploading = false;
                    });
                    createDialog('Upload de arquivos completo', context);
                  }
                  listaArquivos = new List();
                },
              ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 5),
              child: FloatingActionButton.extended(
                heroTag: null,
                icon: Icon(Icons.add, color: Colors.white),
                label: Text(
                  'Adicionar arquivos',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  List<File> pickedFiles = await FilePicker.getMultiFile();
                  if (pickedFiles != null) {
                    files.Material aux;
                    for (int i = 0; i < pickedFiles.length; i++) {
                      aux = new files.Material();
                      aux.nomeArquivo = getFileName(pickedFiles[i]);
                      aux.file = pickedFiles[i];
                      aux.idTurma = widget.turma.idTurma;
                      listaArquivos.add(aux);
                    }
                    setState(() {});
                  }
                },
              ),
            )
          ],
        ),
        body: ModalProgressHUD(
          dismissible: false,
          color: Colors.grey,
          opacity: 0.5,
          progressIndicator: Container(
            decoration: BoxDecoration(color: Colors.white ,borderRadius: BorderRadius.circular(20)),
              height: 100, width: 250,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(),
                  Container(height: 10),
                  Text(
                    'Realizando upload de arquivos',
                  ),
                ],
              )),
          inAsyncCall: _uploading,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      'Turma: ' + widget.turma.nomeTurma,
                      style: TextStyle(fontSize: 25),
                      textAlign: TextAlign.center,
                      maxLines: 3,
                    )),
                Container(
                    padding: EdgeInsets.all(10),
                    height: 540,
                    child: ListView.builder(
                      itemCount: countList(listaArquivos),
                      itemBuilder: (context, i) {
                        String title = listaArquivos[i].nomeArquivo;
                        return new Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                                side: BorderSide(
                                    width: 1.5,
                                    color: Theme.of(context).accentColor)),
                            child: ListTile(
                              leading: Icon(Icons.description,
                                  color: Theme.of(context).accentColor),
                              title: Text(title,
                                  maxLines: 2,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontSize: 20)),
                            ));
                      },
                    ))
              ],
            ),
          ),
     ) ));
  }
}
