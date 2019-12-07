import 'package:agenda_fatec/views/professor/view_listaDisciplinas.dart';
import 'package:agenda_fatec/views/view_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:agenda_fatec//views/view_login.dart';
//import 'package:agenda_fatec//views/admin/view_professorCadastro.dart';
import 'package:agenda_fatec/views/aluno/view_alunoCadastro.dart';
import 'package:agenda_fatec/views/temp_SelecionarUsuario.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    return new MaterialApp(
      title: 'TG',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
          primarySwatch: Colors.cyan,
          appBarTheme: AppBarTheme(
              textTheme: TextTheme(
                  title: TextStyle(color: Colors.white, fontSize: 25)))),
      //home: new Login()
      home: SelecionarUsuario(),
      //home: new Cadastro()
    );
  }
}
