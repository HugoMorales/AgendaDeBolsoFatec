import 'package:agenda_fatec/models/Aluno.dart';
import 'package:agenda_fatec/models/Disciplina.dart';
import 'package:agenda_fatec/utils.dart';
import 'package:flutter/material.dart';
import 'package:agenda_fatec/models/Turma.dart';
import 'package:agenda_fatec/models/Material.dart' as files;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:agenda_fatec/views/professor/view_codTurma.dart';
import 'package:agenda_fatec/views/professor/view_listaAlunos.dart';
import 'package:agenda_fatec/views/professor/view_listaSolicitacoes.dart';

Widget buildAbaOpcoes(
    BuildContext context, Turma turma, Disciplina disciplina) {
  return Container(
    padding: EdgeInsets.only(top: 5),
    height: 500,
    child: Column(children: <Widget>[
      Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side:
                  BorderSide(width: 1.5, color: Theme.of(context).accentColor)),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            leading: Icon(
              Icons.group,
              color: Theme.of(context).accentColor,
              size: 40,
            ),
            title: Text('Lista de alunos',
                maxLines: 1,
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 20)),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ListaAlunos(turma: turma)));
            },
          )),
      Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side:
                  BorderSide(width: 1.5, color: Theme.of(context).accentColor)),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            leading: Icon(Icons.group_add,
                color: Theme.of(context).accentColor, size: 40),
            title: Text('Solicitações pendentes',
                maxLines: 1,
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 20)),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ListaSolicitacoes(turma: turma)));
            },
          )),
      Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side:
                  BorderSide(width: 1.5, color: Theme.of(context).accentColor)),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            leading: Icon(Icons.school,
                color: Theme.of(context).accentColor, size: 40),
            title: Text('Código de turma',
                maxLines: 1,
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 20)),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          CodTurma(codTurma: turma.codTurma)));
            },
          )),
      Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(width: 1.5, color: Colors.red)),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            leading: Icon(Icons.delete, color: Colors.red, size: 40),
            title: Text('Excluir turma',
                maxLines: 1,
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 20)),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Text('Tem certeza que deseja excluir ' +
                          turma.nomeTurma +
                          'e todo o seu conteúdo?'),
                      actions: <Widget>[
                        new FlatButton(
                          child: Text('Cancelar'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        new FlatButton(
                          child: Text('Sim'),
                          onPressed: () async {
                            await deleteTurma(turma);

                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    );
                  });
            },
          )),
    ]),
  );
}
