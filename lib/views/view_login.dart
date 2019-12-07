import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:agenda_fatec/views/aluno/view_alunoCadastro.dart';

class Login extends StatefulWidget {
  Login({Key key, this.title}) : super(key: key);
  final String title;

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
          title: Text('Agenda de bolso fatecana'),
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
                      onPressed: () {},
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
