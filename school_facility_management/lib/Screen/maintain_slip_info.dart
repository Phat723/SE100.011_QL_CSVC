import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:school_facility_management/Model/AppTheme.dart';
import 'package:school_facility_management/Model/theme.dart';
import 'package:school_facility_management/UserModel/maintain_slip_model.dart';
import 'package:school_facility_management/UserModel/user_model.dart';

class MaintainSlipInfo extends StatefulWidget {
  final MaintainSlip receivedMaintainSlip;

  const MaintainSlipInfo({Key? key, required this.receivedMaintainSlip})
      : super(key: key);

  @override
  _MaintainSlipInfoState createState() => _MaintainSlipInfoState();
}

class _MaintainSlipInfoState extends State<MaintainSlipInfo> {
  MaintainSlip? maintainSlip;
  String confirmName = ""; 

  @override
  void initState() {
    maintainSlip = widget.receivedMaintainSlip;
    getCurrentUser();
    super.initState();
  }
  Future<void> getCurrentUser() async {
    User? firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser != null) {
      // Use the user's ID to fetch user information from Firestore
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await FirebaseFirestore.instance
              .collection("Client")
              .doc(firebaseUser.uid)
              .get();

      // Create a MyUser object from the Firestore data
      MyUser currentUser = MyUser.fromSnapShot(userSnapshot);

      setState(() {
        // Set the confirmName with the username
        confirmName = currentUser.username;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text(
          'Chi Tiết Phiếu Bảo Trì',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoItem("Người Tạo", maintainSlip?.creatorName, TextStyle(fontSize: 16)),
            _buildInfoItem("Trạng Thái", maintainSlip?.maintainStatus, TextStyle(fontSize: 16)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: _buildInfoItem(
                    "Ngày Tạo",
                    formattedDate(maintainSlip?.createDay),
                    TextStyle(fontSize: 14),
                  ),
                ),
                Flexible(
                  child: _buildInfoItem(
                    "Ngày Kết Thúc",
                    formattedDate(maintainSlip?.finishDay),
                    TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              "Thiết bị đã bảo trì",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: maintainSlip?.maintainDeviceList.length ?? 0,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              maintainSlip?.maintainDeviceList[index]["DeviceDetail Name"] ?? "",
                              style: AppTheme.body1.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              maintainSlip?.maintainDeviceList[index]["DeviceDetail Status"] ?? "",
                              style: TextStyle(
                                color: getStatusColor(maintainSlip?.maintainDeviceList[index]["DeviceDetail Status"]),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Center( // Center the button
              child: ElevatedButton(
                onPressed: () async {
                  maintainSlip!.maintainStatus = "Hoàn thành";
                  maintainSlip!.finishDay = Timestamp.fromDate(DateTime.now());
                  await FirebaseFirestore.instance.collection("Maintain").doc(maintainSlip!.maintainID).update({
                    "Maintain Device List": maintainSlip!.maintainDeviceList.map((device) {
                      return {
                        ...device,
                        "DeviceDetail Status": "Sẵn dùng",
                      };
                    }).toList(),
                    "Maintain Status": "Hoàn thành",
                    "Confirm Name":confirmName,
                  });
                  Get.back();  
                },
                style: ElevatedButton.styleFrom(
                  primary: const Color.fromARGB(255, 72, 119, 222),
                  foregroundColor: Colors.white, // Text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  child: Text(
                    "Xác nhận",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String? value, TextStyle style) {
    return value != null
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$label:",
                  style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 14),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    value,
                    style: style,
                  ),
                ),
              ],
            ),
          )
        : const SizedBox.shrink();
  }

  String formattedDate(Timestamp? timestamp) {
    if (timestamp != null) {
      DateTime dateTime = timestamp.toDate();
      return DateFormat('dd/MM/yyyy').format(dateTime);
    } else {
      return 'N/A'; // Return a default value if the timestamp is null
    }
  }

  Color getStatusColor(String? status) {
    if (status == "Đang bảo trì") {
      return Colors.red;
    } else if (status == "Sẵn dùng") {
      return Colors.green;
    } else {
      return Colors.black;
    }
  }
}