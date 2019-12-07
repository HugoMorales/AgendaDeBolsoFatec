import 'package:agenda_fatec/models/Aviso.dart';
import 'package:agenda_fatec/models/Disciplina.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:agenda_fatec/models/Turma.dart';
/*  IMPORT DO FIRESTORE  */ import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agenda_fatec/utils.dart';

class NovoAviso extends StatefulWidget {
  NovoAviso({Key key, this.title, this.disciplina, this.turmas})
      : super(key: key);
  final String title;
  final Disciplina disciplina;
  final List<Turma> turmas;

  @override
  State<StatefulWidget> createState() => new _NovoAvisoState();
}

class _NovoAvisoState extends State<NovoAviso> {
  //Variables
  Aviso novoAviso;
  List<bool> checkboxes = new List.filled(9999, false);
  /* setando variável fazendo referencia ao banco */ Firestore refDb =
      Firestore.instance;

  //Edges
  final EdgeInsets edgesLeftRight = EdgeInsets.only(left: 25, right: 25);

  //Controllers
  final TextEditingController ctrlrTitulo = new TextEditingController();
  final TextEditingController ctrlrConteudo = new TextEditingController();

  //Input decorations
  final InputDecoration decTitulo =
      InputDecoration(border: OutlineInputBorder(), hintText: 'Título');
  final InputDecoration decConteudo =
      InputDecoration(border: OutlineInputBorder(), hintText: 'Conteúdo');

  //Button properties
  final BorderRadius radButton = new BorderRadius.circular(30);
  final double wdtButton = 150;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('Novo aviso'),
            centerTitle: true,
            textTheme: Theme.of(context).appBarTheme.textTheme),
        resizeToAvoidBottomInset: true,
        resizeToAvoidBottomPadding: true,
        body: SingleChildScrollView(
            padding: edgesLeftRight,
            child: Column(
              children: <Widget>[
                Container(
                    padding: EdgeInsets.only(top: 35, bottom: 5),
                    child: TextField(
                        //TextField Titulo
                        inputFormatters: [LengthLimitingTextInputFormatter(32)],
                        decoration: decTitulo,
                        controller: ctrlrTitulo)),
                Container(
                    padding: EdgeInsets.only(top: 5, bottom: 5),
                    child: TextField(
                        //TextField Conteudo
                        maxLines: 11,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(400)
                        ],
                        decoration: decConteudo,
                        controller: ctrlrConteudo)),
                Column(
                  children: <Widget>[
                    Container(
                        height: 100,
                        child: ListView.builder(
                          itemCount: widget.turmas.length,
                          itemBuilder: (context, i) {
                            return new CheckboxListTile(
                              title: Text(widget.turmas[i].nomeTurma),
                              value: checkboxes[i],
                              onChanged: (val) {
                                setState(() {
                                  checkboxes[i] = val;
                                });
                              },
                            );
                          },
                        ))
                  ],
                ),
                Container(
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  width: wdtButton,
                  child: RaisedButton(
                      //RaisedButton Publicar Anuncio
                      child: Text('Publicar anúncio'),
                      onPressed: () async {
                        if (checkboxes.contains(true)) {
                          String avisoID = await newDodID();
                          for (int i = 0; i < widget.turmas.length; i++) {
                            if (checkboxes[i]) {
                              novoAviso = new Aviso();
                              novoAviso.avisoID = avisoID;
                              novoAviso.titulo = ctrlrTitulo.text;
                              novoAviso.conteudo = ctrlrConteudo.text;
                              novoAviso.timestamp = generateTimestamp();
                              novoAviso.idTurma = widget.turmas[i].idTurma;
                              await refDb
                                  .collection('Avisos')
                                  .add(novoAviso.toJson());
                            }
                          }

                          ctrlrTitulo.text = '';
                          ctrlrConteudo.text = '';

                          createDialog('Aviso publicado', context);
                        } else {
                          createDialog(
                              'Selecione pelo menos uma turma para publicar o anúncio',
                              context);
                        }
                      },
                      shape: RoundedRectangleBorder(borderRadius: radButton),
                      color: Theme.of(context).accentColor,
                      textColor: Colors.white),
                )
              ],
            )));
  }
}
