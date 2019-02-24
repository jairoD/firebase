import 'package:firebase/services/Auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase/main.dart';
import 'home.dart';

class RootPage extends StatefulWidget {
  RootPage({this.auth});
  final Auth auth;
  @override
  _RootPageState createState() => _RootPageState();
}

enum AuthStatus { NOT_DETERMINATED, NOT_LOGGED_IN, LOGGED_IN }

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.NOT_LOGGED_IN;
  String userId = "";

  @override
  void initState() {
    super.initState();
    widget.auth.getUser().then((user) {
      setState(() {
        if (user != null) {
          userId = user?.uid;
        }
        authStatus =
            user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINATED:
        print('No determinado');
        return _buildWaitingScreen();        
        break;
      case AuthStatus.NOT_LOGGED_IN:
        return new MyHomePage(
          auth: widget.auth,
          onSignedIn: _onLoggedIn,
        );
        break;
      case AuthStatus.LOGGED_IN:
        if (userId.length > 0 && userId != null) {
          return new HomePage(
            userId: userId,
            auth: widget.auth,
            onSignedOut: _onSignedOut,
          );
        } else {
          return _buildWaitingScreen();
        }
        break;
      default:
        return _buildWaitingScreen();
    }
  }

  void _onLoggedIn() {
    widget.auth.getUser().then((user) {
      setState(() {
        userId = user.uid.toString();
      });
    });
    setState(() {
      authStatus = AuthStatus.LOGGED_IN;
    });
  }

  void _onSignedOut() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      userId = "";
    });
  }

  Widget _buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }
}
