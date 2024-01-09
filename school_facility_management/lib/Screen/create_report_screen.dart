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
import 'package:school_facility_management/Model/theme.dart';
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
  bool _isSaving = false;

  @override
  void dispose() {
    dv.dispose();
    myAuth.dispose();
    _scrollController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            foregroundColor: Colors.white,
            title: const Text(
              'Phiếu báo hỏng',
              style: TextStyle(fontSize: 20),
            ),
            elevation: 0,
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
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 4),
                        child: RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: 'Chọn khu vực: ',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18,
                                ),
                              ),
                              TextSpan(
                                text: '*',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('Area')
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return const Text('Something went wrong');
                          }
                          return Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.black12)),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                isExpanded: true,
                                value: dv.areaId.value == ''
                                    ? null
                                    : dv.areaId.value,
                                hint: DropdownMenuItem(
                                  value: dv.areaId.value,
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      "Chọn khu vực...",
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ),
                                items: snapshot.data?.docs
                                    .map((DocumentSnapshot document) {
                                  return DropdownMenuItem(
                                    value: document.id,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text((document.data()
                                      as Map)['Area Name']),
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
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 4),
                        child: RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: 'Chọn phòng: ',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18,
                                ),
                              ),
                              TextSpan(
                                text: '*',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                isExpanded: true,
                                value: dv.roomId.value == ''
                                    ? null
                                    : dv.roomId.value,
                                hint: DropdownMenuItem(
                                  value: dv.roomId.value,
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      "Chọn phòng...",
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ),
                                items: snapshot.data?.docs
                                    .map((DocumentSnapshot document) {
                                  return DropdownMenuItem(
                                    value: document.id,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text((document.data()
                                      as Map)['Room Name']),
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
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 4),
                        child: RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: 'Chọn thiết bị trong phòng: ',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18,
                                ),
                              ),
                              TextSpan(
                                text: '*',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black12),
                            borderRadius: BorderRadius.circular(15)),
                        constraints: const BoxConstraints(maxHeight: 150),
                        child: (selectedRoom != null)
                            ? Padding(
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
                                      duration: const Duration(
                                          milliseconds: 500),
                                      curve: Curves.easeInOut,
                                    );
                                    selectedDeviceName =
                                    selectedRoom!.devices![index]
                                    ["DeviceDetail Name"];
                                    selectedDevice =
                                    selectedRoom!.devices![index];
                                  });
                                },
                                child: Container(
                                  height: 50,
                                  alignment: Alignment.centerLeft,
                                  color: (selectedDeviceName ==
                                      selectedRoom!.devices![index]
                                      ["DeviceDetail Name"])
                                      ? Colors.blue
                                      : Colors.transparent,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      selectedRoom!.devices![index]
                                      ["DeviceDetail Name"],
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          color: (selectedDeviceName ==
                                              selectedRoom!
                                                  .devices![index]
                                              [
                                              "DeviceDetail Name"])
                                              ? Colors.white
                                              : Colors.black),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                            : const Center(
                          child: Text(
                            "Chưa có dữ liệu...",
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w400,
                                fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 4),
                        child: RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: 'Mô tả:',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18,
                                ),
                              ),
                              TextSpan(
                                text: ' *',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      TextFormField(
                        maxLines: 2,
                        controller: descriptionController,
                        decoration: InputDecoration(
                          hintText:
                          'Nhập mô tả về thiết bị hỏng hoặc ghi tên các thiết bị khác trong phòng...',
                          hintStyle: const TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.w400),
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
                        padding:
                        EdgeInsets.symmetric(vertical: 5, horizontal: 4),
                        child: Text(
                          "Hình thiết bị hỏng:",
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      GridView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: imageFile.length + 1,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
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
                                borderRadius: BorderRadius.circular(15),
                                child: Container(
                                  margin: const EdgeInsets.all(5),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.grey.shade300,
                                  ),
                                  child: const Icon(Icons.add,
                                      color: Colors.grey, size: 60),
                                ),
                              ),
                            );
                          }
                          return Stack(
                            children: [
                              LayoutBuilder(builder: (BuildContext context,
                                  BoxConstraints constraints) {
                                return Center(
                                  child: Container(
                                    height: constraints.maxWidth - 10,
                                    width: constraints.maxHeight - 10,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.grey,
                                    ),
                                    alignment: Alignment.center,
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: constraints.maxWidth - 10,
                                          width: constraints.maxHeight - 10,
                                          child: ClipRRect(
                                            borderRadius:
                                            BorderRadius.circular(15),
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
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                    child: const Icon(
                                      Icons.cancel,
                                      color: Colors.red,
                                      size: 30,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
                border: Border(
                    top: BorderSide(
                      color: Colors.blueGrey,
                      width: 0.3,
                    ))),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        imageFile.clear();
                        imageUrls.clear();
                        selectedDeviceName = '';
                        selectedDevice.clear();
                        selectedRoom = null;
                        descriptionController.clear();
                        dv.clearData();
                        Get.back();
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      height: 55,
                      margin: const EdgeInsets.only(
                        left: 5,
                        right: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          'Hủy phiếu',
                          style: TextStyle(
                            color: Colors.black45,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _createReport();
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      height: 55,
                      margin: const EdgeInsets.only(
                        left: 5,
                        right: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Themes.gradientDeepClr,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          'Gửi phiếu',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_isSaving)
          const Opacity(
            opacity: 0.5,
            child: ModalBarrier(dismissible: false, color: Colors.black),
          ),
        if (_isSaving)
          const Center(
            child: CircularProgressIndicator(),
          ),
      ],
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
    setState(() {
      _isSaving = true;
    });
    if (dv.areaId.value.isEmpty ||
        dv.roomId.value.isEmpty ||
        selectedDevice.isEmpty ||
        descriptionController.text.isEmpty) {
      setState(() {
        _isSaving = false;
      });
      Get.snackbar("Thông Báo", "Vui lòng nhập đầy đủ thông tin");

      return;
    }
    if (imageFile.isNotEmpty) {
      await _uploadImage(imageFile);
    }
    String reportId = generateRandomString();
    String creatorName = '';
    await myAuth.getCurrentUserInfo().then((value) {
      creatorName = value!.username;
    });
    try {
      selectedDevice['DeviceDetail Status'] = 'Báo hỏng';
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
      final collectionReference =
      FirebaseFirestore.instance.collection("Report");
      await collectionReference.doc(reportId).set(newReport.toMap());
      setState(() {
        imageFile.clear();
        imageUrls.clear();
        selectedDeviceName = '';
        selectedDevice.clear();
        selectedRoom = null;
        descriptionController.clear();
        dv.clearData();
        Get.back();
      });
      Get.snackbar("Thông Bao", "Thêm mới báo cáo thành công");
    } catch (e) {
      Get.snackbar("Thông Báo", "Có lỗi xảy ra trong quá trình báo cáo");
    }
    setState(() {
      _isSaving = true;
    });
  }

  Future<void> _uploadImage(List<File> image) async {
    final storage = FirebaseStorage.instance;
    final Reference storageReference = storage.ref();
    for (File file in image) {
      String imageName = Path.basename(file.path);
      TaskSnapshot upLoadTask =
      await storageReference.child("report_image/$imageName").putFile(file);
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
