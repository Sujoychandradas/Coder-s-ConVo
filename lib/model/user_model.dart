import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserModel {
  String email;
  String name;
  String Image;
  Timestamp data;
  String uid;

  UserModel({
    required this.email,
    required this.name,
    required this.Image,
    required this.data,
    required this.uid,
  });
//So we have our model ready  but as we also know that there are fuctions to serailse and deserialse our json data usally thsi call dot form json and all

  factory UserModel.fromJson(DocumentSnapshot snapshot) {
    //Doc snapshot are firebase data
    return UserModel(
      email: snapshot['email'] ,
      name: snapshot['name']  ,
      Image: snapshot['Image'],
      data: snapshot['date'],
      uid: snapshot['uid'],
    );
  }
}
