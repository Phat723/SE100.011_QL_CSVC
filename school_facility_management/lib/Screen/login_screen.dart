// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:school_facility_management/Model/theme.dart';
import 'package:school_facility_management/Screen/Navigator_Home_Screen.dart';
import 'package:school_facility_management/Screen_user/user_home_screen.dart';
import 'package:school_facility_management/my_button.dart';
import '../Controllers/Auth_Controllers.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthController authController = AuthController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    emailController.selection = TextSelection.fromPosition(
      TextPosition(
        offset: emailController.text.length,
      ),
    );
    passwordController.selection = TextSelection.fromPosition(
      TextPosition(
        offset: passwordController.text.length,
      ),
    );
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 200,
                  width: 200,
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green.shade50,
                  ),
                  child: Image.asset("assets/icons8-school-100.png"),
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text("Đăng Nhập",
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                TextFormField(
                  controller: authController.loginEmailController,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    hintText: "Email",
                    prefixIcon: const Icon(Icons.email, color: Colors.grey),
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: Colors.grey.shade600,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.black12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.black12),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: authController.loginPasswordController,
                  obscureText: true,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    hintText: "Password",
                    prefixIcon: const Icon(
                      Icons.lock,
                      color: Colors.grey,
                    ),
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: Colors.grey.shade600,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.black12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.black12),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: MyButton(
                    onPressed: () {
                      if (authController.loginEmailController.text.isNotEmpty &&
                          authController
                              .loginPasswordController.text.isNotEmpty) {
                        authController
                            .loginUser(authController.loginEmailController.text,
                                authController.loginPasswordController.text)
                            .then((user) async {
                          if (user == null) {
                            showErorrDialog(context);
                            return;
                          }

                          DocumentReference documentReference =
                              firestore.collection('Client').doc(user.uid);
                          DocumentSnapshot document =
                              await documentReference.get();
                          String role = document['Role'];
                          switch (role) {
                            case 'User':
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (_) => const NavigatorHomeScreen()));
                              showWarmingDialog(context);
                              print("Login Successfull");

                              break;
                            case 'Admin':
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          const NavigatorHomeScreen()));
                              print("Login Successfull");

                              break;
                          }
                        });
                      } else {
                        print("Please fill");
                        showInfoDialog(context);
                      }
                    },
                    text: "Đăng nhập",
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          authController
                              .loginUser(
                                  'nguyentruongbaoduy2003@gmail.com', '123456')
                              .then((user) {
                            print("Login Successfull");
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const NavigatorHomeScreen()),
                              (route) => false,
                            );
                          });
                        },
                        child: const Text(
                          "Admin tổng",
                          style: TextStyle(
                            color: Themes.selectedClr,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          authController
                              .loginUser('2409huynhphat@gmail.com', '123456')
                              .then((user) {
                            print("Login Successfull");
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const UserHomeScreen()),
                              (route) => false,
                            );
                          });
                        },
                        child: const Text(
                          "User",
                          style: TextStyle(
                            color: Themes.selectedClr,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  showWarmingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Thông báo'),
          content: const Text(
              'Chưa làm giao diện cho người dùng, chưa cho đăng nhập'),
          actions: [
            TextButton(
              child: const Text('Đóng'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Thông báo'),
          content: const Text('Vui lòng nhập đủ thông tin'),
          actions: [
            TextButton(
              child: const Text('Đóng'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  showErorrDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Thông báo'),
          content: const Text('Mật khẩu hoặc tài khoản không đúng'),
          actions: [
            TextButton(
              child: const Text('Đóng'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
