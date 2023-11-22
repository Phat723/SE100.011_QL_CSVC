import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeviceDetailController extends GetxController {
  static DeviceDetailController get instance => Get.find();
  final TextEditingController storeCodeController = TextEditingController();
  final TextEditingController deviceDetailNameController = TextEditingController();
  final TextEditingController deviceOwnerController = TextEditingController();
  RxBool isState = true.obs;
  RxString areaId = ''.obs;
  RxString roomId = ''.obs;

  Future<void> getFirstDocumentId() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Area')
          .limit(1) // Giới hạn số lượng tài liệu trả về là 1
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        areaId.value = querySnapshot.docs.first.id;
      } else {
        print('Không có tài liệu trong collection.');
      }
    } catch (e) {
      print('Lỗi: $e');
    }
  }
}
