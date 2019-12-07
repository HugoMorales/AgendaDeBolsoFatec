import 'package:agenda_fatec/models/Aluno.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:agenda_fatec/models/Turma.dart';
import 'package:agenda_fatec/models/Material.dart' as files;
import 'package:agenda_fatec/views/aluno/Abas/alunoAbaAvisos.dart';
import 'package:agenda_fatec/views/aluno/Abas/alunoAbaDatas.dart';
import 'package:agenda_fatec/views/aluno/Abas/alunoAbaMaterial.dart';
import 'package:agenda_fatec/utils.dart';

Widget buildAba(BuildContext context, int indexAba,
    Turma turma) {
  if (indexAba == 0) {
    //AbaAvisos
    return buildAbaAvisos(context, turma);
  } else if (indexAba == 1) {
    return buildAbaDatas(context, turma);
  } else {
      return buildAbaMaterial(context, turma);
  }
}

class TelaPrincipalTurma extends StatefulWidget {
  TelaPrincipalTurma(
      {Key key, this.title, @required this.turma, this.aluno})
      : super(key: key);
  final String title;
  final Turma turma;
  final Aluno aluno;

  @override
  State<StatefulWidget> createState() => new _TelaPrincipalTurmaState();
}

class _TelaPrincipalTurmaState extends State<TelaPrincipalTurma> {
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  //Variables
  int _currentIndex = 0;

  //Edges
  final EdgeInsets edgesLeftRight = EdgeInsets.only(left: 5, right: 5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(widget.turma.discTurma),
            centerTitle: true,
            textTheme: Theme.of(context).appBarTheme.textTheme),
        //floatingActionButton: buildFloatingButton(context, _currentIndex,
          //  widget.disciplina, widget.turma, widget.turmas, widget.aluno),
        bottomNavigationBar: BottomNavigationBar(
          onTap: onTabTapped,
          currentIndex: _currentIndex,
          unselectedItemColor: Colors.grey,
          selectedItemColor: Theme.of(context).accentColor,
          selectedFontSize: 15,
          elevation: 10,
          items: [
            new BottomNavigationBarItem(
                icon: Icon(Icons.subject), title: Text('Avisos')),
            new BottomNavigationBarItem(
                icon: Icon(Icons.event), title: Text('Datas')),
            new BottomNavigationBarItem(
                icon: Icon(Icons.school), title: Text('Material')),
          ],
        ),
        body: SingleChildScrollView(
          padding: edgesLeftRight,
          child: Column(
            children: <Widget>[
              buildAba(context, _currentIndex, widget.turma),
            ],
          ),
        ));
  }
}
