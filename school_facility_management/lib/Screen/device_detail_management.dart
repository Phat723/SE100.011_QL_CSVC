import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_facility_management/Controllers/Device_Detail_Controllers.dart';
import 'package:school_facility_management/Controllers/InOut_Controller.dart';
import 'package:school_facility_management/Controllers/Room_Controller.dart';
import 'package:school_facility_management/Screen/add_device_detail_screen.dart';
import 'package:school_facility_management/UserModel/devices_detail_model.dart';

import '../UserModel/devices_model.dart';

class DeviceDetailManagement extends StatefulWidget {
  final Device device;

  const DeviceDetailManagement({super.key, required this.device});

  @override
  State<DeviceDetailManagement> createState() => _DeviceDetailManagementState();
}

class _DeviceDetailManagementState extends State<DeviceDetailManagement> {
  DocumentReference? dvDetailDb;
  List<DeviceDetail> deviceDetailItems = [];
  InOutController inOutController = Get.put(InOutController());
  DeviceDetailController detailController = Get.put(DeviceDetailController());
  RoomController roomController = Get.put(RoomController());
  Device? receivedDevice;
  bool isLoaded = false;

  @override
  void initState() {
    receivedDevice = widget.device;
    dvDetailDb = FirebaseFirestore.instance
        .collection("DevicesType")
        .doc(receivedDevice!.deviceTypeId)
        .collection("Devices")
        .doc(receivedDevice!.deviceId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: StreamBuilder<QuerySnapshot>(
            stream: dvDetailDb!.collection("Device Detail").snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              if (snapshot.hasData) {
                deviceDetailItems.clear();
                for (var data in snapshot.data!.docs) {
                  deviceDetailItems.add(DeviceDetail.fromSnapshot(data));
                }
                return ListView.builder(
                  itemCount: deviceDetailItems.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        onLongPress: () {
                          deleteDeviceDetail(deviceDetailItems[index].toMap());
                        },
                        shape: RoundedRectangleBorder(
                            side: const BorderSide(width: 2),
                            borderRadius: BorderRadius.circular(20)),
                        title: Row(
                          children: [
                            Text(deviceDetailItems[index].deviceDetailName ??
                                "Not given"),
                          ],
                        ),
                        subtitle: Text(deviceDetailItems[index].deviceStatus),
                        trailing: const Icon(Icons.more_vert),
                      ),
                    );
                  },
                );
              }
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () async {
          await Get.to(const AddDeviceDetail());
          addDeviceDetail();
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void addDeviceDetail() async {
    if(receivedDevice!.deviceTypeId.isNotEmpty && receivedDevice!.deviceId.isNotEmpty) {
      DeviceDetail myDeviceDetail = DeviceDetail(
          deviceDetailId:
          "${detailController.deviceDetailNameController.text}_detail_id",
          roomId: detailController.roomId.value,
          areaId: detailController.areaId.value,
          storeCode: detailController.storeCodeController.text,
          deviceDetailName: detailController.deviceDetailNameController.text,
          deviceStatus: detailController.isState.value ? "Enable" : "Disable",
          deviceOwner: detailController.deviceOwnerController.text,
          deviceId: receivedDevice!.deviceId,
          deviceTypeId: receivedDevice!.deviceTypeId);
      if (detailController.deviceDetailNameController.text != '') {
        final db = dvDetailDb!.collection("Device Detail").doc(
            "${detailController.deviceDetailNameController.text}_detail_id");
        await db.set(myDeviceDetail.toMap());
        inOutController.generateInputSlip(
            detailController.storeCodeController.text,
            detailController.caseValue);
        roomController.addDeviceToRoom(
            detailController.areaId.value,
            detailController.roomId.value,
            myDeviceDetail.toMap());
        detailController.clearData();
      }
    }
  }
  deleteDeviceDetail(Map<String, dynamic> deletedDevice) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(8),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: const BorderSide(color: Colors.black, width: 2.0)),
          elevation: 2,
          title: const Text('Delete'),
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Please Chose Delete Option",
                    textAlign: TextAlign.start),
                DropdownButton<String>(
                  isExpanded: true,
                  value: inOutController.deleteChoseCase,
                  onChanged: (String? newValue) {
                    setState(() {
                      inOutController.deleteChoseCase = newValue!;
                    });
                  },
                  items: <String>['Broken', 'For sale']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            );
          }),
          actions: <Widget>[
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                String deleteCode = detailController.generateInOutId();
                inOutController.generateOutputSlip(
                    deleteCode, inOutController.deleteChoseCase);
                dvDetailDb!
                    .collection("Device Detail")
                    .doc(deletedDevice["DeviceDetail Id"])
                    .delete();
                setState(() {
                  deviceDetailItems.remove(deletedDevice);
                  roomController.deleteDeviceFromRoom(
                      deletedDevice["AreaId"],
                      deletedDevice["RoomId"],
                      deletedDevice["DeviceDetail Name"]);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
