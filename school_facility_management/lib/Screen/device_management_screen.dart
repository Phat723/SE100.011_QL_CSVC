import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:school_facility_management/Model/theme.dart';
import 'package:school_facility_management/Screen/device_detail_management.dart';
import 'package:school_facility_management/UserModel/devices_model.dart';

import '../UserModel/devices_type_model.dart';

class DeviceManagement extends StatefulWidget {
  final DeviceType dvType;

  const DeviceManagement({super.key, required this.dvType});

  @override
  State<DeviceManagement> createState() => _DeviceManagementState();
}

class _DeviceManagementState extends State<DeviceManagement> {
  DocumentReference? db;
  final deviceNameController = TextEditingController();
  final deviceDescriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  DeviceType? receivedDvType;
  Device? editedDevice;
  List<Device> deviceItems = [];

  List<bool> _isShowList = [];

  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  @override
  void initState() {
    receivedDvType = widget.dvType;
    db = FirebaseFirestore.instance
        .collection("DevicesType")
        .doc(receivedDvType!.deviceTypeId);
    super.initState();
  }

  @override
  void dispose() {
    deviceDescriptionController.dispose();
    deviceNameController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        toolbarHeight: 110,
        title: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Loại thiết bị',
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
                  hintText: 'Tên loại thiết bị',
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 5,
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 5,
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: db!.collection("Devices").snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text("something went wrong");
                    }
                    if (snapshot.hasData && deviceItems.isEmpty) {
                      deviceItems.clear();
                      for (var data in snapshot.data!.docs) {
                        deviceItems.add(Device.fromSnapshot(data));
                      }
                    }

                    if (deviceItems.isEmpty) {
                      return Center(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          height: 500,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/empty-box.png',
                                width: 250,
                                height: 250,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              const Text(
                                'Chưa có thiết bị nào.',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              const Text(
                                'Các thiết bị sẽ được hiển thị tại đây.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.blueGrey,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    List<Device> tempDeviceItems = deviceItems
                        .where((element) => element.deviceName
                            .trim()
                            .toLowerCase()
                            .contains(_searchText.trim().toLowerCase()))
                        .toList();

                    // Xử lý không tìm ra kết quả
                    if (tempDeviceItems.isEmpty) {
                      return SingleChildScrollView(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          height: 350,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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

                    upDateAmount(tempDeviceItems);

                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: tempDeviceItems.length,
                      itemBuilder: (context, index) {
                        _isShowList.add(false);
                        return Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.blueGrey.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 5,
                                      spreadRadius: 2,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Themes.gradientLightClr,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ListTile(
                                    shape: const RoundedRectangleBorder(
                                      side: BorderSide(color: Colors.black12),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DeviceDetailManagement(
                                                      device: tempDeviceItems[
                                                          index])));
                                    },
                                    title: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                              tempDeviceItems[index].deviceName,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      ],
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: StreamBuilder<QuerySnapshot>(
                                          stream: FirebaseFirestore.instance
                                              .collection("DevicesType")
                                              .doc(tempDeviceItems[index]
                                                  .deviceTypeId)
                                              .collection("Devices")
                                              .doc(tempDeviceItems[index]
                                                  .deviceId)
                                              .collection("Device Detail")
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              tempDeviceItems[index]
                                                      .deviceAmount =
                                                  snapshot.data!.size;
                                              FirebaseFirestore.instance
                                                  .collection("DevicesType")
                                                  .doc(tempDeviceItems[index]
                                                      .deviceTypeId)
                                                  .collection("Devices")
                                                  .doc(tempDeviceItems[index]
                                                      .deviceId)
                                                  .update(tempDeviceItems[index]
                                                      .toMap());
                                            }
                                            return Text(
                                              "Số lượng: ${tempDeviceItems[index].deviceAmount}",
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14),
                                            );
                                          }),
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit, color: Colors.white,),
                                          onPressed: () {
                                            editedDevice =
                                                tempDeviceItems[index];
                                            deviceNameController.text =
                                                editedDevice!.deviceName;
                                            deviceDescriptionController.text =
                                                editedDevice!.description;
                                            showAddAndEditDeviceDialog(
                                                context, true);
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete, color: Colors.white),
                                          onPressed: () {
                                            if (tempDeviceItems[index]
                                                    .deviceAmount >
                                                0) {
                                              showWarmingDelete(context);
                                            } else {
                                              showDeleteConfirmationDialog(
                                                  context,
                                                  tempDeviceItems[index]);
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: _isShowList[index],
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 14, right: 14),
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Text(
                                          (tempDeviceItems[index].description !=
                                                  '')
                                              ? tempDeviceItems[index]
                                                  .description
                                              : 'Trống',
                                          style: const TextStyle(
                                            color: Colors.black87,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isShowList[index] = !_isShowList[index];
                                  });
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          bottom: 8,
                                          top: (_isShowList[index]) ? 0 : 8),
                                      child: Text(
                                        'Xem mô tả',
                                        style: TextStyle(
                                          color: Themes.gradientDeepClr
                                              .withOpacity(0.7),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Icon(
                                      (_isShowList[index])
                                          ? Icons.arrow_drop_down
                                          : Icons.arrow_drop_up,
                                      size: 23,
                                      color: Themes.gradientDeepClr
                                          .withOpacity(0.7),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Themes.gradientDeepClr,
        label: const Text(
          'Thêm loại thiết bị',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        onPressed: () {
          showAddAndEditDeviceDialog(context, false);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void upDateAmount(List<Device> listDv) async {
    for (int i = 0; i < listDv.length; i++) {
      int count = 0;
      await FirebaseFirestore.instance
          .collection("DevicesType")
          .doc(listDv[i].deviceTypeId)
          .collection("Devices")
          .doc(listDv[i].deviceId)
          .collection("Device Detail")
          .get()
          .then((value) {
        count = value.size;
      });
      listDv[i].deviceAmount = count;
      await FirebaseFirestore.instance
          .collection("DevicesType")
          .doc(listDv[i].deviceTypeId)
          .collection("Devices")
          .doc(listDv[i].deviceId)
          .update({"Device Amount": count});
    }
  }

  void addDevice() async {
    if (receivedDvType!.deviceTypeId.isNotEmpty) {
      String deviceName = deviceNameController.text;
      String deviceDescription = deviceDescriptionController.text;
      String deviceId = "${deviceName}Device_id";
      Device myDevice = Device(
          deviceId: deviceId,
          deviceName: deviceName,
          description: deviceDescription,
          deviceTypeId: receivedDvType!.deviceTypeId);
      final db = FirebaseFirestore.instance
          .collection("DevicesType")
          .doc(receivedDvType!.deviceTypeId);
      await db.collection("Devices").doc(deviceId).set(myDevice.toMap());
    }
  }

  void editDevice() async {
    if (editedDevice != null) {
      String deviceName = deviceNameController.text;
      String deviceDescription = deviceDescriptionController.text;
      String deviceId = editedDevice!.deviceId;
      Device myDevice = Device(
          deviceId: deviceId,
          deviceName: deviceName,
          description: deviceDescription,
          deviceTypeId: editedDevice!.deviceTypeId);
      final db = FirebaseFirestore.instance
          .collection("DevicesType")
          .doc(editedDevice!.deviceTypeId);
      await db.collection("Devices").doc(deviceId).update(myDevice.toMap());
    }
  }

  void deleteDevice(Device device) async {
    final db = FirebaseFirestore.instance
        .collection('DevicesType')
        .doc(device.deviceTypeId)
        .collection('Devices');

    await db.doc(device.deviceId).delete();
  }

  void showDeleteConfirmationDialog(BuildContext context, Device device) {
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
            'Bạn có chắc chắn muốn xóa thiết bị này?',
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
                deleteDevice(device);
                setState(() {
                  deviceItems.remove(device);
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
            'Không thể xóa thiết bị này vì số lượng lớn hơn 0!',
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

  void showAddAndEditDeviceDialog(BuildContext context, bool isEdit) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            isEdit ? 'Sửa thông tin thiết bị' : 'Nhập thông tin thiết bị',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  width: 400,
                  child: TextFormField(
                    controller: deviceNameController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Vui lòng nhập tên!";
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Tên thiết bị',
                      hintStyle: const TextStyle(fontSize: 16),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: Colors.black12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: Colors.black12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 400,
                  child: TextFormField(
                    controller: deviceDescriptionController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: 'Mô tả',
                      hintStyle: const TextStyle(fontSize: 16),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: Colors.black12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: Colors.black12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Hủy'),
              onPressed: () {
                deviceNameController.clear();
                deviceDescriptionController.clear();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(isEdit ? 'Cập nhật' : 'Thêm'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  if (isEdit) {
                    editDevice();
                  } else {
                    addDevice();
                  }
                  deviceItems.clear();
                  deviceNameController.clear();
                  deviceDescriptionController.clear();
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
