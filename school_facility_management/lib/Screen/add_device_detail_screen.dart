import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_facility_management/Controllers/Device_Detail_Controllers.dart';

class AddDeviceDetail extends StatefulWidget {
  const AddDeviceDetail({super.key});

  @override
  State<AddDeviceDetail> createState() => _AddDeviceDetailState();
}

class _AddDeviceDetailState extends State<AddDeviceDetail> {
  DeviceDetailController dv = Get.put(DeviceDetailController());
  CollectionReference areaCollection =
      FirebaseFirestore.instance.collection("Area");
  CollectionReference? roomCollection;
  bool isChoose = false;

  @override
  void initState() {
    dv.storeCodeController.text = dv.generateInOutId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Add Device Detail",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              TextFormField(
                controller: dv.storeCodeController,
                enabled: false,
                decoration: InputDecoration(
                  labelText: 'Store Code',
                  hintText: dv.storeCodeController.text,
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.black12),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: dv.deviceDetailNameController,
                decoration: InputDecoration(
                  hintText: 'Device Detail Name',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.black12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.black12),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: dv.deviceOwnerController,
                decoration: InputDecoration(
                  hintText: 'Owner Names',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.black12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.black12),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('Area').snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }
                  return Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black12)),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: dv.areaId.value == '' ? null : dv.areaId.value,
                      hint: DropdownMenuItem(
                        value: dv.areaId.value,
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Area"),
                        ),
                      ),
                      items:
                          snapshot.data?.docs.map((DocumentSnapshot document) {
                        return DropdownMenuItem(
                          value: document.id,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text((document.data() as Map)['Name']),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          dv.areaId.value = newValue!;
                          roomCollection = areaCollection
                              .doc(dv.areaId.value)
                              .collection("Room");
                          dv.roomId.value =
                              ''; //Tránh xung đột với dropdown phía dưới
                        });
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              StreamBuilder<QuerySnapshot>(
                stream: roomCollection?.snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  return Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black12)),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: dv.roomId.value == '' ? null : dv.roomId.value,
                      hint: DropdownMenuItem(
                        value: dv.roomId.value,
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Room"),
                        ),
                      ),
                      items:
                          snapshot.data?.docs.map((DocumentSnapshot document) {
                        return DropdownMenuItem(
                          value: document.id,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text((document.data() as Map)['Name']),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          dv.roomId.value = newValue!;
                        });
                      },
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black12)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: dv.caseValue,
                    onChanged: (String? newValue) {
                      setState(() {
                        dv.caseValue = newValue!;
                      });
                    },
                    items: dv.caseItems.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black12),
                    ),
                    child: Text(
                      "State: ${dv.isState.value ? 'Enable' : 'Disable'}",
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                  Switch(
                    value: dv.isState.value,
                    onChanged: (value) {
                      setState(() {
                        dv.isState.value = value;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text("Add"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      dv.clearData();
                      Get.back();
                    },
                    child: const Text("Cancel"),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    ));
  }
}
