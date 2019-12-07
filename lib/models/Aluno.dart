import 'package:cloud_firestore/cloud_firestore.dart';

class Aluno {
  String _ra;
  String _idUsuario;
  String _nome;
  String _semestreMat;
  String _turno;

  //Construcor
  Aluno();

  //Getters
  String get ra {
    return this._ra;
  }

  String get idUsuario {
    return this._idUsuario;
  }

  String get nome {
    return this._nome;
  }

  String get semestreMat {
    return this._semestreMat;
  }

  String get turno {
    return this._turno;
  }

  //Setters
  set ra(String ra) {
    this._ra = ra;
  }

  set idUsuario(String idUsuario) {
    this._idUsuario = idUsuario;
  }

  set nome(String nome) {
    this._nome = nome;
  }

  set semestreMat(String semestreMat) {
    this._semestreMat = semestreMat;
  }

  set turno(String turno) {
    this._turno = turno;
  }

  findSemestreMatricula(String ra) {
    String ano;
    String semestre;

    ano = '20' + ra.substring(6, 2);
    semestre = ra.substring(8, 1);

    if (semestre == '1')
      this._semestreMat = '1º Sem/' + ano;
    else
      this._semestreMat = '2º Sem/' + ano;
  }

  findTurno(String ra) {
    String turno;

    turno = ra.substring(9, 1);
    switch (turno) {
      case '1':
        {
          this._turno = 'Matutino';
        }
        break;

      case '2':
        {
          this._turno = 'Vespertino';
        }
        break;

      case '30':
        {
          this._turno = 'Noturno';
        }
        break;
      default:
    }
  }

  toJson() {
    return {
      "ra": this._ra,
      "nome": this._nome,
      "semestreMat": this._semestreMat,
      "turno": this._turno
    };
  }

  fromSnapshot(DocumentSnapshot snapshot) {
    this._idUsuario = snapshot.documentID;
    this._ra = snapshot['ra'];
    this._nome = snapshot['nome'];
    this._semestreMat = snapshot['semestreMat'];
    this._turno = snapshot['turno'];
  }
}
