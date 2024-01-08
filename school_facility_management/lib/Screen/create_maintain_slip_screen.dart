import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_facility_management/Controllers/Room_Controller.dart';
import 'package:school_facility_management/Model/AppTheme.dart';
import 'package:school_facility_management/UserModel/maintain_model.dart';

import '../UserModel/devices_detail_model.dart';

class CreateMaintainSlip extends StatefulWidget {
  const CreateMaintainSlip({super.key});

  @override
  State<CreateMaintainSlip> createState() => _CreateMaintainSlipState();
}

class _CreateMaintainSlipState extends State<CreateMaintainSlip> {
  List<DeviceDetail> listDeviceDetail = [];
  List<String> listDeviceName = [];
  List<Map<String, dynamic>> saveDeviceList = [];
  RoomController roomController = Get.put(RoomController());

  @override
  void initState() {
    fetchDataFromLastCollection();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                "Danh sách tất cả các thiết bị",
                style: AppTheme.headline,
              ),
              SizedBox(
                height: 300,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: listDeviceDetail.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: Colors.black12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(listDeviceDetail[index].deviceDetailName),
                              Text(listDeviceDetail[index].deviceStatus),
                            ],
                          ),
                          Checkbox(
                            value: listDeviceName
                                .contains(listDeviceDetail[index].deviceDetailName),
                            onChanged: (selected) {
                              setState(() {
                                bool isAdding = selected != null && selected;
                                isAdding
                                    ? listDeviceName.add(
                                        listDeviceDetail[index].deviceDetailName)
                                    : listDeviceName.remove(
                                        listDeviceDetail[index].deviceDetailName);
                                isAdding
                                    ? saveDeviceList
                                        .add(listDeviceDetail[index].toMap())
                                    : saveDeviceList.removeWhere((element) =>
                                        element['DeviceDetail Name'] ==
                                        listDeviceDetail[index].deviceDetailName);
                              });
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    createMaintainTicket();
                  },
                  child: const Text("Tạo phiếu Bảo trì")),
            ],
          ),
        ),
      ),
    );
  }

  void createMaintainTicket() {
    setState(() {
      for(int index =0; index < saveDeviceList.length; index++){
        var db = FirebaseFirestore.instance
            .collection("DevicesType")
            .doc(saveDeviceList[index]['DeviceType Id'])
            .collection("Devices")
            .doc(saveDeviceList[index]['Device Id'])
            .collection("Device Detail")
            .doc(saveDeviceList[index]['DeviceDetail Id']);
        saveDeviceList[index]['DeviceDetail Status'] = "Đang bảo trì";
        db.update(saveDeviceList[index]);
        DeviceDetail deviceDetail = DeviceDetail.fromMap(saveDeviceList[index]);
        roomController.updateStatusDevice(deviceDetail.areaId, deviceDetail.roomId, deviceDetail, deviceDetail.deviceStatus);
      }
      String maintainId = generateRandomString();
      MaintainTicket maintainTicket = MaintainTicket(
          maintainId: maintainId,
          createDay: DateTime.now(),
          finishDay: DateTime.now(),
          creatorName: "Chưa có",
          confirmName: "Chưa có",
          maintainStatus: "Đang bảo trì",
          maintainDeviceList: saveDeviceList);
      FirebaseFirestore.instance
          .collection("Maintain")
          .doc(maintainId)
          .set(maintainTicket.toMap());
      listDeviceName.clear();
      saveDeviceList.clear();
    });
    fetchDataFromLastCollection();
  }

  String generateRandomString() {
    final random = Random();
    String randomDigits = '';

    // Tạo 8 số ngẫu nhiên
    for (int i = 0; i < 8; i++) {
      randomDigits += random.nextInt(10).toString();
    }

    // Thêm tiền tố "RP_"
    String result = "MT_$randomDigits";
    return result;
  }

  Future<void> fetchDataFromLastCollection() async {
    listDeviceDetail.clear();
    try {
      // Lấy reference đến collection "DevicesType"
      CollectionReference devicestypeCollection =
          FirebaseFirestore.instance.collection("DevicesType");

      // Lấy tất cả các tài liệu trong "DevicesType" collection
      QuerySnapshot devicestypeSnapshot = await devicestypeCollection.get();

      // Duyệt qua từng tài liệu trong "Devicestype" collection
      for (QueryDocumentSnapshot devicestypeDoc in devicestypeSnapshot.docs) {
        // Lấy reference đến collection "Devices" trong mỗi "Devicestype" document
        CollectionReference devicesCollection =
            devicestypeDoc.reference.collection("Devices");

        // Lấy tất cả các tài liệu trong "Devices" collection
        QuerySnapshot devicesSnapshot = await devicesCollection.get();

        // Duyệt qua từng tài liệu trong "Devices" collection
        for (QueryDocumentSnapshot devicesDoc in devicesSnapshot.docs) {
          // Lấy reference đến collection "DevicesDetail" trong mỗi "Devices" document
          CollectionReference devicesDetailCollection =
              devicesDoc.reference.collection("Device Detail");

          // Lấy tất cả các tài liệu trong "DevicesDetail" collection
          QuerySnapshot devicesDetailSnapshot =
              await devicesDetailCollection.get();

          // Duyệt qua từng tài liệu trong "DevicesDetail" collection và in dữ liệu
          for (QueryDocumentSnapshot devicesDetailDoc
              in devicesDetailSnapshot.docs) {
            setState(() {
              listDeviceDetail.add(DeviceDetail.fromMap(devicesDetailDoc.data()
                  as Map<String,
                      dynamic>)); // Dữ liệu từ "DevicesDetail" document
            });
          }
        }
      }
    } catch (e) {
      Get.snackbar("Error fetching data", "$e");
    }
  }
}
