import 'package:cloud_firestore/cloud_firestore.dart';
class UserData{
  
  storeNewUser(user,context){
    Firestore.instance.collection('/users').add({
      'email': user.email,
      'uid': user.uid,
    }).then((value){
      print('usuario registrado');
    }).catchError((e){
      print(e);
    });
  }
}