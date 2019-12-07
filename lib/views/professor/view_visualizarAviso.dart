import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agenda_fatec/models/Aviso.dart';

class VisualisarAviso extends StatefulWidget {
  VisualisarAviso({Key key, this.title, this.aviso}) : super(key: key);
  final String title;
  final Aviso aviso;

  @override
  State<StatefulWidget> createState() => new _VisualisarAvisoState();
}

class _VisualisarAvisoState extends State<VisualisarAviso> {
  //Variables
  Firestore refDb = Firestore.instance;

  //Edges
  final EdgeInsets edgesLeftRight = EdgeInsets.only(left: 5, right: 5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.aviso.titulo),
          centerTitle: true,
          textTheme: Theme.of(context).appBarTheme.textTheme),
      body: SingleChildScrollView(
        padding: edgesLeftRight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                padding: EdgeInsets.only(top: 5),
                child: Text(widget.aviso.titulo,
                    maxLines: 2,
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 30))),
            Container(
                child: Text(widget.aviso.timestamp,
                    textAlign: TextAlign.left,
                    style:
                        TextStyle(fontSize: 13, fontWeight: FontWeight.w300))),
            Container(
                height: 320,
                padding: EdgeInsets.only(top: 10),
                child: Text(widget.aviso.conteudo,
                    textAlign: TextAlign.left, style: TextStyle(fontSize: 20))),
            Container(
                height: 150,
                child: Center(
                  child: RawMaterialButton(
                    onPressed: () async {
                      QuerySnapshot query = await refDb.collection('Avisos').where('avisoID', isEqualTo: widget.aviso.avisoID).getDocuments();
                      for(int i = 0; i < query.documents.length; i++)
                        await refDb.collection('Avisos').document(query.documents[i].documentID).delete();
                      Navigator.pop(context);
                    },
                    child: new Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 35.0,
                    ),
                    shape: new CircleBorder(),
                    elevation: 2.0,
                    fillColor: Theme.of(context).accentColor,
                    padding: const EdgeInsets.all(15.0),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
