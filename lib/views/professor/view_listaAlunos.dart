import 'package:agenda_fatec/models/Aluno.dart';
import 'package:agenda_fatec/models/Data.dart';
import 'package:async/async.dart';
import 'package:agenda_fatec/models/Turma.dart';
import 'package:agenda_fatec/utils.dart';
import 'package:agenda_fatec/views/aluno/view_visualizarData.dart';
import 'package:flutter/material.dart';
import 'package:agenda_fatec/views/aluno/view_visualizarData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class ListaAlunos extends StatefulWidget {
  ListaAlunos({Key key, this.title, this.turma}) : super(key: key);
  final String title;
  final Turma turma;
  //final List<Turma> turmas;

  @override
  State<StatefulWidget> createState() => new _ListaAlunosState();
}

class _ListaAlunosState extends State<ListaAlunos> {
  //Variables
  List<bool> checkboxes = new List.filled(9999, false);
  AsyncMemoizer _asyncMemoizer = AsyncMemoizer();

  Future<List<Aluno>> getAlunosTurma(List<String> listaAlunos) async {
    List<Aluno> alunos = new List();
    Aluno aux;

    for (int i = 0; i < listaAlunos.length; i++) {
      DocumentSnapshot doc = await Firestore.instance
          .collection('Alunos')
          .document(listaAlunos[i])
          .get();
      aux = new Aluno();
      aux.fromSnapshot(doc);
      alunos.add(aux);
    }
    return alunos;
  }

  _fetchData(List<String> listaAlunos) {
    return this._asyncMemoizer.runOnce(() async {
      List<Aluno> alunos = await getAlunosTurma(listaAlunos);
      return alunos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Lista de alunos'),
          centerTitle: true,
          textTheme: Theme.of(context).appBarTheme.textTheme,
        ),
        floatingActionButton: FloatingActionButton.extended(
          icon: Icon(Icons.delete, color: Colors.white),
          label: Text(
            'Excluir alunos',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () async {
            if (checkboxes.contains(true)) {
              List<String> toRemove = new List();
              for (int i = 0; i < widget.turma.listaAlunos.length; i++) {
                if (checkboxes[i]) {
                  toRemove.add(widget.turma.listaAlunos[i]);
                }
              }

              for (int i = 0; i < toRemove.length; i++) {
                widget.turma.listaAlunos.remove(toRemove[i]);
              }

              await Firestore.instance
                  .collection('Turmas')
                  .document(widget.turma.idTurma)
                  .updateData({'listaAlunos': widget.turma.listaAlunos});

                  setState(() {
                    _asyncMemoizer = new AsyncMemoizer();
                    checkboxes.fillRange(0, 9999, false);
                  });
            } else {
              createDialog('Selecione pelo menos uma aluno para excluir da turma',
                  context);
            }
          },
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    'Turma: ' + widget.turma.nomeTurma,
                    style: TextStyle(fontSize: 25),
                    textAlign: TextAlign.center,
                    maxLines: 3,
                  )),
              Container(
                  padding: EdgeInsets.all(10),
                  height: 580,
                  child: FutureBuilder(
                      future: _fetchData(widget.turma.listaAlunos),
                      builder: (context, alunos) {
                        switch (alunos.connectionState) {
                          case ConnectionState.waiting:
                            return Center(child: CircularProgressIndicator());
                          case ConnectionState.active:
                            return Center(child: CircularProgressIndicator());
                          case ConnectionState.none:
                            return Center(child: CircularProgressIndicator());
                          case ConnectionState.done:
                            {
                              List<Aluno> listaAlunos = alunos.data;
                              if (listaAlunos.length == 0)
                                return Column(children: <Widget>[
                                  Center(
                                      child: Icon(Icons.error_outline,
                                          size: 250,
                                          color:
                                              Theme.of(context).accentColor)),
                                  Text('NENHUM ALUNO NA TURMA',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  Container(
                                      padding:
                                          EdgeInsets.only(left: 30, right: 30),
                                      child: Text(
                                          'A lista de alunos que participam da turma será exibida aqui',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 20)))
                                ]);
                              else {
                                return Column(
                                  children: <Widget>[
                                    Container(
                                        padding: EdgeInsets.all(5),
                                        height: 500,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Theme.of(context)
                                                    .accentColor,
                                                style: BorderStyle.solid,
                                                width: 3),
                                            borderRadius:
                                                BorderRadius.circular(25)),
                                        child: ListView.builder(
                                          itemCount: listaAlunos.length,
                                          itemBuilder: (context, i) {
                                            String title = listaAlunos[i].nome;
                                            String subtitle =
                                                listaAlunos[i].ra +
                                                    " - " +
                                                    listaAlunos[i].turno +
                                                    " - " +
                                                    listaAlunos[i].semestreMat;

                                            return new Card(
                                                elevation: 5,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    side: BorderSide(
                                                        width: 1.5,
                                                        color: Theme.of(context)
                                                            .accentColor)),
                                                child: CheckboxListTile(
                                                  value: checkboxes[i],
                                                  onChanged: (val) {
                                                    setState(() {
                                                      checkboxes[i] = val;
                                                    });
                                                  },
                                                  title: Text(title,
                                                      maxLines: 1,
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                          fontSize: 20)),
                                                  subtitle: Text(
                                                    subtitle,
                                                    maxLines: 1,
                                                    textAlign: TextAlign.left,
                                                    style:
                                                        TextStyle(fontSize: 11),
                                                  ),
                                                ));
                                          },
                                        )
                                        )
                                  ],
                                );
                              }
                            }
                        }
                        return null;
                      }))
            ],
          ),
        ));
  }
}
