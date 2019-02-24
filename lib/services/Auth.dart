import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Auth {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  

  Future<FirebaseUser> logIn(String email, String password) async {
    FirebaseUser user = await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return user;
  }

  Future<FirebaseUser> sigIn(String email, String password) async {
    FirebaseUser user = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return user;
  }

  Future<FirebaseUser> getUser() async {
    FirebaseUser user = await firebaseAuth.currentUser();
    return user;
  }

  Future<void> create(Firestore db, String name, String uid) async {
    DocumentReference ref = await db
        .collection('CRUD')
        .add({'name': '$name', 'usuario': '$uid'}).then((ref) {
      Fluttertoast.showToast(        
        msg: 'añadido correctamenta',
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.grey[300],
      );
    });
  }
}
