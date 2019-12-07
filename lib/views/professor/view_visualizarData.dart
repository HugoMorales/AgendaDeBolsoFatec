import 'package:agenda_fatec/utils.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agenda_fatec/models/Data.dart';

class VisualisarData extends StatefulWidget {
  VisualisarData({Key key, this.title, this.data}) : super(key: key);
  final String title;
  final Data data;

  @override
  State<StatefulWidget> createState() => new _VisualisarDataState();
}

class _VisualisarDataState extends State<VisualisarData> {
  //Variables
  Firestore refDb = Firestore.instance;

  //Edges
  final EdgeInsets edgesLeftRight = EdgeInsets.only(left: 5, right: 5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.data.titulo),
          centerTitle: true,
          textTheme: Theme.of(context).appBarTheme.textTheme),
      body: SingleChildScrollView(
        padding: edgesLeftRight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                padding: EdgeInsets.only(top: 5),
                child: Text(
                    widget.data.formatDataMarcada() +
                        ' - ' +
                        widget.data.titulo,
                    maxLines: 2,
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 30))),
            Container(
                child: Text(widget.data.timestamp,
                    textAlign: TextAlign.left,
                    style:
                        TextStyle(fontSize: 13, fontWeight: FontWeight.w300))),
            Container(
                height: 320,
                padding: EdgeInsets.only(top: 10),
                child: Text(widget.data.conteudo,
                    textAlign: TextAlign.left, style: TextStyle(fontSize: 20))),
            Container(
                height: 150,
                child: Center(
                  child: RawMaterialButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: new Text(
                                  'Tem certeza que deseja excluir a data?'),
                              actions: <Widget>[
                                new FlatButton(
                                  child: new Text("Cancelar"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                new FlatButton(
                                  child: new Text("Sim"),
                                  onPressed: () async {
                                    await refDb
                                        .collection('Datas')
                                        .document(widget.data.docID)
                                        .delete();
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();      
                                  },
                                ),
                              ],
                            );
                          });
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
