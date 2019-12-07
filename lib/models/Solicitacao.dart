import 'package:cloud_firestore/cloud_firestore.dart';

class Solicitacao{
  String _idDoc;
  String _idAluno;
  String _idTurma;
  String _nomeAluno;
  String _raAluno;
  String _turnoAluno;
  String _semestreMatAluno;

  //Constructor
  Solicitacao();

  //Getters
  String get idDoc{
    return this._idDoc;
  }

  String get idAluno{
    return this._idAluno;
  }

  String get idTurma{
    return this._idTurma;
  }

  String get nomeAluno{
    return this._nomeAluno;
  }

  String get raAluno{
    return this._raAluno;
  }

  String get turnoAluno{
    return this._turnoAluno;
  }

  String get semestreMatAluno{
    return this._semestreMatAluno;
  }

  //Setters
  set idDoc(String idDoc){
    this._idDoc = idDoc;
  }

  set idAluno(String idAluno){
    this._idAluno = idAluno;
  }

  set idTurma(String idTurma){
    this._idTurma = idTurma;
  }

  set nomeAluno(String nomeAluno){
    this._nomeAluno = nomeAluno;
  }

  set raAluno(String raAluno){
    this._raAluno = raAluno;
  }

  set turnoAluno(String turnoAluno){
    this._turnoAluno = turnoAluno;
  }

  set semestreMatAluno(String semestreMatAluno){
    this._semestreMatAluno = semestreMatAluno;
  }

  toJson(){
    return{
      'idAluno': this._idAluno,
      'idTurma': this._idTurma,
      'nomeAluno': this._nomeAluno,
      'raAluno': this.raAluno,
      'turnoAluno': this._turnoAluno,
      'semestreMatAluno': this._semestreMatAluno
    };
  }

  fromSnapshot(DocumentSnapshot snapshot){
    this._idDoc = snapshot.documentID;
    this._idAluno = snapshot['idAluno'];
    this._idTurma = snapshot['idTurma'];
    this._nomeAluno = snapshot['nomeAluno'];
    this._raAluno = snapshot['raAluno'];
    this._turnoAluno = snapshot['turnoAluno'];
    this._semestreMatAluno = snapshot['semestreMatAluno'];
  }
}