import 'package:cloud_firestore/cloud_firestore.dart';

class Aviso {

  String _docID;
  String _avisoID;
  String _titulo;
  String _conteudo;
  String _timestamp;
  String _idTurma;

  //Constructor
  Aviso();

  //Getters
  String get docID{
    return this._docID;
  }

  String get avisoID{
    return this._avisoID;
  }

  String get titulo{
    return this._titulo;
  }

  String get conteudo{
    return this._conteudo;
  }

  String get timestamp{
    return this._timestamp;
  }

  String get idTurma{
    return this._idTurma;
  }

  //Setters
  set docID(String docId){
    this._docID = docId;
  }

  set avisoID(String avisoID){
    this._avisoID = avisoID;
  }

  set titulo(String titulo){
    this._titulo = titulo;
  }

  set conteudo(String conteudo){
    this._conteudo = conteudo;
  }

  set timestamp(String timestamp){
    this._timestamp = timestamp;
  }

  set idTurma(String idTurma){
    this._idTurma = idTurma;
  }

  toJson(){
    return{
      "avisoID": _avisoID,
      "titulo": _titulo,
      "conteudo": _conteudo,
      "timestamp": _timestamp,
      "idTurma": _idTurma
    };
  }

  fromSnapshot(DocumentSnapshot snapshot){
    this._docID = snapshot.documentID;
    this._avisoID = snapshot['avisoID'];
    this._titulo = snapshot['titulo'];
    this._conteudo = snapshot['conteudo'];
    this._timestamp = snapshot['timestamp'];
    this.idTurma = snapshot['idTurma'];
  }
}