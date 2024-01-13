import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_facility_management/UserModel/devices_detail_model.dart';

class DeviceDetailController extends GetxController {
  static DeviceDetailController get instance => Get.find();
  final TextEditingController storeCodeController = TextEditingController();
  final TextEditingController deviceDetailNameController =
      TextEditingController();
  final TextEditingController deviceOwnerController = TextEditingController();
  final TextEditingController deviceMaintainTimeController = TextEditingController();
  final TextEditingController deviceCostController = TextEditingController();
  CollectionReference areaCollection =
      FirebaseFirestore.instance.collection("Area");
  CollectionReference? roomCollection;
  String caseValue = '';
  List<String> caseItems = ['Mua mới', 'Tài trợ'];
  RxString areaId = ''.obs;
  RxString roomId = ''.obs;
  String generateInOutId() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return String.fromCharCodes(Iterable.generate(
        15, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
  }

  void upDateDeviceDetail(DeviceDetail device) async{
    final deviceDetailDB = FirebaseFirestore.instance
        .collection('DevicesType')
        .doc(device.deviceTypeId)
        .collection('Devices')
        .doc(device.deviceId)
        .collection("Device Detail")
        .doc(device.deviceDetailId);
    await deviceDetailDB.update(device.toMap());
  }
  void clearData() {
    deviceOwnerController.clear();
    deviceDetailNameController.clear();
    storeCodeController.clear();
    deviceMaintainTimeController.clear();
    deviceCostController.clear();
    areaId.value = '';
    roomId.value = '';
  }
}
