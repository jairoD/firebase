import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/services/Auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.auth, this.onSignedOut, this.userId})
      : super(key: key);
  final Auth auth;
  final VoidCallback onSignedOut;
  final String userId;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Firestore db = Firestore.instance;
  String valor;
  String id;
  String a;
  Auth _auth;

  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    a = widget.userId;
    _auth = new Auth();
  }

  @override
  void dispose() {
    textController.dispose();
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
      /*
      Forma 1 de recibir datos
      StreamBuilder(
        stream: Firestore.instance.collection('CRUD').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return new Text('Loading...');
          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, i) {
              DocumentSnapshot ds = snapshot.data.documents[i];
              return Text('${ds['name']}');
            },
          );
        },
      ),
      */
      new Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: new ListView(
          children: <Widget>[
            new Container(
              padding: EdgeInsets.all(30),
              alignment: Alignment.center,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Image.asset(
                    'images/logo.png',
                  ),
                ],
              ),
            ),
            new Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  new TextField(
                    controller: textController,
                    keyboardType: TextInputType.multiline,
                    decoration: new InputDecoration(
                      hintText: 'Añadir valores Firebase',
                      labelText: 'Valor firebase',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: (){
                          textController.clear();
                        },
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        valor = value;
                      });
                    },
                    
                  ),
                  new Container(
                    padding: EdgeInsets.only(top: 20),
                    child: new Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        new FlatButton(
                          child: new Text(
                            'Añadir',
                            style: new TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          shape: new RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          color: Colors.blue,
                          onPressed: () {
                            //create();
                            _auth.create(db, valor, a);
                          },
                        ),
                        new FlatButton(
                          child: new Text(
                            'Leer',
                            style: new TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          shape: new RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          color: Colors.green,
                          onPressed: () {
                            id != null ? read():null;
                            print(a);
                          },
                        ),
                      ],
                    ),
                  ),
                  // forma 2 de recibir datos
                  StreamBuilder<QuerySnapshot>(
                    stream:  db.collection('CRUD').snapshots(),
                    builder: (context,snapshot){
                      if(snapshot.hasData){
                        return Column(
                          children: 
                          snapshot.data.documents.map((doc)=>buildItem(doc)).toList(),
                        );

                      }
                      else{
                        return Container(
                        );
                      }
                    },
                  ),                  
                  new Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      new FlatButton(
                        child: new Text(
                          'Cerrar sesion',
                          style: new TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              '/main', (Route<dynamic> route) => false);
                        },
                        shape: new RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        color: Colors.red[900],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Card buildItem(DocumentSnapshot doc) {
    return Card(
      child: new Padding(
        padding: EdgeInsets.all(10),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text(
              'Nombre: ${doc.data['name']}',
              style: new TextStyle(
                fontSize: 20,
              ),
            ),
            new Text(
              'Autor: ${doc.data['usuario']}',
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new FlatButton(
                  child: new Text('Actualizar'),
                  shape: new RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  onPressed: () {
                    
                  },
                  color: Colors.green,
                  textColor: Colors.white,
                ),
                new FlatButton(
                  child: new Text('Borrar'),
                  onPressed: () {
                    delete(doc);
                  },
                  color: Colors.red,
                  textColor: Colors.white,
                  shape: new RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void create() async {
    DocumentReference ref =
        await db.collection('CRUD').add({'name': '$valor', 'usuario': '$a'});
    setState(() {
      id = ref.documentID;
      print(id);
    });
  }

  void read() async {
    DocumentSnapshot snapshot = await db.collection('CRUD').document(id).get();
    print(snapshot.data['name']);
  }

  void update(DocumentSnapshot doc) async {
    await db.collection('Crud').document(doc.documentID).delete();
  }

  void delete(DocumentSnapshot doc) async {
    await db.collection('CRUD').document(doc.documentID).delete().then(
      (doc){
        Fluttertoast.showToast(
        msg: 'Eliminacion correcta',
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.grey[300],
      );
      }
    );
    setState(() {
      id = null;
    });
  }
}
