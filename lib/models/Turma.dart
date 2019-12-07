import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agenda_fatec/models/Aluno.dart';

class Turma{

  String _idTurma;
  String _nomeTurma;
  String _codTurma;
  String _idDiscTurma;
  String _nomeProfessor;
  String _siglaDiscTurma;
  String _discTurma;
  List<String> _listaAlunos;

  //Constructor
  Turma();

  //Getters
  String get idTurma{
    return this._idTurma;
  }

  String get nomeTurma{
    return this._nomeTurma;
  }

  String get codTurma{
    return this._codTurma;
  }

  String get idDiscTurma{
    return this._idDiscTurma;
  }

  String get nomeProfessor{
    return this.nomeProfessor;
  }

  String get siglaDiscTurma{
    return this._siglaDiscTurma;
  }

  String get discTurma{
    return this._discTurma;
  }

  List<String> get listaAlunos{
    return this._listaAlunos;
  }

  //Setters
  set idTurma(String idTurma){
    this._idTurma = idTurma;
  }

  set nomeTurma(String nomeTurma){
    this._nomeTurma = nomeTurma;
  }

  set codTurma(String codTurma){
    this._codTurma = codTurma;
  }

  set idDiscTurma(String idDiscTurma){
    this._idDiscTurma = idDiscTurma;
  }

  set nomeProfessor(String nomeProfessor){
    this._nomeProfessor = nomeProfessor;
  }

  set siglaDiscTurma(String siglaDiscTurma){
    this._siglaDiscTurma = siglaDiscTurma;
  }

  set discTurma(String discTurma){
    this._discTurma = discTurma;
  }

  set listaAlunos(List<String> listaAlunos){
    this._listaAlunos = listaAlunos;
  }

  addNovoAluno(String novoAluno){
    this._listaAlunos.add(novoAluno);
  }

  toJson(){
    return{
      "nomeTurma": _nomeTurma,
      "codTurma": _codTurma,
      "idDiscTurma": _idDiscTurma,
      "nomeProfessor": _nomeProfessor,
      "siglaDiscTurma": _siglaDiscTurma,
      "discTurma": _discTurma,
      "listaAlunos": _listaAlunos.toList()
    };
  }

  fromSnapshot(DocumentSnapshot snapshot){
    _idTurma = snapshot.documentID;
    _nomeTurma = snapshot['nomeTurma'];
    _codTurma = snapshot['codTurma'];
    _idDiscTurma = snapshot['idDiscTurma'];
    _nomeProfessor = snapshot['nomeProfessor'];
    _siglaDiscTurma = snapshot['siglaDiscTurma'];
    _discTurma = snapshot['discTurma'];
    _listaAlunos = List.from(snapshot['listaAlunos']);
  }

}