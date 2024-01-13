import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:school_facility_management/UserModel/devices_detail_model.dart';
import 'package:school_facility_management/UserModel/in_out_log_model.dart';

class InOutController extends GetxController {
  static InOutController get instance => Get.find();
  String deleteChoseCase = 'Broken';
  String createChoseCase = 'Purchase';
  List<DeviceDetail> items = [];
  void generateInputSlip(String code, String createCase){
    DateTime timeNow = DateTime.now();
    String generateDay = "${timeNow.year}/${timeNow.month}/${timeNow.day}";
    String? creatorName = FirebaseAuth.instance.currentUser!.email;
    InOutLog inOutLog = InOutLog(inOutId: code,creatorName:  creatorName,createDay:  generateDay,createType:  "Input Slip",createCase:  createCase);
    FirebaseFirestore.instance.collection("InOutLog").doc(code).set(inOutLog.toMap());
  }
  void generateOutputSlip(String code, String deleteCase){
    DateTime timeNow = DateTime.now();
    String generateDay = "${timeNow.year}/${timeNow.month}/${timeNow.day}";
    String? creatorName = FirebaseAuth.instance.currentUser!.email;
    InOutLog inOutLog = InOutLog(inOutId: code,creatorName:  creatorName,createDay:  generateDay,createType:  "Output Slip",createCase:  deleteCase);
    FirebaseFirestore.instance.collection("InOutLog").doc(code).set(inOutLog.toMap());
  }
  void inputSlipToFirebase() async{
    final dataBase = FirebaseFirestore.instance;
    for(int index = 0; index < items.length; index++){
        await dataBase.collection("DevicesType")
          .doc(items[index].deviceTypeId)
          .collection("Devices")
          .doc(items[index].deviceId)
          .collection("Device Detail")
          .doc(items[index].deviceDetailId)
          .set(items[index].toMap());
    }
    items.clear();
  }
}