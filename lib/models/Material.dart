import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

class Material{
  String _idDoc;
  String _idTurma;
  String _nomeArquivo;
  String _publicURL;
  String _storageReference;
  File _file;

//Constructor
Material();

//Getters
get idDoc{
  return this._idDoc;
}

get idTurma{
  return this._idTurma;
}

get nomeArquivo{
  return this._nomeArquivo;
}

get publicURL{
  return this._publicURL;
}

get storageReference{
  return this._storageReference;
}

get file{
  return this._file;
}

//Setters
set idDoc(String idDoc){
  this._idDoc = idDoc;
}

set idTurma(String idTurma){
  this._idTurma = idTurma;
}

set nomeArquivo(String nomeArquivo){
  this._nomeArquivo = nomeArquivo;
}

set publicURL(String publicURL){
  this._publicURL = publicURL;
}

set storageReference(String storageReference){
  this._storageReference = storageReference;
}

set file(File file){
  this._file = file;
}

toJson(){
  return{
    'idTurma': this._idTurma,
    'nomeArquivo': this._nomeArquivo,
    'publicURL': this._publicURL,
    'storageReference': this._storageReference
  };
}

fromSnapshot(DocumentSnapshot snapshot){
  this._idDoc = snapshot.documentID;
  this.idTurma = snapshot['idTurma'];
  this._nomeArquivo = snapshot['nomeArquivo'];
  this._publicURL = snapshot['publicURL'];
  this._storageReference = snapshot['storageReference'];
}
}