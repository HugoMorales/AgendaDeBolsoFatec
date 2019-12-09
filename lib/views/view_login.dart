import 'package:agenda_fatec/models/Aluno.dart';
import 'package:agenda_fatec/models/Professor.dart';
import 'package:agenda_fatec/models/Usuario.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:agenda_fatec/views/aluno/view_alunoCadastro.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agenda_fatec/utils.dart';
import 'package:agenda_fatec/views/aluno/view_listaDisciplinas.dart'
    as homeAluno;
import 'package:agenda_fatec/views/professor/view_listaDisciplinas.dart'
    as homeProfessor;
import 'package:agenda_fatec/views/admin/view_professorCadastro.dart'
    as homeAdmin;

class Login extends StatefulWidget {
  Login({Key key, this.title, this.auth, this.loginCallback}) : super(key: key);
  final String title;
  final BaseAuth auth;
  final VoidCallback loginCallback;

  @override
  State<StatefulWidget> createState() => new _LoginState();
}

class _LoginState extends State<Login> {
  //Edges
  final EdgeInsets edgesLeftRight = EdgeInsets.only(left: 25, right: 25);

  //Controllers
  final TextEditingController ctrlrEmail = new TextEditingController();
  final TextEditingController ctrlrSenha = new TextEditingController();

  //TextField decorations
  final InputDecoration decEmail =
      InputDecoration(border: OutlineInputBorder(), hintText: 'E-mail');
  final InputDecoration decSenha =
      InputDecoration(border: OutlineInputBorder(), hintText: 'Senha');

  //Button properties
  final BorderRadius radButton = new BorderRadius.circular(30);
  final double wdtButton = 150;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Agenda de Bolso Fatec'),
          centerTitle: true,
          textTheme: Theme.of(context).appBarTheme.textTheme,
        ),
        resizeToAvoidBottomInset: true,
        resizeToAvoidBottomPadding: true,
        body: SingleChildScrollView(
          padding: edgesLeftRight,
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 25),
                child: FlutterLogo(
                  size: 175,
                ),
              ),
              Container(
                  //TextField Email
                  padding: EdgeInsets.only(top: 25, bottom: 5),
                  child: TextField(
                      inputFormatters: [LengthLimitingTextInputFormatter(75)],
                      decoration: decEmail,
                      controller: ctrlrEmail,
                      keyboardType: TextInputType.emailAddress)),
              Container(
                  //TextField Senha
                  padding: EdgeInsets.only(top: 5, bottom: 10),
                  child: TextField(
                    inputFormatters: [LengthLimitingTextInputFormatter(20)],
                    obscureText: true,
                    decoration: decSenha,
                    controller: ctrlrSenha,
                  )),
              Container(
                  //RaisedButton Login
                  padding: EdgeInsets.only(top: 10, bottom: 5),
                  width: wdtButton,
                  child: RaisedButton(
                      child: Text('Login'),
                      onPressed: () async {
                        String email = ctrlrEmail.text;
                        String senha = ctrlrSenha.text;

                        if (email == "" || senha == "") {
                          createDialog(
                              "Preencha todos os campos para realizar login",
                              context);
                        } else {
                          String userId = "";
                          Auth auth = new Auth();
                          //FirebaseUser actualUser = await auth.getCurrentUser();
                          //if(actualUser != null) {
                            //await auth.signOut();
                         // }

                          userId = await auth.signIn(email, senha);
                          if (userId.length <= 0) {
                            createDialog(
                                'Não foi possível efeturar login\nPor favor verifique suas credenciais',
                                context);
                          } else {
                            Usuario user = new Usuario();
                            DocumentSnapshot doc = await Firestore.instance
                                .collection("Usuarios")
                                .document(userId)
                                .get();
                            user.fromSnapshot(doc);
                            if (user.tipoUsuario == "1") {
                              Aluno aluno = new Aluno();
                              doc = await Firestore.instance
                                  .collection("Alunos")
                                  .document(user.idUsuario)
                                  .get();
                              aluno.fromSnapshot(doc);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          homeAluno.ListaDisciplinasAluno(
                                              aluno: aluno)));
                            } else if (user.tipoUsuario == "2") {
                              Professor professor = new Professor();
                              doc = await Firestore.instance
                                  .collection("Professores")
                                  .document(user.idUsuario)
                                  .get();
                              professor.fromSnapshot(doc);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          homeProfessor.ListaDisciplinasProf(
                                              professor: professor)));
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          homeAdmin.Cadastro()));
                            }
                          }
                        }
                      },
                      shape: RoundedRectangleBorder(borderRadius: radButton),
                      color: Theme.of(context).accentColor,
                      textColor: Colors.white)),
              Container(
                  //RaisedButton Criar conta
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  width: wdtButton,
                  child: RaisedButton(
                    child: Text('Criar conta'),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Cadastro()));
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: radButton,
                        side: BorderSide(color: Theme.of(context).accentColor)),
                    color: Colors.white,
                    textColor: Theme.of(context).accentColor,
                  )),
            ],
          ),
        ));
  }
}
