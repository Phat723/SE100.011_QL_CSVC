import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:school_facility_management/Controllers/Device_Detail_Controllers.dart';
import 'package:school_facility_management/Screen/add_device_detail.dart';
import 'package:school_facility_management/UserModel/devices_detail_model.dart';
import 'package:school_facility_management/UserModel/devices_model.dart';

class DeviceDetailManagement extends StatefulWidget {
  final DocumentReference db;
  final String deviceName;
  const DeviceDetailManagement({super.key, required this.db, required this.deviceName});
  @override
  State<DeviceDetailManagement> createState() => _DeviceDetailManagementState();
}

class _DeviceDetailManagementState extends State<DeviceDetailManagement> {
  late final DocumentReference dvDetailDb;
  String receiveDeviceName = '';
  late List<Map<String, dynamic>> deviceDetailItems;
  bool isLoaded = false;
  @override
  void initState() {
    setState(() {
      receiveDeviceName = widget.deviceName;
      dvDetailDb = widget.db.collection("Devices").doc("${receiveDeviceName}Device_id");
    });
    loadDeviceDetail();
    super.initState();
  }
  void loadDeviceDetail() async{
    final db = dvDetailDb.collection("Device Detail");
    List<Map<String, dynamic>> tempList = [];
    var data = await db.get();
    for(var element in data.docs){
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
          child: isLoaded?ListView.builder(
            itemCount: deviceDetailItems.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  onTap: (){
                    //Navigator.push(context, MaterialPageRoute(builder: (context) => DeviceDetailManagement(db: db,deviceName: deviceItems[index]["Device Name"],)));
                  },
                  shape: RoundedRectangleBorder(
                      side: const BorderSide(width: 2),
                      borderRadius: BorderRadius.circular(20)),
                  title: Row(
                    children: [
                      Text(deviceDetailItems[index]["DeviceDetail Name"] ?? "Not given"),
                    ],
                  ),
                  subtitle: Text(deviceDetailItems[index]["DeviceDetail Status"]),
                  trailing: const Icon(Icons.more_vert),
                ),
              );
          },): const Text("No data"),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          await Get.to(const AddDeviceDetail());
          addDeviceDetail();
        },
      ),
    );
  }
  void addDeviceDetail(){
    if(receiveDeviceName != ''){
      DeviceDetailController dv = Get.put(DeviceDetailController());
      String deviceDetailId = "${dv.deviceDetailNameController.text}_detail_id";
      String deviceOwnerName = dv.deviceOwnerController.text;
      String deviceDetailName = dv.deviceDetailNameController.text;
      String deviceStatus = dv.isState.value ? "Enable":"Disable";
      String storeCode = dv.storeCodeController.text;
      DeviceDetail myDeviceDetail = DeviceDetail(
          deviceDetailId: deviceDetailId,
          areaId: dv.areaId.value,
          storeCode: storeCode,
          deviceDetailName: deviceDetailName,
          deviceStatus: deviceStatus,
          deviceOwner: deviceOwnerName);
      if(dv.deviceDetailNameController.text != ''){
        final db = dvDetailDb.collection("Device Detail").doc(deviceDetailId);
        db.set(myDeviceDetail.toMap());
        loadDeviceDetail();
      }
    }
  }
}
