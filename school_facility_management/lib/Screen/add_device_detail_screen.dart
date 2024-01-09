import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_facility_management/Controllers/Device_Detail_Controllers.dart';
import 'package:school_facility_management/Model/theme.dart';
class AddDeviceDetail extends StatefulWidget {
  const AddDeviceDetail({super.key});

  @override
  State<AddDeviceDetail> createState() => _AddDeviceDetailState();
}

class _AddDeviceDetailState extends State<AddDeviceDetail> {
  DeviceDetailController dv = Get.put(DeviceDetailController());
  bool isChoose = false;

  @override
  void initState() {
    dv.storeCodeController.text = dv.generateInOutId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
        body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Add Device Detail",
                  style:
                      TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
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
              const SizedBox(height: 10),
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
              const SizedBox(height: 10),
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
              const SizedBox(height: 10),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StreamBuilder<QuerySnapshot>(
                    stream:
                        FirebaseFirestore.instance.collection('Area').snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return const Text('Something went wrong');
                      }
                      return Flexible(
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.black12)),
                          child: DropdownButtonHideUnderline(
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
                                    child: Text((document.data() as Map)['Area Name']),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  dv.areaId.value = newValue!;
                                  dv.roomCollection = dv.areaCollection
                                      .doc(dv.areaId.value)
                                      .collection("Room");
                                  dv.roomId.value =
                                      ''; //Tránh xung đột với dropdown phía dưới
                                });
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 5),
                  StreamBuilder<QuerySnapshot>(
                    stream: dv.roomCollection?.snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return const Text('Something went wrong');
                      }
                      return Flexible(
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.black12)),
                          child: DropdownButtonHideUnderline(
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
                              items: snapshot.data?.docs
                                  .map((DocumentSnapshot document) {
                                return DropdownMenuItem(
                                  value: document.id,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child:
                                        Text((document.data() as Map)['Room Name']),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  dv.roomId.value = newValue!;
                                });
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10,),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black12)),
                child: DropdownButtonHideUnderline(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: DropdownButton<String>(
                      hint: const DropdownMenuItem<String>(
                        value: null,
                        child: Text("Loại nhập"),
                      ),
                      isExpanded: true,
                      value: dv.caseValue == '' ? null : dv.caseValue,
                      onChanged: (String? newValue) {
                        setState(() {
                          dv.caseValue = newValue!;
                        });
                      },
                      items: dv.caseItems
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: dv.deviceMaintainTimeController,
                decoration: InputDecoration(
                  hintText: 'Thời hạn bảo trì',
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
              const SizedBox(height: 10),
              TextFormField(
                controller: dv.deviceCostController,
                decoration: InputDecoration(
                  hintText: 'Giá trị của thiết bị',
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
