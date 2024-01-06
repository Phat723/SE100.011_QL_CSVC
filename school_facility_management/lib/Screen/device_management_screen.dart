import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_facility_management/Screen/device_detail_management.dart';
import 'package:school_facility_management/UserModel/devices_model.dart';

import '../UserModel/devices_type_model.dart';

class DeviceManagement extends StatefulWidget {
  final DeviceType dvType;

  const DeviceManagement({super.key, required this.dvType});

  @override
  State<DeviceManagement> createState() => _DeviceManagementState();
}

class _DeviceManagementState extends State<DeviceManagement> {
  DocumentReference? db;
  final deviceNameController = TextEditingController();
  final deviceDescriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  DeviceType? receivedDvType;
  List<Device> deviceItems = [];

  @override
  void initState() {
    receivedDvType = widget.dvType;
    db = FirebaseFirestore.instance
        .collection("DevicesType")
        .doc(receivedDvType!.deviceTypeId);
    super.initState();
  }

  @override
  void dispose() {
    deviceDescriptionController.dispose();
    deviceNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Device management"),centerTitle: true,),
      body: SafeArea(
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: db!.collection("Devices").snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text("something went wrong");
                }
                if (snapshot.hasData && deviceItems.isEmpty) {
                  deviceItems.clear();
                  for (var data in snapshot.data!.docs) {
                    deviceItems.add(Device.fromSnapshot(data));
                  }
                }
                upDateAmount(deviceItems);
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: deviceItems.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          shape: const RoundedRectangleBorder(
                            side: BorderSide(color: Colors.black12),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DeviceDetailManagement(
                                        device: deviceItems[index])));
                          },
                          title: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    deviceItems[index].deviceName ?? "Not given",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                          trailing: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection("DevicesType")
                                .doc(deviceItems[index].deviceTypeId)
                                .collection("Devices")
                                .doc(deviceItems[index].deviceId)
                                .collection("Device Detail").snapshots(),
                            builder: (context, snapshot) {
                              if(snapshot.hasData){
                                deviceItems[index].deviceAmount = snapshot.data!.size ?? 0;
                                FirebaseFirestore.instance
                                    .collection("DevicesType")
                                    .doc(deviceItems[index].deviceTypeId)
                                    .collection("Devices")
                                    .doc(deviceItems[index].deviceId).update(deviceItems[index].toMap());
                              }
                              return Text(
                                "Số lượng: ${deviceItems[index].deviceAmount}",
                                style: const TextStyle(color: Colors.white),
                              );
                            }
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                title: const Text('Input Devices Information'),
                content: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextFormField(
                        controller: deviceNameController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Require Device Name";
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'Device Name',
                          hintStyle: const TextStyle(fontSize: 20),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(color: Colors.black12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(color: Colors.black12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: deviceDescriptionController,
                        maxLines: 5,
                        decoration: InputDecoration(
                          hintText: 'Description',
                          hintStyle: const TextStyle(fontSize: 15),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(color: Colors.black12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(color: Colors.black12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      deviceNameController.clear();
                      deviceDescriptionController.clear();
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text('Submit'),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        addDevice();
                        deviceItems.clear();
                        deviceNameController.clear();
                        deviceDescriptionController.clear();
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void upDateAmount(List<Device> listDv) async {
    for (int i = 0; i < listDv.length; i++) {
      int count = 0;
      await FirebaseFirestore.instance
          .collection("DevicesType")
          .doc(listDv[i].deviceTypeId)
          .collection("Devices")
          .doc(listDv[i].deviceId)
          .collection("Device Detail")
          .get()
          .then((value) {
        count = value.size;
      });
      listDv[i].deviceAmount = count;
      await FirebaseFirestore.instance
          .collection("DevicesType")
          .doc(listDv[i].deviceTypeId)
          .collection("Devices")
          .doc(listDv[i].deviceId)
          .update({"Device Amount": count});
    }
  }

  void addDevice() async {
    if (receivedDvType!.deviceTypeId.isNotEmpty) {
      String deviceName = deviceNameController.text;
      String deviceDescription = deviceDescriptionController.text;
      String deviceId = "${deviceName}Device_id";
      Device myDevice = Device(
          deviceId: deviceId,
          deviceName: deviceName,
          description: deviceDescription,
          deviceTypeId: receivedDvType!.deviceTypeId);
      final db = FirebaseFirestore.instance
          .collection("DevicesType")
          .doc(receivedDvType!.deviceTypeId);
      db.collection("Devices").doc(deviceId).set(myDevice.toMap());
    }
  }
}
