import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

class EditProfileScreen extends GetWidget{
  const EditProfileScreen({Key? key}) : super (key: key);

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text ("Edit profile"),
        ),

      );
  }

}