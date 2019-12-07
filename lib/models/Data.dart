import 'package:cloud_firestore/cloud_firestore.dart';

class Data {
  String _docID;
  String _titulo;
  String _conteudo;
  DateTime _dataMarcada;
  String _timestamp;
  String _idTurma;
  String _nomeDisciplina;

  //Constructor
  Data();

  //Getters
  String get docID {
    return this._docID;
  }

  String get titulo {
    return this._titulo;
  }

  String get conteudo {
    return this._conteudo;
  }

  DateTime get dataMarcada {
    return this._dataMarcada;
  }

  String get timestamp {
    return this._timestamp;
  }

  String get idTurma {
    return this._idTurma;
  }

  String get nomeDisciplina {
    return this._nomeDisciplina;
  }

  //Setters
  set docID(String docId) {
    this._docID = docId;
  }

  set titulo(String titulo) {
    this._titulo = titulo;
  }

  set conteudo(String conteudo) {
    this._conteudo = conteudo;
  }

  set dataMarcada(DateTime dataMarcada) {
    this._dataMarcada = dataMarcada;
  }

  set timestamp(String timestamp) {
    this._timestamp = timestamp;
  }

  set idTurma(String idTurma) {
    this._idTurma = idTurma;
  }

  set nomeDisciplina(String nomeDisciplina) {
    this._nomeDisciplina = nomeDisciplina;
  }

  String formatDataMarcada() {
    return this._dataMarcada.day.toString() +
        '/' +
        this._dataMarcada.month.toString() +
        '/' +
        this._dataMarcada.year.toString();
  }

  String formatDataToWrite() {
    return this._dataMarcada.year.toString() +
        '-' +
        this._dataMarcada.month.toString() +
        '-' +
        this._dataMarcada.day.toString();
  }

  toJson() {
    return {
      "titulo": _titulo,
      "conteudo": _conteudo,
      "dataMarcada": formatDataToWrite(),
      "timestamp": _timestamp,
      "idTurma": _idTurma,
      "nomeDisciplina": _nomeDisciplina
    };
  }

  fromSnapshot(DocumentSnapshot snapshot) {
    this._docID = snapshot.documentID;
    this._titulo = snapshot['titulo'];
    this._conteudo = snapshot['conteudo'];
    this._dataMarcada = DateTime.parse(snapshot['dataMarcada']);
    this._timestamp = snapshot['timestamp'];
    this.idTurma = snapshot['idTurma'];
    this.nomeDisciplina = snapshot['nomeDisciplina'];
  }
}
