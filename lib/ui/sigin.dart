import 'package:firebase/services/Auth.dart';
import 'package:firebase/services/userdata.dart';
import 'package:firebase/ui/home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignIn extends StatefulWidget {
  final Auth auth;
  final VoidCallback onSignedIn;

  const SignIn({Key key, this.auth, this.onSignedIn}) : super(key: key);
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  String _email;
  String _password;

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
                          'Sigin',
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
                                await aut.sigIn(_email, _password);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomePage(
                                          userId: prueba.uid,
                                        )));
                            print('user: ${prueba.uid}');
                            mensaje('Bienvenido: ${prueba.uid}');
                            /*
                            FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                              email: _email,
                              password: _password,
                            )
                                .then((signedInUser) {
                              UserData().storeNewUser(signedInUser, context);
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                '/home',
                                (Route<dynamic> route) => false,
                              );
                            });
                            */
                          } catch (e) {
                            print('Error: $e');
                            mensaje('$e');
                          }
                        },
                        color: Colors.blue,
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
                            'Login',
                            style: new TextStyle(
                              color: Colors.blue,
                            ),
                          ),
                          onTap: () {
                            //Navigator.push(context, MaterialPageRoute(builder: (context)=>MyHomePage(title: 'Login Flutter')));
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
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
