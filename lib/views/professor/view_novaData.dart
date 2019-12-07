import 'package:agenda_fatec/models/Aviso.dart';
import 'package:agenda_fatec/models/Disciplina.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:agenda_fatec/models/Turma.dart';
import 'package:agenda_fatec/models/Data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agenda_fatec/utils.dart';

class NovaData extends StatefulWidget {
  NovaData({Key key, this.title, this.turma}) : super(key: key);
  final String title;
  final Turma turma;

  @override
  State<StatefulWidget> createState() => new _NovaDataState();
}

class _NovaDataState extends State<NovaData> {
  //Variables
  Data novaData;
  DateTime selectedDate = DateTime.now();
  Firestore refDb = Firestore.instance;

  //Edges
  final EdgeInsets edgesLeftRight = EdgeInsets.only(left: 25, right: 25);

  //Controllers
  final TextEditingController ctrlrTitulo = new TextEditingController();
  final TextEditingController ctrlrConteudo = new TextEditingController();
  final TextEditingController ctrlrDataMarcada = new TextEditingController();

  //Input decorations
  final InputDecoration decTitulo =
      InputDecoration(border: OutlineInputBorder(), hintText: 'Título');
  final InputDecoration decConteudo =
      InputDecoration(border: OutlineInputBorder(), hintText: 'Conteúdo');
  final InputDecoration decDataMarcada =
      InputDecoration(border: OutlineInputBorder(), hintText: 'Data marcada');

  //Button properties
  final BorderRadius radButton = new BorderRadius.circular(30);
  final double wdtButton = 150;

  Future<String> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate:
            DateTime(selectedDate.year, selectedDate.month, selectedDate.day),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
    return selectedDate.day.toString() +
        '/' +
        selectedDate.month.toString() +
        '/' +
        selectedDate.year.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('Nova data'),
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
                    child: Center(
                        child: Row(
                      children: <Widget>[
                        Container(
                          width: 175,
                          child: TextField(
                            //TextField Data Marcada
                            enabled: false,
                            textAlign: TextAlign.center,
                            decoration: decDataMarcada,
                            controller: ctrlrDataMarcada,
                          ),
                        ),
                        Container(
                          width: 135,
                          child: Center(
                              //RaisedButton Selecionar Data
                              child: RaisedButton(
                            child: Text('Selecionar'),
                            shape:
                                RoundedRectangleBorder(borderRadius: radButton),
                            color: Theme.of(context).accentColor,
                            textColor: Colors.white,
                            onPressed: () async {
                              ctrlrDataMarcada.text =
                                  await _selectDate(context);
                            },
                          )),
                        )
                      ],
                    ))),
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
                Container(
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  width: wdtButton,
                  child: RaisedButton(
                      //RaisedButton Marcar Data
                      child: Text('Marcar Data'),
                      onPressed: () async {
                        if (ctrlrDataMarcada.text != '') {
                          novaData = new Data();
                          novaData.timestamp = generateTimestamp();
                          novaData.titulo = ctrlrTitulo.text;
                          novaData.conteudo = ctrlrConteudo.text;
                          novaData.dataMarcada = selectedDate;
                          novaData.idTurma = widget.turma.idTurma;
                          novaData.nomeDisciplina = widget.turma.discTurma;
                          await refDb
                              .collection('Datas')
                              .add(novaData.toJson());
                          ctrlrConteudo.text = '';
                          ctrlrTitulo.text = '';
                          ctrlrDataMarcada.text = '';
                          createDialog('Data marcada com sucesso.', context);
                        } else
                          createDialog('Selecione uma data.', context);
                      },
                      shape: RoundedRectangleBorder(borderRadius: radButton),
                      color: Theme.of(context).accentColor,
                      textColor: Colors.white),
                )
              ],
            )));
  }
}
