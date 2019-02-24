import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'ui/sigin.dart';
import 'ui/home.dart';
import 'services/Auth.dart';
import 'ui/root_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: new RootPage(auth: new Auth()),
      routes: <String, WidgetBuilder>{
        '/main': (BuildContext context) => new MyHomePage(),
        '/sigin': (BuildContext context) => new SignIn(),
        '/home': (BuildContext context) => new HomePage()
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.auth, this.onSignedIn}) : super(key: key);
  final Auth auth;
  final VoidCallback onSignedIn;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _email = "";
  String _password;
  String id;
  Auth aut;

  @override
  void initState() {
    super.initState();
    aut = widget.auth;
    aut = new Auth();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Container(
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
                  new Container(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 30),
                    child: TextField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: new InputDecoration(
                        hintText: 'example@example.com',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        labelText: 'Email address',
                        prefixIcon: Icon(Icons.person),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _email = value;
                        });
                      },
                    ),
                  ),
                  new Container(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 30),
                    child: TextField(
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) {
                        setState(() {
                          _password = value;
                        });
                      },
                      obscureText: true,
                      decoration: new InputDecoration(
                        hintText: 'your password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock),
                      ),
                    ),
                  ),
                  new Container(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 30),
                    child: Container(
                      child: new FlatButton(
                        child: new Text(
                          'Login',
                          style: new TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30),
                        ),
                        onPressed: () async {
                          try {
                            FirebaseUser prueba =
                                await aut.logIn(_email, _password);
                            print('user: ${prueba.uid}');
                            mensaje('Hola: ${prueba.uid}');
                            Navigator.of(context).pushReplacement(
                              new MaterialPageRoute(
                                builder: (context)=> HomePage(
                                  userId: prueba.uid,
                                ),
                                settings: const RouteSettings(
                                  name: '/home',
                                ),
                              )
                            );
                            /*
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomePage(
                                          userId: prueba.uid,
                                        )));
                            */
                          } catch (e) {
                            print('Error: $e');
                            mensaje('$e');
                          }
                          /*
                          FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                            email: _email,
                            password: _password,
                          )
                              .then((FirebaseUser user) {
                            print(user.uid);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomePage(userId: user.uid,)));
                          }).catchError((e) {
                            print(e);
                          });
                          */
                        },
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  new Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Container(
                      child: new FlatButton(
                        child: new Text(
                          'Login with Google',
                          style: new TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30),
                        ),
                        onPressed: () {},
                        color: Colors.red,
                      ),
                    ),
                  ),
                  new Container(
                    padding: EdgeInsets.only(
                        left: 10, right: 10, top: 10, bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new InkWell(
                          child: Text(
                            'Sign in',
                            style: new TextStyle(
                              color: Colors.blue,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignIn()));
                          },
                        ),
                        new InkWell(
                          child: Text(
                            'Forgot password ?',
                            style: new TextStyle(
                              color: Colors.blue,
                            ),
                          ),
                          onTap: () {},
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void mensaje(String mensaje) {
    Fluttertoast.showToast(
      msg: mensaje,
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: Colors.grey[300],
    );
  }
}
