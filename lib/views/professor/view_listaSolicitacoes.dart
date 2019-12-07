import 'package:agenda_fatec/models/Aluno.dart';
import 'package:agenda_fatec/models/Data.dart';
import 'package:agenda_fatec/models/Solicitacao.dart';
import 'package:agenda_fatec/models/Turma.dart';
import 'package:agenda_fatec/utils.dart';
import 'package:agenda_fatec/views/aluno/view_visualizarData.dart';
import 'package:flutter/material.dart';
import 'package:agenda_fatec/views/aluno/view_visualizarData.dart';
import 'package:flutter/services.dart';
import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ListaSolicitacoes extends StatefulWidget {
  ListaSolicitacoes({Key key, this.title, this.turma})
      : super(key: key);
  final String title;
  final Turma turma;
  //final List<Turma> turmas;

  @override
  State<StatefulWidget> createState() => new _ListaSolicitacoesState();
}

class _ListaSolicitacoesState extends State<ListaSolicitacoes> {
  //Variables
  AsyncMemoizer _asyncMemoizer = new AsyncMemoizer();
  Firestore refDb = Firestore.instance;
  List<bool> checkboxes = new List.filled(9999, false);
  List<Solicitacao> solicitacoes;

  _fetchData(Turma turma) {
    return _asyncMemoizer.runOnce(() async {
      return await refDb
          .collection('Solicitacoes')
          .where("idTurma", isEqualTo: turma.idTurma)
          .getDocuments();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Lista de solicitações'),
          centerTitle: true,
          textTheme: Theme.of(context).appBarTheme.textTheme,
        ),
        floatingActionButton: Column(
          verticalDirection: VerticalDirection.up,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 5),
              child: FloatingActionButton.extended(
                heroTag: null,
                backgroundColor: Colors.red,
                icon: Icon(Icons.delete, color: Colors.white),
                label: Text(
                  'Excluir alunos selecionados',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {},
              ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 5),
              child: FloatingActionButton.extended(
                heroTag: null,
                icon: Icon(Icons.done, color: Colors.white),
                label: Text(
                  'Aceitar alunos selecionados',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  if (checkboxes.contains(true)) {
                    for (int i = 0; i < solicitacoes.length; i++) {
                      if (checkboxes[i]) {
                        widget.turma.addNovoAluno(solicitacoes[i].idAluno);
                        await refDb
                            .collection('Solicitacoes')
                            .document(solicitacoes[i].idDoc)
                            .delete();
                      }
                    }
                    await refDb
                        .collection('Turmas')
                        .document(widget.turma.idTurma)
                        .updateData(
                            {'listaAlunos': widget.turma.listaAlunos.toList()});
                    createDialog(
                        'Alunos selecionados adcionados para a lista de alunos da turma',
                        context);
                    setState(() {
                      _asyncMemoizer = new AsyncMemoizer();
                      checkboxes.fillRange(0, 9999, false);
                    });
                  } else {
                    createDialog(
                        'Selecione pelo menos uma solicitação para aceitar',
                        context);
                  }
                },
              ),
            )
          ],
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
                      future: _fetchData(widget.turma),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return Center(child: CircularProgressIndicator());
                          case ConnectionState.active:
                            return Center(child: CircularProgressIndicator());
                          case ConnectionState.none:
                            return Center(child: CircularProgressIndicator());
                          case ConnectionState.done:
                            {
                              QuerySnapshot query = snapshot.data;
                              Solicitacao aux;
                              solicitacoes = new List();

                              for (int i = 0; i < query.documents.length; i++) {
                                aux = new Solicitacao();
                                aux.fromSnapshot(query.documents[i]);
                                solicitacoes.add(aux);
                              }

                              if (solicitacoes.length == 0)
                                return Column(children: <Widget>[
                                  Center(
                                      child: Icon(Icons.error_outline,
                                          size: 250,
                                          color:
                                              Theme.of(context).accentColor)),
                                  Text('NENHUMA SOLICITAÇÃO',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  Container(
                                      padding:
                                          EdgeInsets.only(left: 30, right: 30),
                                      child: Text(
                                          'As solicitações enviadas por alunos aparecerão aqui',
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
                                              color:
                                                  Theme.of(context).accentColor,
                                              style: BorderStyle.solid,
                                              width: 3),
                                          borderRadius:
                                              BorderRadius.circular(25)),
                                      child: ListView.builder(
                                        itemCount: solicitacoes.length,
                                        itemBuilder: (context, i) {
                                          String title =
                                              solicitacoes[i].nomeAluno;
                                          String subtitle = solicitacoes[i]
                                                  .raAluno +
                                              " - " +
                                              solicitacoes[i].turnoAluno +
                                              " - " +
                                              solicitacoes[i].semestreMatAluno;
                                          return new Card(
                                              elevation: 5,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
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
                                      ),
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
