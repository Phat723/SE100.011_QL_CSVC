
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:school_facility_management/UserModel/user_model.dart';

class UserProfileController extends GetxController {
  static UserProfileController get instance => Get.find();
  // sign up text editing controllers


  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  //final genderController =
 // final emailController = TextEditingController();
//  final passwordController = TextEditingController();
//  final phoneController = TextEditingController();


  void updateValue(MyUser clientModel){
    fullNameController.text=clientModel.username;
    emailController.text=clientModel.email;
    passwordController.text=clientModel.password;
    phoneController.text=clientModel.phoneNum;
  }

}