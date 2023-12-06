import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeviceDetailController extends GetxController {
  static DeviceDetailController get instance => Get.find();
  final TextEditingController storeCodeController = TextEditingController();
  final TextEditingController deviceDetailNameController = TextEditingController();
  final TextEditingController deviceOwnerController = TextEditingController();
  String caseValue = 'Mua mới';
  List<String> caseItems = ['Mua mới', 'Tài trợ'];
  RxBool isState = true.obs;
  RxString areaId = ''.obs;
  RxString roomId = ''.obs;
  String generateInOutId() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return String.fromCharCodes(Iterable.generate(
        15, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
  }
  void clearData(){
    deviceOwnerController.clear();
    deviceDetailNameController.clear();
    storeCodeController.clear();
    areaId.value = '';
    roomId.value = '';
  }
}
