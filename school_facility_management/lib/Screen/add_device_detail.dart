import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_facility_management/Controllers/Device_Detail_Controllers.dart';

class AddDeviceDetail extends StatelessWidget {
  const AddDeviceDetail({super.key});

  @override
  Widget build(BuildContext context) {
    DeviceDetailController dv = Get.put(DeviceDetailController());
    dv.storeCodeController.text = generateStoreCode();
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
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('Loading...');
                  }
                  return Obx(
                    () => Container(
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
                        items: snapshot.data?.docs
                            .map((DocumentSnapshot document) {
                          return DropdownMenuItem(
                            value: document.id,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text((document.data() as Map)['Name']),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          dv.areaId.value = newValue!;
                          Future<List<DocumentSnapshot<Map<String, dynamic>>>> roomlist = FirebaseFirestore.instance.collection('Area').doc(newValue!).snapshots().toList();
                        },
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Obx(() => Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black12),
                        ),
                        child: Text(
                          "State: ${dv.isState.value ? 'Enable' : 'Disable'}",
                          style: const TextStyle(fontSize: 15),
                        ),
                      )),
                  Obx(
                    () => Switch(
                      value: dv.isState.value,
                      onChanged: (value) {
                        dv.isState.value = value;
                      },
                    ),
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
                      dv.deviceOwnerController.clear();
                      dv.deviceDetailNameController.clear();
                      dv.storeCodeController.clear();
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
  String generateStoreCode() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return String.fromCharCodes(Iterable.generate(
        15, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
  }
}
