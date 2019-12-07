import 'package:agenda_fatec/models/Professor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:agenda_fatec/models/Disciplina.dart';
import 'package:agenda_fatec/models/Turma.dart';
import 'package:agenda_fatec/views/professor/Abas/profAbaAvisos.dart';
import 'package:agenda_fatec/views/professor/Abas/profAbaDatas.dart';
import 'package:agenda_fatec/views/professor/Abas/profAbaMaterial.dart';
import 'package:agenda_fatec/views/professor/Abas/profAbaOpcoes.dart';
import 'package:agenda_fatec/views/professor/view_novoAviso.dart';
import 'package:agenda_fatec/views/professor/view_novaData.dart';
import 'package:agenda_fatec/views/professor/view_uploadMaterial.dart';
import 'package:agenda_fatec/models/Material.dart' as files;
import 'package:agenda_fatec/utils.dart';

Widget buildFloatingButton(
    BuildContext context,
    int currentIndex,
    Disciplina disciplina,
    Turma turma,
    List<Turma> turmas,
    Professor professor) {
  if (currentIndex != 3) {
    return FloatingActionButton(
        onPressed: () {
          if (currentIndex == 0) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        NovoAviso(disciplina: disciplina, turmas: turmas)));
          } else if (currentIndex == 1) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NovaData(turma: turma)));
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        UploadMaterial(turma: turma)));
          }
        },
        backgroundColor: Theme.of(context).accentColor,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ));
  } else
    return null;
}

Widget buildAba(BuildContext context, int indexAba, Disciplina disciplina,
    Turma turma, List<Turma> turmas) {
  if (indexAba == 0) {
    //AbaAvisos
    return buildAbaAvisos(context, turma);
  } else if (indexAba == 1) {
    return buildAbaDatas(context, turma);
  } else {
    if (indexAba == 3)
      return buildAbaOpcoes(context, turma, disciplina);
    else {
      return buildAbaMaterial(context, turma);
    }
  }
}

class TelaPrincipalTurma extends StatefulWidget {
  TelaPrincipalTurma(
      {Key key,
      this.title,
      this.disciplina,
      @required this.turma,
      this.turmas,
      this.professor})
      : super(key: key);
  final String title;
  final Disciplina disciplina;
  final Turma turma;
  final List<Turma> turmas;
  final Professor professor;

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
            title: Text(widget.turma.nomeTurma),
            centerTitle: true,
            textTheme: Theme.of(context).appBarTheme.textTheme),
        floatingActionButton: buildFloatingButton(context, _currentIndex,
            widget.disciplina, widget.turma, widget.turmas, widget.professor),
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
            new BottomNavigationBarItem(
                icon: Icon(Icons.settings), title: Text('Opções')),
          ],
        ),
        body: SingleChildScrollView(
          padding: edgesLeftRight,
          child: Column(
            children: <Widget>[
              buildAba(context, _currentIndex, widget.disciplina, widget.turma,
                  widget.turmas),
            ],
          ),
        ));
  }
}
