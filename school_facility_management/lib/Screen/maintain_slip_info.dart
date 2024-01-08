import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:school_facility_management/Model/AppTheme.dart';
import 'package:school_facility_management/Model/theme.dart';
import 'package:school_facility_management/UserModel/devices_detail_model.dart';
import 'package:school_facility_management/UserModel/maintain_slip_model.dart';

class MaintainSlipInfo extends StatefulWidget {
  final MaintainSlip receivedMaintainSlip;

  const MaintainSlipInfo({Key? key, required this.receivedMaintainSlip})
      : super(key: key);

  @override
  _MaintainSlipInfoState createState() => _MaintainSlipInfoState();
}

class _MaintainSlipInfoState extends State<MaintainSlipInfo> {
  MaintainSlip? maintainSlip;
  List<String> selectedMaintainDeviceList = [];
  List<String> maintainDeviceNameList = [];
  // List<DeviceDetail> damageDeviceList = [];


  @override
  void initState() {
    maintainSlip = widget.receivedMaintainSlip;
    super.initState();
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
            _buildInfoItem("Người Tạo", maintainSlip?.creatorName),
            _buildInfoItem("Trạng Thái", maintainSlip?.maintainStatus),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
               Flexible(
                  child: _buildInfoItem(
                    "Ngày Tạo",
                    formattedDate(maintainSlip?.createDay),
                  ),
                ),
                Flexible(
                  child: _buildInfoItem(
                    "Ngày Kết Thúc",
                    formattedDate(maintainSlip?.finishDay),
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
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: maintainSlip?.maintainDeviceList.length ?? 0,
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
                            maintainSlip?.maintainDeviceList[index]
                                    ["DeviceDetail Name"] ??
                                "",
                            style: AppTheme.body1,
                          ),
                          Text(
                            maintainSlip?.maintainDeviceList[index]
                                ["DeviceDetail Status"],
                          ),
                        
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            //Bug
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
               
                Flexible(
                  child: ElevatedButton(
                     onPressed: () async {
                      maintainSlip!.maintainStatus = "Hoàn thành";
                      maintainSlip!.finishDay = Timestamp.fromDate(DateTime.now());
                    await FirebaseFirestore.instance
                      .collection("Maintain")
                      .doc(maintainSlip!.maintainID)
                      .update({
                        "Maintain Device List": maintainSlip!.maintainDeviceList.map((device) {
                          return {
                            ...device,
                            "DeviceDetail Status": "Sẵn dùng",
                          };
                        }).toList(),
                        "Maintain Status":"Hoàn thành"
                      });


            // Navigate back
            Get.back();
        },
        child: const Text("Xác nhận"),
                 ),
                )
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
  String formattedDate(Timestamp? timestamp) {
  if (timestamp != null) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('dd/MM/yyyy').format(dateTime);
  } else {
    return 'N/A'; // Return a default value if the timestamp is null
  }
}
}
