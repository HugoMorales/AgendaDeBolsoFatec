import 'package:agenda_fatec/models/Usuario.dart';
import 'package:agenda_fatec/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agenda_fatec/models/Aluno.dart';
import 'package:agenda_fatec/utils.dart';

class Cadastro extends StatefulWidget {
  Cadastro({Key key, this.title}) : super(key: key);
  final String title;

  @override
  State<StatefulWidget> createState() => new _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  //Edges
  final EdgeInsets edgesLeftRight = EdgeInsets.only(left: 25, right: 25);

  //Controllers
  final TextEditingController ctrlrNome = new TextEditingController();
  final TextEditingController ctrlrRa = new TextEditingController();
  final TextEditingController ctrlrEmail = new TextEditingController();
  final TextEditingController ctrlrSenha = new TextEditingController();
  final TextEditingController ctrlrConfirmSenha = new TextEditingController();

  //Input decorations
  final InputDecoration decNome =
      InputDecoration(border: OutlineInputBorder(), hintText: 'Nome');
  final InputDecoration decRa =
      InputDecoration(border: OutlineInputBorder(), hintText: 'RA');
  final InputDecoration decEmail =
      InputDecoration(border: OutlineInputBorder(), hintText: 'E-mail');
  final InputDecoration decSenha =
      InputDecoration(border: OutlineInputBorder(), hintText: 'Senha');
  final InputDecoration decConfirmSenha = InputDecoration(
      border: OutlineInputBorder(), hintText: 'Confirmar senha');

  //Button properties
  final BorderRadius radButton = new BorderRadius.circular(30);
  final double wdtButton = 150;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Criar conta'),
          centerTitle: true,
          textTheme: Theme.of(context).appBarTheme.textTheme),
      resizeToAvoidBottomInset: true,
      resizeToAvoidBottomPadding: true,
      body: SingleChildScrollView(
        padding: edgesLeftRight,
        child: Column(
          children: <Widget>[
            Container(
              //TextField RA
              padding: EdgeInsets.only(top: 35, bottom: 5),
              child: TextField(
                inputFormatters: [LengthLimitingTextInputFormatter(13)],
                decoration: decRa,
                controller: ctrlrRa,
                keyboardType: TextInputType.number,
              ),
            ),
            Container(
                //TextField Nome
                padding: EdgeInsets.only(top: 5, bottom: 5),
                child: TextField(
                  inputFormatters: [LengthLimitingTextInputFormatter(200)],
                  decoration: decNome,
                  controller: ctrlrNome,
                )),
            Container(
                //TextField Email
                padding: EdgeInsets.only(top: 5, bottom: 5),
                child: TextField(
                  inputFormatters: [LengthLimitingTextInputFormatter(75)],
                  decoration: decEmail,
                  controller: ctrlrEmail,
                  keyboardType: TextInputType.emailAddress,
                )),
            Container(
              //TextField Senha
              padding: EdgeInsets.only(top: 5, bottom: 5),
              child: TextField(
                  inputFormatters: [LengthLimitingTextInputFormatter(20)],
                  obscureText: true,
                  decoration: decSenha,
                  controller: ctrlrSenha),
            ),
            Container(
                //TextField Confirm senha
                padding: EdgeInsets.only(top: 5, bottom: 5),
                child: TextField(
                    inputFormatters: [LengthLimitingTextInputFormatter(20)],
                    obscureText: true,
                    decoration: decConfirmSenha,
                    controller: ctrlrConfirmSenha)),
            Container(
              padding: EdgeInsets.only(top: 25, bottom: 5),
              width: wdtButton,
              child: RaisedButton(
                  //RaisedButton Criar conta
                  child: Text('Criar conta'),
                  onPressed: () async {
                    String ra = ctrlrRa.text;
                    String nome = ctrlrNome.text;
                    String email = ctrlrEmail.text;
                    String senha = ctrlrSenha.text;
                    String confirmSenha = ctrlrConfirmSenha.text;

                    if (ra.length == 0 ||
                        nome.length == 0 ||
                        email.length == 0 ||
                        senha.length == 0 ||
                        senha != confirmSenha) {
                      createDialog(
                          "Erro ao criar conta\nVerifique se todos os dados estão preenchidos corretamente",
                          context);
                    } else {
                      if (!validRA(ra)) {
                        createDialog("Informe um RA válido", context);
                      } else {
                        Auth auth = new Auth();
                        String userId = await auth.signUp(email, senha);
                        if (userId.length > 0) {
                          Aluno aluno = new Aluno();
                          Usuario user = new Usuario();
                          aluno.ra = ra;
                          aluno.nome = nome;
                          print(ra);
                          aluno.findSemestreMatricula(ra);
                          aluno.findTurno(ra);
                          aluno.idUsuario = userId;
                          user.tipoUsuario = "1";
                          await Firestore.instance
                              .collection("Usuarios")
                              .document(userId)
                              .setData(user.toJson());
                          await Firestore.instance
                              .collection("Alunos")
                              .document(userId)
                              .setData(aluno.toJson());
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              // return object of type Dialog
                              return AlertDialog(
                                content: new Text("Conta criada com sucesso!"),
                                actions: <Widget>[
                                  new FlatButton(
                                    child: new Text("Ok"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                          ;
                        }
                      }
                    }
                  },
                  shape: RoundedRectangleBorder(borderRadius: radButton),
                  color: Theme.of(context).accentColor,
                  textColor: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
