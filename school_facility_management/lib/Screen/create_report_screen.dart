import 'dart:io';
import 'dart:math';
import 'package:path/path.dart' as Path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:school_facility_management/Controllers/Auth_Controllers.dart';
import 'package:school_facility_management/Controllers/Device_Detail_Controllers.dart';
import 'package:school_facility_management/UserModel/report_model.dart';
import 'package:school_facility_management/UserModel/room_model.dart';

class CreateReportScreen extends StatefulWidget {
  const CreateReportScreen({super.key});

  @override
  State<CreateReportScreen> createState() => _CreateReportScreenState();
}

class _CreateReportScreenState extends State<CreateReportScreen> {
  DeviceDetailController dv = Get.put(DeviceDetailController());
  AuthController myAuth = Get.put(AuthController());
  Room? selectedRoom;
  Map<String, dynamic> selectedDevice = {};
  String selectedDeviceName = '';
  List<String> imageUrls = [];
  List<File> imageFile = [];
  final ScrollController _scrollController = ScrollController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
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
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12),
                  ),
                  constraints: const BoxConstraints(maxHeight: 150),
                  child: (selectedRoom != null)?Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: selectedRoom?.devices?.length ?? 0,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              _scrollController.animateTo(
                                index * 50,
                                // Adjust this value based on your item height
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                              );
                              selectedDeviceName = selectedRoom!.devices![index]["DeviceDetail Name"];
                              selectedDevice = selectedRoom!.devices![index];
                            });
                          },
                          child: Container(
                            height: 50,
                            alignment: Alignment.centerLeft,
                            color: (selectedDeviceName == selectedRoom!.devices![index]["DeviceDetail Name"]) ? Colors.blue:Colors.transparent,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                selectedRoom!.devices![index]["DeviceDetail Name"],
                                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16,
                                    color: (selectedDeviceName ==
                                            selectedRoom!.devices![index]["DeviceDetail Name"])
                                        ? Colors.white
                                        : Colors.black),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ): const Center(child: Text("Vui lòng chọn phòng"),),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  maxLines: 2,
                  controller: descriptionController,
                  decoration: InputDecoration(
                    hintText: 'Description',
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
                  height: 10,
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Thêm ảnh (Tối đa 7 ảnh)",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                GridView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: imageFile.length + 1,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 3.0,
                    mainAxisSpacing: 3.0,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    if (index == imageFile.length) {
                      return InkWell(
                        onTap: () async {
                          final image = await _takePicture();
                          if (image != null) {
                            // Upload ảnh lên Firebase Storage
                            setState(() {
                              imageFile.add(image);
                            });
                          }
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Container(
                            margin: const EdgeInsets.all(5),
                            alignment: Alignment.center,
                            color: Colors.grey.shade300,
                            child: const Icon(Icons.add,
                                color: Colors.grey, size: 60),
                          ),
                        ),
                      );
                    }
                    return Stack(
                      children: [
                        LayoutBuilder(builder:
                            (BuildContext context, BoxConstraints constraints) {
                          return Center(
                            child: Container(
                              height: constraints.maxWidth - 10,
                              width: constraints.maxHeight - 10,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: Colors.grey,
                              ),
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: constraints.maxWidth - 10,
                                    width: constraints.maxHeight - 10,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(6),
                                      child: Image.file(
                                        imageFile[index],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: InkWell(
                            onTap: () {
                              // Xử lý sự kiện khi người dùng chọn loại bỏ ảnh
                              setState(() {
                                imageFile.removeAt(index);
                              });
                            },
                            child: const Icon(
                              Icons.cancel,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                ElevatedButton(
                    onPressed: (){
                      setState(() {
                        _createReport();
                      });
                    },
                    child: const Text("Tạo Phiếu Báo Hỏng"),
                )
              ],
            ),
          ),
        ),
      ),
      appBar: AppBar(),
    );
  }

  Future<File?> _takePicture() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      return File(pickedFile.path);
    }

    return null;
  }
  String generateRandomString() {
    final random = Random();
    String randomDigits = '';

    // Tạo 8 số ngẫu nhiên
    for (int i = 0; i < 8; i++) {
      randomDigits += random.nextInt(10).toString();
    }

    // Thêm tiền tố "RP_"
    String result = "RP_$randomDigits";
    return result;
  }
  Future<void> _createReport() async {
    if (dv.areaId.value.isEmpty ||
        dv.roomId.value.isEmpty ||
        selectedDevice.isEmpty ||
        imageFile.isEmpty ||
        descriptionController.text.isEmpty) {
      Get.snackbar("Thông Báo", "Vui lòng nhập đầy đủ thông tin");
      return;
    }
    await _uploadImage(imageFile);
    String reportId = generateRandomString();
    String creatorName = '';
    await myAuth.getCurrentUserInfo().then((value){
      creatorName = value!.username;
    });
    try {
      Report newReport = Report(
          reportId: reportId,
          areaId: dv.areaId.value,
          roomId: dv.roomId.value,
          deviceDetail: selectedDevice,
          creator: creatorName,
          creationDate: DateTime.now().subtract(const Duration(hours: 7)),
          status: "Chờ duyệt",
          description: descriptionController.text,
          imageList: imageUrls);
      final collectionReference = FirebaseFirestore.instance.collection(
          "Report");
      await collectionReference.doc(reportId).set(newReport.toMap());
      setState(() {
        imageFile.clear();
        imageUrls.clear();
        selectedDeviceName = '';
        selectedDevice.clear();
        selectedRoom = null;
        descriptionController.clear();
        dv.clearData();
      });
      Get.snackbar("Thông Bao", "Thêm mới báo cáo thành công");
    } catch(e){
      Get.snackbar("Thông Báo","Có lỗi xảy ra trong quá trình báo cáo");
    }
  }
  Future<void> _uploadImage(List<File> image) async {
    final storage = FirebaseStorage.instance;
    final Reference storageReference = storage.ref();
    for (File file in image) {
      String imageName = Path.basename(file.path);
      TaskSnapshot upLoadTask = await storageReference.child("report_image/$imageName").putFile(file);
      String imageUrl = await upLoadTask.ref.getDownloadURL();
      imageUrls.add(imageUrl);
    }
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
        selectedRoom = Room.fromSnapshot(roomSnapshot);
      });
    }
  }
}
