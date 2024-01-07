
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_facility_management/Controllers/Device_Detail_Controllers.dart';
import 'package:school_facility_management/Controllers/InOut_Controller.dart';
import 'package:school_facility_management/Model/AppTheme.dart';
import 'package:school_facility_management/UserModel/devices_detail_model.dart';

class CreateInputSlipScreen extends StatefulWidget {
  const CreateInputSlipScreen({super.key});

  @override
  State<CreateInputSlipScreen> createState() => _CreateInputSlipScreenState();
}

class _CreateInputSlipScreenState extends State<CreateInputSlipScreen> {
  String? deviceTypeSelected;
  String? deviceSelected;
  String storeCode = '';
  CollectionReference deviceTypeStream = FirebaseFirestore.instance.collection('DevicesType');
  CollectionReference? deviceStream;
  DeviceDetailController detailController = Get.put(DeviceDetailController());
  InOutController inOutController = Get.put(InOutController());

  @override
  void initState() {
    storeCode = detailController.generateInOutId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: deviceTypeStream.snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if(snapshot.hasData){
                    List<DropdownMenuItem> deviceTypeItems = [];
                    for (var doc in snapshot.data!.docs) {
                      deviceTypeItems.add(
                        DropdownMenuItem(
                          value: doc.id,
                          child: Text(doc['DeviceType Name']),
                        ),
                      );
                    }
                    return Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.black12)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButton(
                          hint: DropdownMenuItem(
                            value: deviceTypeSelected,
                            child: const Text("Chose Device Type"),
                          ),
                          isExpanded: true,
                          value: deviceTypeSelected,
                          items: deviceTypeItems,
                          onChanged: (value) {
                            setState(() {
                              deviceTypeSelected = value!;
                              deviceSelected = null;
                              deviceStream = deviceTypeStream.doc(value).collection("Devices");
                            });
                          },
                        ),
                      ),
                    );
                  }
                  return const Text("Not Found");
                },
              ),
              const SizedBox(
                height: 20,
              ),
              StreamBuilder<QuerySnapshot>(
                stream: deviceStream?.snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  List<DropdownMenuItem> deviceTypeItems = [];
                  if(snapshot.hasData){
                    for (var doc in snapshot.data!.docs) {
                      deviceTypeItems.add(
                        DropdownMenuItem(
                          value: doc.id,
                          child: Text(doc['Device Name']),
                        ),
                      );
                    }
                  }
                    return Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.black12)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButton(
                          isExpanded: true,
                          hint: DropdownMenuItem(
                            value: deviceSelected,
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("Devices"),
                            ),
                          ),
                          value: deviceSelected,
                          items: deviceTypeItems,
                          onChanged: (value) {
                            setState(() {
                              deviceSelected = value!;
                            });
                          },
                        ),
                      ),
                    );
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: detailController.deviceDetailNameController,
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
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                    setState(() {
                      inOutController.items.add(DeviceDetail(
                          deviceDetailId: "${detailController.deviceDetailNameController.text}detail_id",
                          storeCode: storeCode,
                          deviceDetailName: detailController.deviceDetailNameController.text,
                          deviceStatus: "Disable", deviceId: "${deviceSelected}Device_id", deviceTypeId: "${deviceTypeSelected}Type_id"));
                      detailController.deviceDetailNameController.clear();
                    });
                },
                child: const Text('Add to list'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: SingleChildScrollView(
                    child: DataTable(
                      columns: const [
                        DataColumn(
                            label: Text(
                          'Tên Thiết bị',
                          style: AppTheme.title,
                        )),
                        DataColumn(
                            label: Text(
                          'Phòng',
                          style: AppTheme.title,
                        )),
                        DataColumn(
                            label: Text(
                          '',
                          style: AppTheme.title,
                        )),
                      ],
                      rows: List.generate(
                        inOutController.items.length,
                        (index) => DataRow(
                          cells: [
                            DataCell(
                              Text(
                                inOutController.items[index].toMap()['DeviceDetail Name'],
                                  overflow: TextOverflow.visible,
                                ),
                            ),
                            DataCell(Text(inOutController.items[index].toMap()['RoomId'])),
                            DataCell(
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  setState(() {
                                    inOutController.items.removeAt(index);
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: (){
                  inOutController.inputSlipToFirebase();
                  Get.back();
                },
                child: const Text('Create Input Slip'),
              ),
            ],
          ),
        ),
      ),
    );

  }
}
