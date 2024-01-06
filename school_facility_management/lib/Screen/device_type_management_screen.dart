import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_facility_management/Screen/device_management_screen.dart';

import 'package:school_facility_management/UserModel/devices_type_model.dart';
import 'package:school_facility_management/my_button.dart';

class DeviceTypeManagement extends StatefulWidget {
  const DeviceTypeManagement({super.key});

  @override
  State<DeviceTypeManagement> createState() => _DeviceTypeManagementState();
}

class _DeviceTypeManagementState extends State<DeviceTypeManagement> {
  final db = FirebaseFirestore.instance.collection("DevicesType");
  List<DeviceType> items = [];
  final TextEditingController deviceTypeNameController =
      TextEditingController();

  @override
  void dispose() {
    deviceTypeNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: StreamBuilder<QuerySnapshot>(
            stream: db.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              if (snapshot.hasData && items.isEmpty) {
                for (var data in snapshot.data!.docs) {
                  items.add(DeviceType.fromSnapshot(data));
                }
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              return GridView.builder(
                itemCount: items.length + 1,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (context, index) {
                  if (index == items.length) {
                    return GestureDetector(
                      onTap: () => addDeviceType(),
                      child: Padding(
                        padding: const EdgeInsets.all(50.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(100),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.add, size: 50),
                        ),
                      ),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          Get.to(DeviceManagement(dvType: items[index]));
                        },
                        onLongPress: () =>
                            showDeleteDialog(items[index].deviceTypeId, index),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Colors.green, Colors.greenAccent]),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(1),
                                spreadRadius: 3,
                                blurRadius: 5,
                                offset: const Offset(-5, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                items[index].deviceTypeName ?? "Not given",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Image.asset("assets/facilities_icon.png"),
                              const SizedBox(
                                height: 10,
                              ),
                              StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection("DevicesType")
                                    .doc(items[index].deviceTypeId)
                                    .collection("Devices").snapshots(),
                                builder: (context, snapshot) {
                                  if(snapshot.hasData){
                                    items[index].deviceTypeAmount = snapshot.data!.size;
                                    FirebaseFirestore.instance
                                        .collection("DevicesType")
                                        .doc(items[index].deviceTypeId).update(items[index].toMap());
                                  }
                                  return Text(
                                    "Số lượng: ${items[index].deviceTypeAmount}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                }
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                },
              );
            }),
      ),
      appBar: AppBar(),
    );
  }
  void addDeviceType() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Add New Device Type'),
          content: TextFormField(
            controller: deviceTypeNameController,
            decoration: const InputDecoration(hintText: 'Enter item name'),
          ),
          actions: <Widget>[
            MyButton(
              text: 'CANCEL',
              onPressed: () {
                Navigator.of(context).pop();
                deviceTypeNameController.clear();
              },
            ),
            MyButton(
              text: 'ADD',
              onPressed: () {
                if(deviceTypeNameController.text.isNotEmpty) {
                  String newItemName = deviceTypeNameController.text;
                  DeviceType myDeviceType = DeviceType(
                      deviceTypeId: "${newItemName}Type_id",
                      deviceTypeName: newItemName);
                  setState(() {
                    db.doc("${newItemName}Type_id").set(myDeviceType.toMap());
                    items.add(myDeviceType);
                  });
                  Navigator.of(context).pop();
                  deviceTypeNameController.clear();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void showDeleteDialog(String id, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Xác nhận xóa"),
          content: const Text("Bạn có chắc muốn xóa loại thiết bị này"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                // Xóa dữ liệu từ Firebase
                db.doc(id).delete();
                // Cập nhật lại danh sách và rebuild widget
                setState(() {
                  items.removeAt(index);
                });
                Navigator.of(context).pop();
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }
}
