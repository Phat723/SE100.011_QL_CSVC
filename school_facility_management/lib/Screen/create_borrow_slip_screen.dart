import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:school_facility_management/Controllers/Auth_Controllers.dart';
import 'package:school_facility_management/Controllers/Device_Detail_Controllers.dart';
import 'package:school_facility_management/Model/AppTheme.dart';
import 'package:school_facility_management/UserModel/borrow_slip_model.dart';
import '../UserModel/room_model.dart';

class CreateBorrowSlipScreen extends StatefulWidget {
  const CreateBorrowSlipScreen({super.key});

  @override
  State<CreateBorrowSlipScreen> createState() => _CreateBorrowSlipScreenState();
}

class _CreateBorrowSlipScreenState extends State<CreateBorrowSlipScreen> {
  DeviceDetailController dv = Get.put(DeviceDetailController());
  AuthController authController = Get.put(AuthController());
  Room? selectedRoom;
  String? selectedDevice;
  List<String> borrowDeviceList = [];
  List<Map<String, dynamic>> borrowDeviceSelectedList = [];
  TextEditingController borrowDayController = TextEditingController();
  TextEditingController returnDayController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Create Borrow Slip"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('Area').snapshots(),
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
                  );
                },
              ),
              const SizedBox(height: 20),
              StreamBuilder<QuerySnapshot>(
                stream: dv.roomCollection?.snapshots(),
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
                            child: Text((document.data() as Map)['Room Name']??"Khu vực không có phòng"),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          dv.roomId.value = newValue!;
                          getRoom();
                        });
                      },
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: dv.deviceOwnerController,
                decoration: InputDecoration(
                  hintText: 'Borrow Person Name',
                  prefixIcon: GestureDetector(
                      onTap: () => openQrScanner(),
                      child: const Icon(Icons.qr_code)),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Autocomplete<String>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text == '') {
                    return const Iterable<String>.empty();
                  }
                  if (selectedRoom!.devices!.isNotEmpty) {
                    return borrowDeviceList.where((String item) {
                      return item
                          .toLowerCase()
                          .trim()
                          .contains(textEditingValue.text.toLowerCase().trim());
                    });
                  }
                  return const Iterable.empty();
                },
                fieldViewBuilder: (context, textEditingController, focusNode,
                    onFieldSubmitted) {
                  return TextFormField(
                    enabled: dv.roomId.isNotEmpty,
                    focusNode: focusNode,
                    controller: textEditingController,
                    onFieldSubmitted: (string) {
                      addDeviceTable(string);
                      textEditingController.clear();
                    },
                    decoration: InputDecoration(
                      hintText: "Borrowed device name",
                      prefixIcon: InkWell(
                        onTap: () async {
                          try {
                            textEditingController.text =
                                await FlutterBarcodeScanner.scanBarcode(
                                    "#ff6666", "Cancel", true, ScanMode.QR);
                            if (!mounted) return;
                          } catch (e) {
                            print(e);
                          }
                        },
                        child: const Icon(Icons.qr_code),
                      ),
                      suffixIcon: InkWell(
                        onTap: () {
                          addDeviceTable(textEditingController.text);
                          textEditingController.clear();
                        },
                        child: const Icon(Icons.add),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        child: TextFormField(
                          controller: borrowDayController,
                          readOnly: true,
                          onTap: () {
                            showDatePicker(
                              context: context,
                              initialDate: selectedDate,
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2100),
                            ).then((pickedDate) {
                              if (pickedDate != null) {
                                setState(() {
                                  selectedDate = pickedDate;
                                  borrowDayController.text =
                                      DateFormat('dd/MM/yyyy')
                                          .format(selectedDate);
                                });
                              }
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'Borrow Day',
                            suffixIcon: const Icon(Icons.calendar_today),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: Colors.black12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: Colors.black12),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        child: TextFormField(
                          controller: returnDayController,
                          readOnly: true,
                          onTap: () {
                            showDatePicker(
                              context: context,
                              initialDate: selectedDate,
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2100),
                            ).then((pickedDate) {
                              if (pickedDate != null) {
                                setState(() {
                                  selectedDate = pickedDate;
                                  returnDayController.text =
                                      DateFormat('dd/MM/yyyy')
                                          .format(selectedDate);
                                });
                              }
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'Return Day',
                            suffixIcon: const Icon(Icons.calendar_today),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: Colors.black12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: Colors.black12),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
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
                    ],
                    rows: List.generate(
                        borrowDeviceSelectedList.length,
                        (index) => DataRow(cells: [
                              DataCell(Text(borrowDeviceSelectedList[index]["DeviceDetail Name"])),
                            ]??[])),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  String borrowID = generateRandomString();
                  String creatorName = '';
                  await authController.getCurrentUserInfo().then((value) {
                    creatorName = value!.email;
                  });
                  BorrowSlip newBorrowSlip = BorrowSlip(
                    borrowID: borrowID,
                    borrowDate: borrowDayController.text,
                    returnDate: returnDayController.text,
                    borrower: dv.deviceOwnerController.text,
                    creatorEmail: creatorName,
                    returnProcessorEmail: "",
                    status: "Chưa trả",
                    totalLostAmount: 0,
                    borrowDevices: borrowDeviceSelectedList,
                  );
                  FirebaseFirestore.instance
                      .collection("BorrowSlip")
                      .doc(borrowID)
                      .set(newBorrowSlip.toMap());
                  dv.clearData();
                },
                child: const Text("Create borrow slip"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String generateRandomString() {
    final random = Random();
    String randomDigits = '';

    // Tạo 8 số ngẫu nhiên
    for (int i = 0; i < 8; i++) {
      randomDigits += random.nextInt(10).toString();
    }

    // Thêm tiền tố "RP_"
    String result = "BR_$randomDigits";
    return result;
  }

  Future<void> openQrScanner() async {
    try {
      dv.deviceDetailNameController.text =
          await FlutterBarcodeScanner.scanBarcode(
              "#ff6666", "Cancel", true, ScanMode.QR);
      if (!mounted) return;
    } catch (e) {
      print(e);
    }
  }

  void addDeviceTable(String deviceName) {
    for(Map<String, dynamic> data in selectedRoom!.devices!){
      borrowDeviceSelectedList.addIf(data["DeviceDetail Name"] == deviceName, data);
    }
    setState(() {
      try{
        if(!borrowDeviceList.contains(deviceName)){
          borrowDeviceList.add(deviceName);
        }else{
          Get.snackbar('${deviceName} has been add', 'Please choose other device.');
        }
      }catch(e) {
        Get.snackbar('${deviceName} is not found', 'Please type again.');
      }
    });
  }

  void getRoom() async {
    DocumentReference currentRoom = FirebaseFirestore.instance
        .collection("Area")
        .doc(dv.areaId.value)
        .collection("Room")
        .doc(dv.roomId.value);
    DocumentSnapshot roomSnapshot = await currentRoom.get();
    if (roomSnapshot.exists) {
      setState(() {
        selectedRoom =
            Room.fromMap(roomSnapshot.data() as Map<String, dynamic>);
        borrowDeviceList = List.generate(selectedRoom!.devices!.length, (index) => selectedRoom!.devices![index]["DeviceDetail Name"]);
      });
    }
  }
}
