import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:school_facility_management/Screen/login_screen.dart';
import '../Screen/navigator_home_screen.dart';

class AuthController extends GetxController {
  // sign up text editing controllers

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // login text editing controllers
  final TextEditingController loginEmailController = TextEditingController();
  final TextEditingController loginPasswordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> loginUser() async {
    final user = await _auth.signInWithEmailAndPassword(
        email: loginEmailController.text,
        password: loginPasswordController.text);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("userID", user.user!.uid);
      print(user.user!.uid);
      Get.to(const NavigatorHomeScreen());
  }

  Future<void> logoutUser() async {
    await _auth.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Get.offAll(const LoginScreen());
  }
}