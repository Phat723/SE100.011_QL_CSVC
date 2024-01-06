import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_facility_management/Model/AppTheme.dart';
import 'package:school_facility_management/UserModel/borrow_slip_model.dart';
import 'package:school_facility_management/UserModel/devices_detail_model.dart';

class BorrowSlipInfo extends StatefulWidget {
  final BorrowSlip receivedBorrowSlip;

  const BorrowSlipInfo({super.key, required this.receivedBorrowSlip});

  @override
  State<BorrowSlipInfo> createState() => _BorrowSlipInfoState();
}

class _BorrowSlipInfoState extends State<BorrowSlipInfo> {
  BorrowSlip? borrowSlip;
  List<String> selectedBorrowDeviceList = [];
  List<String> damageDeviceNameList = [];
  List<DeviceDetail> damageDeviceList = [];

  @override
  void initState() {
    borrowSlip = widget.receivedBorrowSlip;
    //selectedBorrowDeviceList = List.generate(borrowSlip!.borrowDevices.length, (index) => borrowSlip!.borrowDevices[index]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Borrow Slip Info"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoItem("Người Mượn", borrowSlip?.borrower),
            _buildInfoItem("Người Tạo", borrowSlip?.creatorEmail),
            _buildInfoItem("Trạng Thái", borrowSlip?.status),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                    child:
                        _buildInfoItem("Ngày Mượn:", borrowSlip?.borrowDate)),
                Flexible(
                    child: _buildInfoItem("Ngày Trả:", borrowSlip?.returnDate)),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              "Borrowed Device",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: borrowSlip?.borrowDevices.length ?? 0,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 70,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            borrowSlip!.borrowDevices[index]
                                    ["DeviceDetail Name"] ??
                                "",
                            style: AppTheme.body1,
                          ),
                          Text(borrowSlip!.borrowDevices[index]
                              ["DeviceDetail Status"]),
                          borrowSlip!.status != "Đã trả"?Checkbox(
                            value: damageDeviceNameList.contains(borrowSlip!
                                .borrowDevices[index]["DeviceDetail Name"]),
                            onChanged: (selected) {
                              setState(() {
                                DeviceDetail deviceItem = DeviceDetail.fromMap(
                                    borrowSlip!.borrowDevices[index]);
                                bool isAdding = selected != null && selected;
                                if (isAdding) {
                                  deviceItem.deviceStatus = "Hỏng";
                                  borrowSlip!.borrowDevices[index] = deviceItem.toMap();
                                  damageDeviceList.add(deviceItem);
                                  damageDeviceNameList
                                      .add(deviceItem.deviceDetailName);
                                } else {
                                  deviceItem.deviceStatus = "Đang mượn";
                                  borrowSlip!.borrowDevices[index] = deviceItem.toMap();
                                  FirebaseFirestore.instance
                                      .collection("BorrowSlip")
                                      .doc(borrowSlip!.borrowID)
                                      .update({
                                    "BorrowDevices": {
                                      "DeviceDetail Status":
                                          deviceItem.deviceStatus
                                    }
                                  });
                                  damageDeviceList.remove(deviceItem);
                                  damageDeviceNameList
                                      .remove(deviceItem.deviceDetailName);
                                }
                              });
                            },
                          ):const SizedBox.shrink(),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                borrowSlip!.status == "Chưa trả"
                    ? Flexible(
                        child: ElevatedButton(
                            onPressed: () => confirmBroken().whenComplete(() =>
                                Get.snackbar("Thông báo",
                                    "Thay đổi dữ liệu thành công")),
                            child: const Text("Tạo phiếu vi phạm")),
                      )
                    : const SizedBox.shrink(),
                Flexible(
                  child: ElevatedButton(
                    onPressed: () {
                      borrowSlip!.status = "Đã trả";
                      borrowSlip!.returnDate = "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}";
                      FirebaseFirestore.instance
                          .collection("BorrowSlip")
                          .doc(borrowSlip!.borrowID)
                          .update(borrowSlip!.toMap());
                      Get.back();
                    },
                    child: const Text("Xác nhận"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String? value) {
    return value != null
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$label:",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(value),
                ),
              ],
            ),
          )
        : const SizedBox.shrink();
  }

  Future<void> confirmBroken() async {
    for (int index = 0; index < damageDeviceList.length; index++) {
      var db = FirebaseFirestore.instance
          .collection("DevicesType")
          .doc(damageDeviceList[index].deviceTypeId)
          .collection("Devices")
          .doc(damageDeviceList[index].deviceId)
          .collection("Device Detail")
          .doc(damageDeviceList[index].deviceDetailId);
      await db.update(damageDeviceList[index].toMap());
    }
  }
}
