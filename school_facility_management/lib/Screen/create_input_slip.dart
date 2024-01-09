import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
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
  CollectionReference deviceTypeStream =
      FirebaseFirestore.instance.collection('DevicesType');
  CollectionReference? deviceStream;
  DeviceDetailController detailController = Get.put(DeviceDetailController());
  InOutController inOutController = Get.put(InOutController());
  File? _selectedFiles;
  List<Map<String, dynamic>> data = [];

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
                  if (snapshot.hasData) {
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
                      ),
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
                              deviceStream = deviceTypeStream
                                  .doc(value)
                                  .collection("Devices");
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
                  if (snapshot.hasData) {
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
                    ),
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
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                        onPressed: () {
                          readExcelFile();
                        },
                        child: Text('Add Excel file')),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        inOutController.items.add(
                          DeviceDetail(
                            deviceDetailId:
                                "${detailController.deviceDetailNameController.text}detail_id",
                            storeCode: storeCode,
                            deviceDetailName: detailController
                                .deviceDetailNameController.text,
                            deviceStatus: "Disable",
                            deviceId: "${deviceSelected}Device_id",
                            deviceTypeId: "${deviceTypeSelected}Type_id",
                            deviceCost: "10000",
                            maintainTime: 2,
                            storingDay: DateTime.now().toString(),
                          ),
                        );
                        detailController.deviceDetailNameController.clear();
                      });
                    },
                    child: const Text('Add to list'),
                  ),
                ],
              ),
              // FutureBuilder(
              //   initialData: data,
              //   future: null,
              //   builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
              //     if (snapshot.connectionState == ConnectionState.waiting) {
              //       return CircularProgressIndicator();
              //     } else {
              //       return DataTable(
              //         columns: const [
              //           DataColumn(label: Text('Tên thiết bị')),
              //           DataColumn(label: Text('Giá tiền')),
              //           DataColumn(label: Text('Ngày nhập')),
              //           // Thêm các cột khác tương tự
              //         ],
              //         rows: snapshot.data!.map((row) {
              //           return DataRow(cells: [
              //             DataCell(Text(row['deviceDetailId'].toString())),
              //             DataCell(Text(row['deviceCost'].toString())),
              //             DataCell(Text(row['storingDay'].toString())),
              //             // Thêm các ô dữ liệu khác tương tự
              //           ]);
              //         }).toList(),
              //       );
              //     }
              //   },
              // ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    inOutController.items.add(DeviceDetail(
                        deviceCost: '222',
                        maintainTime: 15,
                        deviceDetailId:
                            "${detailController.deviceDetailNameController.text}detail_id",
                        storeCode: storeCode,
                        deviceDetailName:
                            detailController.deviceDetailNameController.text,
                        deviceStatus: "Disable",
                        deviceId: "${deviceSelected}Device_id",
                        deviceTypeId: "${deviceTypeSelected}Type_id",
                        storingDay: ''));
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
                                inOutController.items[index]
                                    .toMap()['DeviceDetail Name'],
                                overflow: TextOverflow.visible,
                              ),
                            ),
                            DataCell(Text(inOutController.items[index]
                                .toMap()['RoomId'])),
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
                onPressed: () {
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

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );
    if (result == null) return;

    setState(() {
      _selectedFiles = File(result.files.first.path!);
    });
  }

  Future<void> readExcelFile() async {
    pickFile();
    String file = '';
    if(_selectedFiles != null){
      file = _selectedFiles!.path;
    }
    var bytes = File(file).readAsBytesSync();
    var excel = Excel.decodeBytes(bytes);
    var table = excel.tables.keys.first;
    Sheet sheet = excel.tables[table]!;
    String storeId = detailController.generateInOutId();
    inOutController.generateInputSlip(storeId, 'Mua mới');
    var myRows = excel.tables[table]?.rows;
    for (int i = 1; i < myRows!.length; i++) {
      print(sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: i))
          .value);
      data.add({
        "DeviceDetail Id": sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: i))
            .value
            .toString(),
        "Device Id": sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: i))
            .value
            .toString(),
        "DeviceType Id": sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: i))
            .value
            .toString(),
        "AreaId": sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: i))
            .value
            .toString(),
        "RoomId": sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: i))
            .value
            .toString(),
        "StoreCode": storeCode,
        "DeviceDetail Name": sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: i))
            .value
            .toString(),
        "DeviceDetail Status": 'Sẵn dùng',
        "DeviceDetail Owner": '',
        "DeviceDetail Cost": sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: i))
            .value
            .toString(),
        "DeviceDetail MaintainTime": int.parse(sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: i))
            .value
            .toString()),
        "DeviceDetail StoringDay": sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: i))
            .value
            .toString(),
      });
    }
    inOutController.items = List.generate(
        data.length, (index) => DeviceDetail.fromMap(data[index]));
    data.clear();
    FilePicker.platform.clearTemporaryFiles();
    setState(() {});
  }
}
