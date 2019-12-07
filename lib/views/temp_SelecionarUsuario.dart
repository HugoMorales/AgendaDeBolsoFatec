import 'package:agenda_fatec/views/aluno/view_listaDisciplinas.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agenda_fatec/views/professor/view_listaDisciplinas.dart';
import 'package:agenda_fatec/models/Aluno.dart';
import 'package:agenda_fatec/models/Professor.dart';
import 'package:agenda_fatec/utils.dart';

class SelecionarUsuario extends StatefulWidget {
  SelecionarUsuario({Key key, this.title}) : super(key: key);
  final String title;

  @override
  State<StatefulWidget> createState() => new _SelecionarUsuarioState();
}

class _SelecionarUsuarioState extends State<SelecionarUsuario> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: <Widget>[
        Center(
          child: Container(
              padding: EdgeInsets.only(left: 75, right: 75),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top: 100, bottom: 10),
                    child: RaisedButton(
                        onPressed: () async {
                          String codUsuario = 'HGFRCXebVEZe4xWW8IpT';
                          DocumentSnapshot snapshot = await Firestore.instance
                              .collection('Usuarios')
                              .document(codUsuario)
                              .get();
                          String tipoUsuario = findUsuario(snapshot);
                          if (tipoUsuario == 'Aluno') {
                            snapshot = await Firestore.instance
                                .collection('Alunos')
                                .document(codUsuario)
                                .get();
                            Aluno usuario = new Aluno();
                            usuario.fromSnapshot(snapshot);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ListaDisciplinasAluno(
                                          aluno: usuario,
                                        )));
                          } else {
                            snapshot = await Firestore.instance
                                .collection('Professores')
                                .document(codUsuario)
                                .get();
                            Professor usuario = new Professor();
                            usuario.fromSnapshot(snapshot);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ListaDisciplinasProf(
                                          professor: usuario,
                                        )));
                          }
                        },
                        child: Text('Visão Aluno')),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 10),
                    child: RaisedButton(
                        onPressed: () async {
                          String codUsuario = '5MK610ubsnKGfee3bJN0';
                          DocumentSnapshot snapshot = await Firestore.instance
                              .collection('Usuarios')
                              .document(codUsuario)
                              .get();
                          String tipoUsuario = findUsuario(snapshot);
                          if (tipoUsuario == 'Aluno') {
                            snapshot = await Firestore.instance
                                .collection('Alunos')
                                .document(codUsuario)
                                .get();
                            Aluno usuario = new Aluno();
                            usuario.fromSnapshot(snapshot);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ListaDisciplinasAluno(
                                          aluno: usuario,
                                        )));
                          } else {
                            snapshot = await Firestore.instance
                                .collection('Professores')
                                .document(codUsuario)
                                .get();
                            Professor usuario = new Professor();
                            usuario.fromSnapshot(snapshot);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ListaDisciplinasProf(
                                          professor: usuario,
                                        )));
                          }
                        },
                        child: Text('Visão Professor')),
                  )
                ],
              )),
        )
      ],
    ));
  }
}
