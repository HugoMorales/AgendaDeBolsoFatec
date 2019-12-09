import 'package:agenda_fatec/models/Usuario.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agenda_fatec/models/Professor.dart';
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
  final TextEditingController ctrlrEmail = new TextEditingController();
  final TextEditingController ctrlrSenha = new TextEditingController();

  //Input decorations
  final InputDecoration decNome =
      InputDecoration(border: OutlineInputBorder(), hintText: 'Nome');
  final InputDecoration decEmail =
      InputDecoration(border: OutlineInputBorder(), hintText: 'E-mail');
  final InputDecoration decSenha = InputDecoration(
      border: OutlineInputBorder(borderSide: BorderSide(width: 5)));

  //Button properties
  final BorderRadius radButton = new BorderRadius.circular(30);
  final double wdtButton = 150;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Criar conta para um professor',
              style: TextStyle(fontSize: 19)),
          centerTitle: true,
          textTheme: Theme.of(context).appBarTheme.textTheme),
      resizeToAvoidBottomInset: true,
      resizeToAvoidBottomPadding: true,
      body: SingleChildScrollView(
        padding: edgesLeftRight,
        child: Column(
          children: <Widget>[
            Container(
                //TextField Nome
                padding: EdgeInsets.only(top: 35, bottom: 5),
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
              padding: EdgeInsets.only(top: 25, bottom: 5),
              width: wdtButton,
              child: RaisedButton(
                  //RaisedButton Criar conta
                  child: Text('Criar conta'),
                  onPressed: () async {
                    String nome = ctrlrNome.text;
                    String email = ctrlrEmail.text;

                    if (nome.length == 0 || email.length == 0) {
                      createDialog(
                          "Erro ao criar conta\nVerifique se todos os dados estão preenchidos corretamente",
                          context);
                    } else {
                      Auth auth = new Auth();
                      Usuario user = new Usuario();
                      Professor professor = new Professor();
                      String senha = generateSenhaProf();

                      String userId = await auth.signUp(email, senha);

                      user.tipoUsuario = "2";
                      professor.nome = nome;
                      professor.idUsuario = userId;

                      await Firestore.instance
                          .collection("Usuarios")
                          .document(userId)
                          .setData(user.toJson());
                      await Firestore.instance
                          .collection("Professores")
                          .document(userId)
                          .setData(professor.toJson());

                      createDialog("Conta criada com sucesso!", context);
                      setState(() {
                        ctrlrSenha.text = senha;
                      });
                    }
                  },
                  shape: RoundedRectangleBorder(borderRadius: radButton),
                  color: Theme.of(context).accentColor,
                  textColor: Colors.white),
            ),
            Container(
                padding: EdgeInsets.only(top: 100, bottom: 10),
                child: Text(
                  'Senha gerada',
                  style: TextStyle(fontSize: 20),
                )),
            Container(
                padding:
                    EdgeInsets.only(left: 50, right: 50, top: 10, bottom: 10),
                child: TextField(
                    textAlign: TextAlign.center,
                    enabled: false,
                    controller: ctrlrSenha,
                    decoration: decSenha)),
            Container(
                height: 60,
                child: Center(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      padding: EdgeInsets.only(left: 10, right: 5),
                      icon: Icon(
                        Icons.assignment,
                        color: Theme.of(context).accentColor,
                      ),
                      iconSize: 50,
                      onPressed: () {
                        Clipboard.setData(
                            new ClipboardData(text: ctrlrSenha.text));
                      },
                    ),
                  ],
                )))
          ],
        ),
      ),
    );
  }
}
