import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:school_facility_management/Controllers/Device_Detail_Controllers.dart';
import 'package:school_facility_management/Controllers/InOut_Controller.dart';
import 'package:school_facility_management/Screen/add_device_detail_screen.dart';
import 'package:school_facility_management/UserModel/devices_detail_model.dart';

class DeviceDetailManagement extends StatefulWidget {
  final DocumentReference db;
  final String deviceName;

  const DeviceDetailManagement(
      {super.key, required this.db, required this.deviceName});

  @override
  State<DeviceDetailManagement> createState() => _DeviceDetailManagementState();
}

class _DeviceDetailManagementState extends State<DeviceDetailManagement> {
  late final DocumentReference dvDetailDb;
  late List<Map<String, dynamic>> deviceDetailItems;
  InOutController inOutController = Get.put(InOutController());
  DeviceDetailController detailController = Get.put(DeviceDetailController());
  String receiveDeviceName = '';
  bool isLoaded = false;

  @override
  void initState() {
    setState(() {
      receiveDeviceName = widget.deviceName;
      dvDetailDb =
          widget.db.collection("Devices").doc("${receiveDeviceName}Device_id");
    });
    loadDeviceDetail();
    super.initState();
  }

  void loadDeviceDetail() async {
    final db = dvDetailDb.collection("Device Detail");
    List<Map<String, dynamic>> tempList = [];
    var data = await db.get();
    for (var element in data.docs) {
      tempList.add(element.data());
    }
    setState(() {
      deviceDetailItems = tempList;
      isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: isLoaded
              ? ListView.builder(
                  itemCount: deviceDetailItems.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        onLongPress: () {
                          deleteDeviceDetail(index,
                              deviceDetailItems[index]['DeviceDetail Id']);
                        },
                        shape: RoundedRectangleBorder(
                            side: const BorderSide(width: 2),
                            borderRadius: BorderRadius.circular(20)),
                        title: Row(
                          children: [
                            Text(deviceDetailItems[index]
                                    ["DeviceDetail Name"] ??
                                "Not given"),
                          ],
                        ),
                        subtitle: Text(
                            deviceDetailItems[index]["DeviceDetail Status"]),
                        trailing: const Icon(Icons.more_vert),
                      ),
                    );
                  },
                )
              : const CircularProgressIndicator(),
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

  void addDeviceDetail() async{
    if (receiveDeviceName.isNotEmpty) {
      DeviceDetailController dv = Get.put(DeviceDetailController());
      InOutController ioController = Get.put(InOutController());
      DeviceDetail myDeviceDetail = DeviceDetail(
          deviceDetailId: "${dv.deviceDetailNameController.text}_detail_id",
          roomId: dv.roomId.value,
          areaId: dv.areaId.value,
          storeCode: dv.storeCodeController.text,
          deviceDetailName: dv.deviceDetailNameController.text,
          deviceStatus: dv.isState.value ? "Enable" : "Disable",
          deviceOwner: dv.deviceOwnerController.text);
      if (dv.deviceDetailNameController.text != '') {
        final db = dvDetailDb
            .collection("Device Detail")
            .doc("${dv.deviceDetailNameController.text}_detail_id");
        await db.set(myDeviceDetail.toMap());
        upDateAmount();
        loadDeviceDetail();
        ioController.generateInputSlip(dv.storeCodeController.text, dv.caseValue);
        detailController.clearData();
      }
    }
  }
  void upDateAmount() async{
    var newAmount = await dvDetailDb.collection("Device Detail").get().then((value) => value.size);
    dvDetailDb.update({'Device Amount': newAmount});
  }
  deleteDeviceDetail(int index, String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),side: const BorderSide(color: Colors.black, width: 2.0)),
          elevation: 2,
          title: const Text('Delete'),
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Please Chose Delete Option",textAlign: TextAlign.start),
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
                dvDetailDb.collection("Device Detail").doc(id).delete();
                setState(() {
                  deviceDetailItems.removeAt(index);
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
