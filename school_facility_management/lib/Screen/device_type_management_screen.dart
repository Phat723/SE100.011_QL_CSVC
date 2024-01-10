// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_facility_management/Model/theme.dart';
import 'package:school_facility_management/Screen/device_management_screen.dart';
import 'package:school_facility_management/UserModel/devices_type_model.dart';
import 'package:school_facility_management/my_button.dart';

class DeviceTypeManagement extends StatefulWidget {
  const DeviceTypeManagement({super.key});

  @override
  State<DeviceTypeManagement> createState() => _DeviceTypeManagementState();
}

class _DeviceTypeManagementState extends State<DeviceTypeManagement> {
  final db = FirebaseFirestore.instance.collection("DevicesType");
  List<DeviceType> items = [];
  final TextEditingController deviceTypeNameController =
      TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';
  final List<File> _selectedFile = [];

  DeviceType? editDeviceType;

  bool _isLoading = false;

  @override
  void dispose() {
    deviceTypeNameController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            foregroundColor: Colors.white,
            toolbarHeight: 110,
            title: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Danh mục thiết bị',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.9,
                      height: 1.5),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.shade800.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    controller: _searchController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(10),
                      hintText: 'Tên danh mục thiết bị',
                      hintStyle: const TextStyle(
                        color: Colors.white70,
                        fontSize: 15,
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.white70,
                        size: 23,
                      ),
                      border: InputBorder.none,
                      suffixIconConstraints:
                          const BoxConstraints(maxHeight: 30, maxWidth: 30),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _searchText = '';
                            _searchController.text = _searchText;
                          });
                        },
                        child: Container(
                          width: 16,
                          height: 16,
                          margin: const EdgeInsets.only(
                            right: 10,
                          ),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white70,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.clear,
                              size: 15,
                              color: Colors.blueGrey.shade700,
                            ),
                          ),
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchText = value;
                        _searchController.text = _searchText;
                      });
                    },
                  ),
                ),
              ],
            ),
            centerTitle: true,
            automaticallyImplyLeading: false,
            elevation: 0,
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
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: StreamBuilder<QuerySnapshot>(
                      stream: db.snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text(snapshot.error.toString());
                        }
                        if (snapshot.hasData && items.isEmpty) {
                          for (var data in snapshot.data!.docs) {
                            items.add(DeviceType.fromSnapshot(data));
                          }
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SizedBox(
                              height: 400,
                              width: 400,
                              child:
                                  Center(child: CircularProgressIndicator()));
                        }

                        List<DeviceType> tempItems = items
                            .where((element) => element.deviceTypeName
                                .trim()
                                .toLowerCase()
                                .contains(_searchText.trim().toLowerCase()))
                            .toList();

                        // Xử lý không tìm ra kết quả
                        if (tempItems.isEmpty) {
                          return SingleChildScrollView(
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              height: 350,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Image.asset(
                                    'assets/no_result_search_icon.png',
                                    width: 250,
                                    height: 250,
                                    fit: BoxFit.contain,
                                  ),
                                  const Text(
                                    'Không tìm thấy kết quả',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    'Rất tiếc, chúng tôi không tìm thấy kết quả mà bạn mong muốn, hãy thử lại xem sao.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        //--------------------------------

                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: tempItems.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2, childAspectRatio: 0.81),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  Get.to(DeviceManagement(
                                      dvType: tempItems[index]));
                                },
                                child: Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          if (tempItems[index].imageURL !=
                                                  null &&
                                              tempItems[index].imageURL != '')
                                            SizedBox(
                                              height: 158,
                                              child: ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  topLeft: Radius.circular(19),
                                                  topRight: Radius.circular(19),
                                                ),
                                                child: Image.network(
                                                  width: 300,
                                                  height: 300,
                                                  tempItems[index].imageURL!,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          if (tempItems[index].imageURL !=
                                                  null &&
                                              tempItems[index].imageURL == '')
                                            SizedBox(
                                              height: 140,
                                              child: ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  topLeft: Radius.circular(19),
                                                  topRight: Radius.circular(19),
                                                ),
                                                child: Image.asset(
                                                  width: 300,
                                                  height: 300,
                                                  'assets/csvc.jpg',
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          Divider(
                                            thickness: 0,
                                            height: 0,
                                            color: Colors.blueGrey
                                                .withOpacity(0.5),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Container(
                                            width: 200,
                                            height: 50,
                                            decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(20),
                                                  bottomRight:
                                                      Radius.circular(20),
                                                ),
                                                color: Colors.white),
                                            child: Column(
                                              children: [
                                                Text(
                                                  tempItems[index]
                                                      .deviceTypeName,
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                StreamBuilder<QuerySnapshot>(
                                                    stream: FirebaseFirestore
                                                        .instance
                                                        .collection(
                                                            "DevicesType")
                                                        .doc(tempItems[index]
                                                            .deviceTypeId)
                                                        .collection("Devices")
                                                        .snapshots(),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot.hasData) {
                                                        tempItems[index]
                                                                .deviceTypeAmount =
                                                            snapshot.data!.size;
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                "DevicesType")
                                                            .doc(tempItems[
                                                                    index]
                                                                .deviceTypeId)
                                                            .update(
                                                                tempItems[index]
                                                                    .toMap());
                                                      }
                                                      return Text(
                                                        "Số lượng: ${tempItems[index].deviceTypeAmount}",
                                                        style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14,
                                                        ),
                                                      );
                                                    })
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      right: 10,
                                      top: 10,
                                      child: Container(
                                        height: 30,
                                        width: 30,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.yellow,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                              spreadRadius: 2,
                                              blurRadius: 3,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: PopupMenuButton(
                                          padding: EdgeInsets.zero,
                                          iconColor: Colors.blueAccent,
                                          itemBuilder: (context) => [
                                            const PopupMenuItem(
                                              value: 'edit',
                                              child: Text('Sửa'),
                                            ),
                                            const PopupMenuItem(
                                              value: 'delete',
                                              child: Text('Xóa'),
                                            ),
                                          ],
                                          onSelected: (value) {
                                            if (value == 'edit') {
                                              editDeviceType = tempItems[index];
                                              _handleUpdate(tempItems[index]);
                                            } else if (value == 'delete') {
                                              _handleDelete(tempItems[index]);
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }),
                ),
                const SizedBox(
                  height: 80,
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            backgroundColor: Themes.gradientDeepClr,
            label: const Text(
              'Thêm danh mục thiết bị',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            onPressed: () {
              addAndEditDeviceType(false);
            },
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        ),
        if (_isLoading)
          Positioned.fill(
            child: Container(
              color: Colors.black54,
            ),
          )
      ],
    );
  }

  void addAndEditDeviceType(bool isEdit) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            bool isImage = _selectedFile.length == 1;
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(
                isEdit
                    ? 'Sửa thông tin loại thiết bị'
                    : 'Thêm loại thiết bị mới',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              content: SizedBox(
                height: 120,
                width: 400,
                child: Column(
                  children: [
                    TextFormField(
                      controller: deviceTypeNameController,
                      decoration: const InputDecoration(
                        hintText: 'Nhập tên loại thiết bị',
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    GestureDetector(
                      onTap: () async {
                        _selectedFile.clear();
                        final result = await FilePicker.platform.pickFiles(
                          allowMultiple: true,
                          type: FileType.custom,
                          allowedExtensions: ['png', 'jpg', 'jpeg'],
                        );

                        if (result != null) {
                          final List<File> selectedFiles = result.paths
                              .map((path) => File(path!))
                              .where((file) => file
                                  .existsSync()) // Lọc bỏ các tệp không tồn tại
                              .toList();

                          if (selectedFiles.length <= 1) {
                            setState(() {
                              _selectedFile.addAll(selectedFiles);
                            });
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Thông báo'),
                                content: const Text(
                                    'Bạn chỉ được chọn tối đa 1 ảnh.'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Đã hiểu'),
                                  ),
                                ],
                              ),
                            );
                          }
                        }
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.image,
                            color: isImage ? Colors.red : Colors.blueGrey,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            isImage ? 'Đã chọn ảnh' : 'Chọn ảnh minh họa',
                            style: TextStyle(
                              fontSize: 16,
                              color: isImage ? Colors.red : Colors.blueGrey,
                            ),
                          ),
                          const Spacer(),
                          if (isImage)
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedFile.clear();
                                });
                              },
                              child: Container(
                                width: 25,
                                height: 25,
                                margin: const EdgeInsets.only(
                                  right: 10,
                                ),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.red,
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.clear,
                                    size: 15,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                Row(
                  children: [
                    MyButton(
                      text: 'Hủy',
                      onPressed: () {
                        Navigator.of(context).pop();
                        deviceTypeNameController.clear();
                      },
                    ),
                    const Spacer(),
                    MyButton(
                      text: (isEdit) ? 'Cập nhật' : 'Thêm',
                      onPressed: () async {
                        setState(() {
                          _isLoading = true;
                        });
                        String imageURL = '';

                        if (deviceTypeNameController.text.isNotEmpty) {
                          String newItemName = deviceTypeNameController.text;
                          if (_selectedFile.isNotEmpty) {
                            imageURL =
                                await uploadImageToStorage(_selectedFile[0]);
                          }

                          DeviceType myDeviceType;

                          if (isEdit) {
                            myDeviceType = DeviceType(
                              deviceTypeId: editDeviceType!.deviceTypeId,
                              deviceTypeName: newItemName,
                              imageURL: (imageURL == '')
                                  ? editDeviceType!.imageURL
                                  : imageURL,
                            );
                          } else {
                            myDeviceType = DeviceType(
                              deviceTypeId: "${newItemName}Type_id",
                              deviceTypeName: newItemName,
                              imageURL: imageURL,
                            );
                          }

                          setState(() {
                            if (isEdit) {
                              int index = items.indexWhere((item) =>
                                  item.deviceTypeId ==
                                  myDeviceType.deviceTypeId);
                              if (index != -1) {
                                db
                                    .doc(myDeviceType.deviceTypeId)
                                    .update(myDeviceType.toMap());
                                items[index] = myDeviceType;
                              }
                            } else {
                              db
                                  .doc("${newItemName}Type_id")
                                  .set(myDeviceType.toMap());
                              items.add(myDeviceType);
                            }
                          });
                          _selectedFile.clear();
                          deviceTypeNameController.clear();
                          Navigator.of(context).pop();
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<String> uploadImageToStorage(File imageFile) async {
    String imageURL = "";

    try {
      // Tạo tham chiếu đến đường dẫn lưu trữ trên Firebase Storage
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageReference =
          FirebaseStorage.instance.ref().child(fileName);

      // Upload file ảnh lên Firebase Storage
      UploadTask uploadTask = storageReference.putFile(imageFile);
      TaskSnapshot storageSnapshot = await uploadTask.whenComplete(() {});
      String downloadURL = await storageSnapshot.ref.getDownloadURL();

      // Lấy đường link của file ảnh đã tải lên
      imageURL = downloadURL;
    } catch (e) {
      print(e.toString());
    }

    return imageURL;
  }

  _handleDelete(DeviceType deviceType) {
    if (deviceType.deviceTypeAmount > 0) {
      showWarmingDelete(context);
    } else {
      showDeleteConfirmationDialog(context, deviceType);
    }
  }

  _handleUpdate(DeviceType deviceType) {
    deviceTypeNameController.text = deviceType.deviceTypeName;
    _selectedFile.clear;
    addAndEditDeviceType(true);
  }

  void showDeleteConfirmationDialog(
      BuildContext context, DeviceType deviceType) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Xác nhận xóa',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          content: const Text(
            'Bạn có chắc chắn muốn xóa loại thiết bị này?',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Xóa'),
              onPressed: () {
                deleteDeviceType(deviceType);
                setState(() {
                  items.remove(deviceType);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showWarmingDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Thông báo',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          content: const Text(
            'Không thể xóa loại thiết bị này vì số lượng lớn hơn 0!',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Đã hiểu'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void deleteDeviceType(DeviceType deviceType) async {
    await FirebaseFirestore.instance
        .collection('DevicesType')
        .doc(deviceType.deviceTypeId)
        .delete();
  }
}
