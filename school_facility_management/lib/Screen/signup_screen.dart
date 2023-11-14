
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:school_facility_management/Firebase/firebase_auth_services.dart';
import 'package:school_facility_management/UserModel/user_model.dart';
import 'package:school_facility_management/my_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FirebaseAuthServices _auth = FirebaseAuthServices();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController birthDayController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  String selectedRole = "Admin";
  String selectedGender ="Male";
  late DateTime selectedDate = DateTime.now();
  bool isVisible = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    emailController.selection = TextSelection.fromPosition(
        TextPosition(offset: emailController.text.length));
    passwordController.selection = TextSelection.fromPosition(
        TextPosition(offset: passwordController.text.length));
    usernameController.selection = TextSelection.fromPosition(
        TextPosition(offset: usernameController.text.length));
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 40,
                ),
                const Text("Add User",
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                TextFormField(
                  controller: usernameController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "user name is required";
                    }
                    return null;
                  },
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    hintText: "User name",
                    prefixIcon:
                        const Icon(Icons.account_circle, color: Colors.grey),
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
                  controller: emailController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "email is required";
                    }
                    return null;
                  },
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
                  controller: phoneController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Phone number is required";
                    }
                    return null;
                  },
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    hintText: "Phone number",
                    prefixIcon: const Icon(Icons.phone, color: Colors.grey),
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
                  controller: passwordController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "password is required";
                    }
                    return null;
                  },
                  obscureText: !isVisible,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    hintText: "Password",
                    suffixIcon: IconButton(
                        onPressed: () {
                          //In here we will create a click to show and hide the password a toggle button
                          setState(() {
                            //toggle button
                            isVisible = !isVisible;
                          });
                        },
                        icon: Icon(isVisible
                            ? Icons.visibility
                            : Icons.visibility_off)),
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
                const SizedBox(height: 20),
                TextFormField(
                  controller: confirmPasswordController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "password is required";
                    } else if (passwordController.text !=
                        confirmPasswordController.text) {
                      return "password is don't match";
                    }
                    return null;
                  },
                  obscureText: !isVisible,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    hintText: "Confirm Password",
                    suffixIcon: IconButton(
                        onPressed: () {
                          //In here we will create a click to show and hide the password a toggle button
                          setState(() {
                            //toggle button
                            isVisible = !isVisible;
                          });
                        },
                        icon: Icon(isVisible
                            ? Icons.visibility
                            : Icons.visibility_off)),
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
                const SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      height: 55,
                      width: 100,
                      padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadiusDirectional.circular(10),
                        border: Border.all(color: Colors.black12),
                      ),
                      child: DropdownButton<String>(
                        hint: Text(selectedRole),
                        isExpanded: true,
                        items: const [
                          DropdownMenuItem(
                            value: "Admin",
                            child: Text("Admin"),
                          ),
                          DropdownMenuItem(
                            value: "User",
                            child: Text("User"),
                          )
                        ],
                        onChanged: (String? value) {
                          setState(() {
                            selectedRole = value!;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 20,),
                    SizedBox(
                      width: 120,
                      child: TextFormField(
                        controller: birthDayController,
                        readOnly: true,
                        onTap: () {
                          showDatePicker(
                            context: context,
                            initialDate: selectedDate = DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2100),
                          ).then((pickedDate) {
                            if (pickedDate != null) {
                              setState(() {
                                selectedDate = pickedDate;
                                birthDayController.text =
                                    DateFormat('dd/MM/yyyy').format(selectedDate);
                              });
                            }
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Birthday',
                          suffixIcon: const Icon(Icons.calendar_today),
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
                    ),
                    const SizedBox(width: 20,),

                    Container(
                      height: 55,
                      width: 100,
                      padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadiusDirectional.circular(10),
                        border: Border.all(color: Colors.black12),
                      ),
                      child: DropdownButton<String>(
                        hint:  Text(selectedGender),
                        isExpanded: true,
                        items: const [
                          DropdownMenuItem(
                            value: "Male",
                            child: Text("Male"),
                          ),
                          DropdownMenuItem(
                            value: "Female",
                            child: Text("Female"),
                          )
                        ],
                        onChanged: (String? value) {
                          setState(() {
                            selectedGender = value!;
                          });
                        },
                      ),
                    ),
                  ],

                ),
                const SizedBox(height: 20,),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: MyButton(
                    onPressed: () {
                      _signUp();
                    },
                    text: "Sign Up",
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  void _signUp() async {

    String username = usernameController.text;
    String email = emailController.text;
    String password = passwordController.text;
    String role = selectedRole;
    String birthDay = birthDayController.text;
    String gender = selectedGender;
    String phone = phoneController.text;
    User? user = await _auth.signUpWithEmailAndPassword(email, password);
    final myDB = FirebaseFirestore.instance.collection("Client").doc( user?.uid);
    if (user != null) {
      String? id = myDB.id;

      MyUser myUser = MyUser(
          id: id,
          username: username,
          password: password,
          birthDay: birthDay,
          gender: gender,
          phoneNum: phone,
          email: email,
          role: role
      );
     myDB.set(myUser.toMap()).whenComplete(() => Get.snackbar('School facility','Successfully Added'));
      if(context.mounted) {
        Navigator.pop(context);
      }
    } else {
      print("Some error happen");
    }
  }
}
