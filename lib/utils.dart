import 'dart:core';
import 'dart:ffi';
import 'dart:io';
import 'package:agenda_fatec/models/Data.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter/services.dart';
import 'dart:math';
import 'models/Aluno.dart';
import 'models/Turma.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:agenda_fatec/models/Material.dart' as files;

bool validRA(String ra) {
  if (ra.length != 13) {
    return false;
  } else {
    int checkRa = int.tryParse(ra);
    if (checkRa == null) {
      return false;
    } else {
      if (ra.substring(0, 3) != "003") {
        return false;
      } else {
        return true;
      }
    }
  }
}

void createDialog(String _text, BuildContext context) {
  // flutter defined function
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        content: new Text(_text),
        actions: <Widget>[
          new FlatButton(
            child: new Text("Ok"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

String formatSigla(String sigla) {
  int nEspacos = 6 - sigla.length;

  for (int i = 0; i < nEspacos; i++) {
    sigla += ' ';
  }

  return sigla.toUpperCase();
}

String generateCodTurma() {
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  const numbers = '0123456789';
  String codTurma = '';

  Random rand = new Random(new DateTime.now().millisecondsSinceEpoch);

  for (var i = 0; i < 3; i++) {
    codTurma += chars[rand.nextInt(chars.length)];
  }

  for (var i = 0; i < 3; i++) {
    codTurma += numbers[rand.nextInt(numbers.length)];
  }

  return codTurma;
}

Future<String> newCodTurma() async {
  String codTurma;
  Firestore refDb = Firestore.instance;
  int listLength = 1;

  while (listLength != 0) {
    codTurma = generateCodTurma();
    listLength = (await refDb
            .collection('Turmas')
            .where('codTurma', isEqualTo: codTurma)
            .limit(1)
            .getDocuments())
        .documents
        .length;
  }

  return codTurma;
}

String generateSenhaProf() {
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvxyz0123456789';
  String senha = '';

  Random rand = new Random(new DateTime.now().millisecondsSinceEpoch);

  for (var i = 0; i < 12; i++) {
    senha += chars[rand.nextInt(chars.length)];
  }

  return senha;
}

String generateDocID() {
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  String docID = '';

  Random rand = new Random(new DateTime.now().millisecondsSinceEpoch);

  for (var i = 0; i < 20; i++) {
    docID += chars[rand.nextInt(chars.length)];
  }

  return docID;
}

Future<String> newDodID() async {
  String docID;
  Firestore refDb = Firestore.instance;
  int listLength = 1;

  while (listLength != 0) {
    docID = generateDocID();
    listLength = (await refDb
            .collection('Avisos')
            .where('avisoID', isEqualTo: docID)
            .limit(1)
            .getDocuments())
        .documents
        .length;
  }

  return docID;
}

String generateTimestamp() {
  DateTime now = DateTime.now();
  String timestamp;

  timestamp = now.day.toString() +
      '/' +
      now.month.toString() +
      '/' +
      now.year.toString() +
      ' - ' +
      now.hour.toString() +
      ':' +
      now.minute.toString();

  return timestamp;
}

String findUsuario(DocumentSnapshot snapshot) {
  String tipoUsuario;

  tipoUsuario = snapshot['tipoUsuario'];
  switch (tipoUsuario) {
    case '1':
      return 'Aluno';
      break;
    case '2':
      return 'Professor';
      break;
    case '3':
      return 'Administrador';
      break;
    default:
      return null;
  }
}

Future<List<Data>> getDatasAluno(Aluno aluno) async {
  List<Turma> turmas;
  List<Data> datas;
  Turma auxAdd;

  QuerySnapshot query = await Firestore.instance
      .collection('Turmas')
      .where('listaAlunos', arrayContains: aluno.idUsuario)
      .getDocuments();
  List<DocumentSnapshot> documents = query.documents;
  turmas = new List();

  int i = 0;
  while (i < documents.length) {
    auxAdd = new Turma();
    auxAdd.fromSnapshot(documents[i]);
    turmas.add(auxAdd);
    i++;
  }

  datas = await getDatas(turmas);

  return datas;
}

Future<List<Data>> getDatas(List<Turma> turmas) async {
  List<Data> datas = new List();
  int i = 0;

  while (i < turmas.length) {
    QuerySnapshot query = await Firestore.instance
        .collection('Datas')
        .where('idTurma', isEqualTo: turmas[i].idTurma)
        .getDocuments();
    List<DocumentSnapshot> documents = query.documents;
    int l = 0;
    Data auxData;
    while (l < documents.length) {
      auxData = new Data();
      auxData.fromSnapshot(documents[l]);
      datas.add(auxData);
      l++;
    }
    i++;
  }

  return datas;
}

String getFileName(File file) {
  String path = file.path;
  String parent = file.parent.toString();
  String filename;

  parent = parent.replaceAll("Directory: ", "").replaceAll("\'", "");
  filename = path.replaceAll(parent + '/', "");

  return filename;
}

Future<void> deleteTurma(Turma turma) async {
  QuerySnapshot query = await Firestore.instance
      .collection("Avisos")
      .where("idTurma", isEqualTo: turma.idTurma)
      .getDocuments();
  for (int i = 0; i < query.documents.length; i++) {
    await Firestore.instance
        .collection("Avisos")
        .document(query.documents[i].documentID)
        .delete();
  }

  query = await Firestore.instance
      .collection("Datas")
      .where("idTurma", isEqualTo: turma.idTurma)
      .getDocuments();
  for (int i = 0; i < query.documents.length; i++) {
    await Firestore.instance
        .collection("Datas")
        .document(query.documents[i].documentID)
        .delete();
  }

  query = await Firestore.instance
      .collection("Material")
      .where("idTurma", isEqualTo: turma.idTurma)
      .getDocuments();
  files.Material auxDelete;
  StorageReference refStorage;
  for (int i = 0; i < query.documents.length; i++) {
    auxDelete = files.Material();
    auxDelete.fromSnapshot(query.documents[i]);

    refStorage =
        FirebaseStorage.instance.ref().child(auxDelete.storageReference);
    await refStorage.delete();
    await Firestore.instance
        .collection("Material")
        .document(auxDelete.idDoc)
        .delete();
  }

  await Firestore.instance
      .collection("Turmas")
      .document(turma.idTurma)
      .delete();
}

abstract class BaseAuth {
  Future<String> signIn(String email, String password);

  Future<String> signUp(String email, String password);

  Future<FirebaseUser> getCurrentUser();

  Future<void> sendEmailVerification();

  Future<void> signOut();

  Future<bool> isEmailVerified();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> signIn(String email, String password) async {
    final FirebaseUser result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    //FirebaseUser user = result.user;
    return result.uid;
  }

  Future<String> signUp(String email, String password) async {
    final FirebaseUser result = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    //FirebaseUser user = result.user;
    return result.uid;
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }
}
