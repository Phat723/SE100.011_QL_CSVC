// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_facility_management/UserModel/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:school_facility_management/Screen/login_screen.dart';

class AuthController extends GetxController {
  static AuthController get instance => Get.find();
  // sign up text editing controllers

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // login text editing controllers
  final TextEditingController loginEmailController = TextEditingController();
  final TextEditingController loginPasswordController = TextEditingController();
  final nameController = TextEditingController();
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Future<void> loginUser() async {
  //   final user = await _auth.signInWithEmailAndPassword(
  //       email: loginEmailController.text,
  //       password: loginPasswordController.text);
  //     //SharedPreferences prefs = await SharedPreferences.getInstance();
  //     //prefs.setString("userID", user.user!.uid);
  //     print(user.user!.uid);
  // }

  Future<User?> loginUser(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      _firestore.collection('Client').doc(_auth.currentUser!.uid).get();
      print("Login Sucessfull");

      return userCredential.user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<void> logoutUser() async {
    await FirebaseAuth.instance.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Get.offAll(const LoginScreen());
  }

  static Future<MyUser> getUserDetail(String id) async {
    final snapshot = await _db.collection("Client").doc(id).get();
    return MyUser.fromSnapShot(snapshot);
  }

  Future<MyUser?> getCurrentUserInfo() async {
    String id = FirebaseAuth.instance.currentUser!.uid;
    MyUser? myUser;
    await FirebaseFirestore.instance
        .collection("Client")
        .doc(id)
        .get()
        .then((DocumentSnapshot<Map<String, dynamic>> snapshot) {
      myUser = MyUser.fromSnapShot(snapshot);
    });
    return myUser;
  }
}
