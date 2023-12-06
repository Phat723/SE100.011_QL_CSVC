import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:school_facility_management/Screen/device_management_screen.dart';
import 'package:school_facility_management/Screen/home_screen.dart';
import 'package:school_facility_management/Screen/user_management_screen.dart';
import 'package:school_facility_management/UserModel/devices_type_model.dart';
import 'package:school_facility_management/my_button.dart';

class DeviceTypeManagement extends StatefulWidget {
  const DeviceTypeManagement({super.key});

  @override
  State<DeviceTypeManagement> createState() => _DeviceTypeManagementState();
}
class _DeviceTypeManagementState extends State<DeviceTypeManagement> {
  final db = FirebaseFirestore.instance.collection("DevicesType");
  late List<Map<String, dynamic>> items;
  bool isLoad = false;
  final TextEditingController deviceTypeNameController = TextEditingController();

  @override
  void dispose() {
    deviceTypeNameController.dispose();
    super.dispose();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadDeviceType();
  }

  void loadDeviceType() async {
    List<Map<String, dynamic>> tempList = [];
    var data = await db.get();
    for (var element in data.docs) {
      tempList.add(element.data());
    }
    setState(() {
      isLoad = true;
      items = tempList;
      items.sort((a, b) => a["DeviceType Name"].compareTo(b["DeviceType Name"]));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: isLoad
              ? GridView.builder(
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
                    }else{
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () async{
                              await Navigator.push(context, MaterialPageRoute(builder: (context) => DeviceManagement(dvTypeName: items[index]["DeviceType Name"], db: db,)));
                              loadDeviceType();
                          },
                          onLongPress: () => showDeleteDialog("${items[index]["DeviceType Name"]}Type_id", index),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.green,
                                    Colors.greenAccent
                                  ]
                              ),
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  items[index]["DeviceType Name"] ?? "Not given",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Image.asset("assets/facilities_icon.png"),
                                const SizedBox(height: 10,),
                                Text(
                                  "Số lượng: ${items[index]["DeviceType Amount"]}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ) : const CircularProgressIndicator()),
      appBar: AppBar(
        title: const Text("School facility"),
        backgroundColor: Colors.green,
      ),
      drawer: Drawer(
        width: 250,
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.green,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("School Facility",
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                  SizedBox(
                    child: Image.asset("assets/img.png"),
                  )
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HomeScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.manage_accounts),
              title: const Text('User Management'),
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const UserManagement()));
              },
            ),
          ],
        ),
      ),
    );
  }

  void addDeviceType() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                  String newItemName = deviceTypeNameController.text;
                  DeviceType myDeviceType = DeviceType(deviceTypeId: "${newItemName}Type_id", deviceTypeName: newItemName);
                  setState(() {
                    db.doc("${newItemName}Type_id").set(myDeviceType.toMap());
                    items.add(myDeviceType.toMap());
                  });
                Navigator.of(context).pop();
                deviceTypeNameController.clear();
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
