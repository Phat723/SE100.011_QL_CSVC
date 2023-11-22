
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:school_facility_management/Screen/device_detail_management.dart';
import 'package:school_facility_management/Screen/home_screen.dart';
import 'package:school_facility_management/Screen/user_management_screen.dart';
import 'package:school_facility_management/UserModel/devices_model.dart';

class DeviceManagement extends StatefulWidget {
  final String dvTypeName;
  final CollectionReference db;
  const DeviceManagement({super.key, required this.dvTypeName, required this.db});

  @override
  State<DeviceManagement> createState() => _DeviceManagementState();
}

class _DeviceManagementState extends State<DeviceManagement> {
  late final DocumentReference db;
  final deviceNameController = TextEditingController();
  final deviceDescriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String receiveDeviceName = '';


  late List<Map<String, dynamic>> deviceItems;
  bool isLoad = false;

  void loadDevice() async {
    List<Map<String, dynamic>> tempList = [];
    final deviceDb = db.collection("Devices");
    var data = await deviceDb.get();
    for (var element in data.docs) {
      tempList.add(element.data());
    }
    setState(() {
      deviceItems = tempList;
      isLoad = true;
    });
  }
  @override
  void initState() {
    setState(() {
      receiveDeviceName = widget.dvTypeName;
      db = widget.db.doc("${receiveDeviceName}Type_id");
    });
    loadDevice();
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
      body: Center(
        child: isLoad
            ? ListView.builder(
            itemCount: deviceItems.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => DeviceDetailManagement(db: db,deviceName: deviceItems[index]["Device Name"],)));
                  },
                  shape: RoundedRectangleBorder(
                      side: const BorderSide(width: 2),
                      borderRadius: BorderRadius.circular(20)),
                  leading: const CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Icon(Icons.person),
                  ),
                  title: Row(
                    children: [
                      Text(deviceItems[index]["Device Name"] ?? "Not given"),
                    ],
                  ),
                  subtitle: Text(deviceItems[index]["Device Amount"].toString()),
                  trailing: const Icon(Icons.more_vert),
                ),
              );
            })
            : const Text("No data"),
      ),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                title: const Text('Input Devices Information'),
                content: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextFormField(
                        controller: deviceNameController,
                        validator: (value) {
                          if(value!.isEmpty){
                            return "Require Device Name";
                          }else{
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
                        deviceNameController.clear();
                        deviceDescriptionController.clear();
                        loadDevice();
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
  void addDevice() async{
    if(receiveDeviceName != ''){
      String deviceName = deviceNameController.text;
      String deviceDescription = deviceDescriptionController.text;
      String deviceId = "${deviceName}Device_id";
      Device myDevice = Device(deviceId: deviceId, deviceName: deviceName, description: deviceDescription);
      final db = FirebaseFirestore.instance
          .collection("DevicesType")
          .doc("${receiveDeviceName}Type_id");
      db.collection("Devices").doc(deviceId).set(myDevice.toMap());
      var count = await db.collection("Devices").get().then((value) => value.size);
      db.update({"DeviceType Amount": count});
    }
  }
}
