import 'package:cloud_firestore/cloud_firestore.dart';

class Disciplina{

  String _docId;
  String _sigla;
  String _nome;
  String _nomeProfessor;
  String _idProfessor;

  //Constructor
  Disciplina();

  //Getters
  String get docId{
    return this._docId;
  }

  String get sigla{
    return this._sigla;
  }

  String get nome{
    return this._nome;
  }

  String get nomeProfessor{
    return this._nomeProfessor;
  }

  String get idProfessor{
    return this._idProfessor;
  }

  //Setters
  set docId(String docId){
    this._docId = docId;
  }

  set sigla(String sigla){
    this._sigla = sigla;
  }

  set nome(String nome){
    this._nome = nome;
  }

  set nomeProfessor(String nomeProfessor){
    this._nomeProfessor = nomeProfessor;
  }

  set idProfessor(String idProfessor){
    this._idProfessor = idProfessor;
  }

  toJson(){
    return{
      "sigla": _sigla,
      "nome": _nome,
      "nomeProfessor": _nomeProfessor,
      "idProfessor": _idProfessor
    };
  }

  fromSnapshot(DocumentSnapshot snapshot){
    this._docId = snapshot.documentID;
    this._sigla = snapshot['sigla'];
    this._nome = snapshot['nome'];
    this._nomeProfessor = snapshot['nomeProfessor'];
    this._idProfessor = snapshot['idProfessor'];
  }
}