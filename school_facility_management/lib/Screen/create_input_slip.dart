import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart' as ex;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_facility_management/Controllers/Device_Detail_Controllers.dart';
import 'package:school_facility_management/Controllers/InOut_Controller.dart';
import 'package:school_facility_management/Model/AppTheme.dart';
import 'package:school_facility_management/Model/theme.dart';
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
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text(
          'Tạo phiếu nhập',
          style: TextStyle(fontSize: 20),
        ),
        centerTitle: true,
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
                            child: const Text("Chọn danh mục thiết bị"),
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
                            child: Text("Chọn loại thiết bị"),
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
                  hintText: 'Tên thiết bị',
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
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('Area')
                        .snapshots(),
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
                              value: detailController.areaId.value == ''
                                  ? null
                                  : detailController.areaId.value,
                              hint: DropdownMenuItem(
                                value: detailController.areaId.value,
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text("Khu vực"),
                                ),
                              ),
                              items: snapshot.data?.docs
                                  .map((DocumentSnapshot document) {
                                return DropdownMenuItem(
                                  value: document.id,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        (document.data() as Map)['Area Name']),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  detailController.areaId.value = newValue!;
                                  detailController.roomCollection =
                                      detailController.areaCollection
                                          .doc(detailController.areaId.value)
                                          .collection("Room");
                                  detailController.roomId.value =
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
                    stream: detailController.roomCollection?.snapshots(),
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
                              value: detailController.roomId.value == ''
                                  ? null
                                  : detailController.roomId.value,
                              hint: DropdownMenuItem(
                                value: detailController.roomId.value,
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text("Phòng"),
                                ),
                              ),
                              items: snapshot.data?.docs
                                  .map((DocumentSnapshot document) {
                                return DropdownMenuItem(
                                  value: document.id,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        (document.data() as Map)['Room Name']),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  detailController.roomId.value = newValue!;
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
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: detailController.deviceMaintainTimeController,
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
                controller: detailController.deviceCostController,
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
                        child: const Text('Thêm bằng file excel')),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          inOutController.items.add(DeviceDetail(
                            roomId: detailController.roomId.value,
                              areaId: detailController.areaId.value,
                              deviceCost:
                                  detailController.deviceCostController.text,
                              maintainTime: int.parse(detailController
                                  .deviceMaintainTimeController.text),
                              deviceDetailId:
                                  "${detailController.deviceDetailNameController.text}detail_id",
                              storeCode: storeCode,
                              deviceDetailName: detailController
                                  .deviceDetailNameController.text,
                              deviceStatus: "Disable",
                              deviceId: "$deviceSelected",
                              deviceTypeId: "$deviceTypeSelected",
                              storingDay: DateTime.now().toString()));
                          detailController.deviceDetailNameController.clear();
                        });
                      },
                      child: const Text('Thêm vào danh sách'),
                    ),
                  ),
                ],
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
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        )),
                        DataColumn(
                            label: Text(
                          'Phòng',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
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
                                overflow: TextOverflow.ellipsis,
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
                child: const Text('Tạo phiếu xuất'),
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
    if (_selectedFiles != null) {
      file = _selectedFiles!.path;
    }
    var bytes = File(file).readAsBytesSync();
    ex.Excel excel = ex.Excel.decodeBytes(bytes);
    var table = excel.tables.keys.first;
    ex.Sheet sheet = excel.tables[table]!;
    String storeId = detailController.generateInOutId();
    inOutController.generateInputSlip(storeId, 'Mua mới');
    var myRows = excel.tables[table]?.rows;
    for (int i = 1; i < myRows!.length; i++) {
      data.add({
        "DeviceDetail Id": sheet
            .cell(ex.CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: i))
            .value
            .toString(),
        "Device Id": sheet
            .cell(ex.CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: i))
            .value
            .toString(),
        "DeviceType Id": sheet
            .cell(ex.CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: i))
            .value
            .toString(),
        "AreaId": sheet
            .cell(ex.CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: i))
            .value
            .toString(),
        "RoomId": sheet
            .cell(ex.CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: i))
            .value
            .toString(),
        "StoreCode": storeCode,
        "DeviceDetail Name": sheet
            .cell(ex.CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: i))
            .value
            .toString(),
        "DeviceDetail Status": 'Sẵn dùng',
        "DeviceDetail Owner": '',
        "DeviceDetail Cost": sheet
            .cell(ex.CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: i))
            .value
            .toString(),
        "DeviceDetail MaintainTime": int.parse(sheet
            .cell(ex.CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: i))
            .value
            .toString()),
        "DeviceDetail StoringDay": sheet
            .cell(ex.CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: i))
            .value
            .toString(),
      });
    }
    inOutController.items = List.generate(
        data.length, (index) => DeviceDetail.fromMap(data[index]));
    data.clear();
    setState(() {});
  }
}
