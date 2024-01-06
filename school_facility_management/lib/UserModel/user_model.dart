import 'package:cloud_firestore/cloud_firestore.dart';

class MyUser {
  final String? id;
  final String imageURL;
  final String username;
  final String password;
  final String birthDay;
  final String gender;
  final String phoneNum;
  final String email;
  final String role;
  final String state;

  const MyUser({
    this.id,
    required this.username,
    required this.password,
    required this.birthDay,
    required this.gender,
    required this.phoneNum,
    required this.email,
    required this.role,
    required this.imageURL,
    this.state='enable',
  });
  Map<String, dynamic> toMap(){
    return {
      "Id": id,
      "Username": username,
      "Password": password,
      "BirthDay": birthDay,
      "Gender": gender,
      "PhoneNumber": phoneNum,
      "State": state,
      "Email": email,
      "Role": role,
      "imageURL":imageURL
    };
  }
  factory MyUser.fromSnapShot( DocumentSnapshot<Map<String, dynamic>>document){
    return MyUser(
      id: document["Id"],
      username: document["Username"],
      password: document["Password"],
      birthDay: document["BirthDay"],
      gender: document["Gender"],
      phoneNum: document["PhoneNumber"],
      email: document["Email"],
      role: document["Role"],
      state: document["State"],
      imageURL: document["imageURL"]
    );
  }
}
