import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:school_facility_management/UserModel/in_out_log_model.dart';

class InOutController extends GetxController {
  static InOutController get instance => Get.find();
  String deleteChoseCase = 'Broken';
  String createChoseCase = 'Purchase';
  void generateInputSlip(String code, String createCase){
    DateTime timeNow = DateTime.now();
    String generateDay = "${timeNow.year}/${timeNow.month}/${timeNow.day}";
    String? creatorName = FirebaseAuth.instance.currentUser!.email;
    InOutLog inOutLog = InOutLog(code, creatorName, generateDay, "Input Slip", createCase);
    FirebaseFirestore.instance.collection("InOutLog").doc(code).set(inOutLog.toMap());
  }
  void generateOutputSlip(String code, String deleteCase){
    DateTime timeNow = DateTime.now();
    String generateDay = "${timeNow.year}/${timeNow.month}/${timeNow.day}";
    String? creatorName = FirebaseAuth.instance.currentUser!.email;
    InOutLog inOutLog = InOutLog(code, creatorName, generateDay, "Output Slip", deleteCase);
    FirebaseFirestore.instance.collection("InOutLog").doc(code).set(inOutLog.toMap());
  }
}