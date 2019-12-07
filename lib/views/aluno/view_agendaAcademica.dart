import 'package:agenda_fatec/models/Aluno.dart';
import 'package:agenda_fatec/models/Data.dart';
import 'package:agenda_fatec/models/Turma.dart';
import 'package:agenda_fatec/utils.dart';
import 'package:agenda_fatec/views/aluno/view_visualizarData.dart';
import 'package:flutter/material.dart';
import 'package:agenda_fatec/views/aluno/view_visualizarData.dart';
import 'package:flutter/services.dart';

Widget createListTile(BuildContext context, Data data) {
  String title = data.titulo;
  String leading = data.formatDataMarcada();
  String subtitle = data.nomeDisciplina;

  return new Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(width: 1.5, color: Theme.of(context).accentColor)),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        title: Text(title,
            maxLines: 2,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20)),
        leading: Text(leading,
            maxLines: 1,
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        subtitle: Text(
          subtitle,
          maxLines: 1,
          textAlign: TextAlign.center,
        ),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => VisualisarData(data: data)));
        },
      ));
}

Widget createListView(List<Data> datas) {
  return new ListView.builder(
    itemCount: datas.length,
    itemBuilder: (context, i) {
      return createListTile(context, datas[i]);
    },
  );
}

class AgendaAcademica extends StatefulWidget {
  AgendaAcademica({Key key, this.title, this.aluno}) : super(key: key);
  final String title;
  final Aluno aluno;
  //final List<Turma> turmas;

  @override
  State<StatefulWidget> createState() => new _AgendaAcademicaState();
}

class _AgendaAcademicaState extends State<AgendaAcademica> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Agenda acadêmica'),
          centerTitle: true,
          textTheme: Theme.of(context).appBarTheme.textTheme,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(10),
                  height: 560,
                  child: FutureBuilder(
                      future: getDatasAluno(widget.aluno),
                      builder: (context, datas) {
                        switch (datas.connectionState) {
                          case ConnectionState.waiting:
                            return Center(child: CircularProgressIndicator());
                          case ConnectionState.active:
                            return Center(child: CircularProgressIndicator());
                          case ConnectionState.none:
                            return Center(child: CircularProgressIndicator());
                          case ConnectionState.done:
                            {
                              List<Data> datasAluno = datas.data;
                              if (datasAluno.length == 0)
                                return Column(children: <Widget>[
                                  Center(
                                      child: Icon(Icons.error_outline,
                                          size: 250,
                                          color:
                                              Theme.of(context).accentColor)),
                                  Text('NENHUMA DATA MARCADA',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  Container(
                                      padding:
                                          EdgeInsets.only(left: 30, right: 30),
                                      child: Text(
                                          'As datas marcadas pelos seus professores aparecerão aqui',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 20)))
                                ]);
                              else {
                                datasAluno.sort((a, b) {
                                  return a.timestamp.compareTo(b.timestamp);
                                });
                                return Column(
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.all(20),
                                      height: 540,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color:
                                                  Theme.of(context).accentColor,
                                              style: BorderStyle.solid,
                                              width: 3),
                                          borderRadius:
                                              BorderRadius.circular(25)),
                                      child: createListView(datasAluno),
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
