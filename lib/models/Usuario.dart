import 'package:cloud_firestore/cloud_firestore.dart';

class Usuario{

  String _idUsuario;
  String _tipoUsuario; //1=Aluno; 2=Professor; 3=Administrador;

  //Constructor
  Usuario();

  //Getters
  String get idUsuario{
    return this._idUsuario;
  }

  String get tipoUsuario{
    return this._tipoUsuario;
  }

  //Setters
  set idUsuario(String idUsuario){
    this._idUsuario = idUsuario;
  }

  set tipoUsuario(String tipoUsuario){
    this._tipoUsuario = tipoUsuario;
  }

  toJson(){
    return{
      "tipoUsuario": _tipoUsuario
    };
  }

  fromSnapshot(DocumentSnapshot snapshot){
    this._idUsuario = snapshot.documentID;
    this._tipoUsuario = snapshot['tipoUsuario'];
  }

}