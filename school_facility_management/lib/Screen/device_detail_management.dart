import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_facility_management/Controllers/Device_Detail_Controllers.dart';
import 'package:school_facility_management/Controllers/InOut_Controller.dart';
import 'package:school_facility_management/Controllers/Room_Controller.dart';
import 'package:school_facility_management/Model/theme.dart';
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

  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
      appBar: AppBar(
        foregroundColor: Colors.white,
        toolbarHeight: 110,
        title: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Stack(
              children: [
                const SizedBox(
                  height: 30,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Thiết bị',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.9,
                            height: 1.5),
                      ),
                    ],
                  ),
                ),
                Positioned(
                    right: -10,
                    top: -10,
                    child: IconButton(
                      icon: const Icon(
                        Icons.add_box,
                        size: 30,
                      ),
                      onPressed: () async {
                        await Get.to(const AddDeviceDetail());
                        addDeviceDetail();
                        detailController.clearData();
                      },
                    ))
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 45,
              decoration: BoxDecoration(
                color: Colors.blueGrey.shade800.withOpacity(0.7),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextFormField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(10),
                  hintText: 'Tên thiết bị',
                  hintStyle: const TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.white70,
                    size: 23,
                  ),
                  border: InputBorder.none,
                  suffixIconConstraints:
                      const BoxConstraints(maxHeight: 30, maxWidth: 30),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        _searchText = '';
                        _searchController.text = _searchText;
                      });
                    },
                    child: Container(
                      width: 16,
                      height: 16,
                      margin: const EdgeInsets.only(
                        right: 10,
                      ),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white70,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.clear,
                          size: 15,
                          color: Colors.blueGrey.shade700,
                        ),
                      ),
                    ),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchText = value;
                    _searchController.text = _searchText;
                  });
                },
              ),
            ),
          ],
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Themes.gradientDeepClr, Themes.gradientLightClr],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8),
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
                            deleteDeviceDetail(
                                deviceDetailItems[index].toMap());
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
      ),
    );
  }

  void addDeviceDetail() async {
    if (receivedDevice!.deviceTypeId.isNotEmpty &&
        receivedDevice!.deviceId.isNotEmpty) {
      DeviceDetail myDeviceDetail = DeviceDetail(
          deviceDetailId:
              "${detailController.deviceDetailNameController.text}_detail_id",
          roomId: detailController.roomId.value,
          areaId: detailController.areaId.value,
          storeCode: detailController.storeCodeController.text,
          deviceDetailName: detailController.deviceDetailNameController.text,
          deviceStatus: 'Sẵn dùng',
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
        roomController.addDeviceToRoom(detailController.areaId.value,
            detailController.roomId.value, myDeviceDetail.toMap());
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
