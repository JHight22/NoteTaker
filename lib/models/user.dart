import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String userId;
  String name;
  String email;

  UserModel({this.userId, this.name, this.email});

  UserModel.fromDocumentSnapShot({DocumentSnapshot documentSnapshot}) {
    userId = documentSnapshot.id;
    name = documentSnapshot.data()["name"];
    email = documentSnapshot.data()["email"];
  }
}
