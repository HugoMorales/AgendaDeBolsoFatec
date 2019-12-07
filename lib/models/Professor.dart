import 'package:cloud_firestore/cloud_firestore.dart';

class Professor{

  String _idUsuario;
  String _nome;
  
  //Constructor
  Professor();

  //Getters
  String get idUsuario{
    return this._idUsuario;
  }

  String get nome{
    return this._nome;
  }

  //Setters
  set idUsuario(String idUsuario){
    this._idUsuario = idUsuario;
  }

  set nome(String nome){
    this._nome = nome;
  }

  toJson(){
    return{
      'nome': this._nome
    };
  }

  fromSnapshot(DocumentSnapshot snapshot){
    this._idUsuario = snapshot.documentID;
    this._nome = snapshot['nome'];
  }
}