import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:school_facility_management/Model/AppTheme.dart';
import 'package:school_facility_management/Model/theme.dart';
import 'package:school_facility_management/Screen/maintain_slip_info.dart';
import 'package:school_facility_management/UserModel/maintain_slip_model.dart';


class MaintainSlipManagementScreen extends StatefulWidget {
  const MaintainSlipManagementScreen({Key? key});

  @override
  State<MaintainSlipManagementScreen> createState() =>
      _MaintainSlipManagementScreenState();
}

class _MaintainSlipManagementScreenState
    extends State<MaintainSlipManagementScreen> {
  var dataMaintainSlip = FirebaseFirestore.instance.collection("Maintain");
  List<MaintainSlip> maintainList = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          title: const Text(
            'Quản Lý Phiếu Bảo Trì',
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
          child: StreamBuilder<QuerySnapshot>(
            stream: dataMaintainSlip.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text("Đã xảy ra lỗi");
              }
              if (snapshot.hasData) {
                maintainList.clear();
                for (var data in snapshot.data!.docs) {
                  maintainList.add(MaintainSlip.fromSnapshot(data));
                }
              }
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Expanded(child:ListView.builder(
                      shrinkWrap: true,
                      itemCount: maintainList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                           onTap: () {
                              Get.to(MaintainSlipInfo(receivedMaintainSlip: maintainList[index]));
                            },
                          child: Container(
              margin: const EdgeInsets.only(bottom: 5),
              padding: const EdgeInsets.all(8.0),
              width: context.width,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black45, width: 2.0),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        maintainList[index].maintainID,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                        color: getStatusColor(maintainList[index].maintainStatus),   
                       borderRadius: BorderRadius.circular(50),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 5.0,
                          horizontal: 7.0,
                        ),
                        child: Text(
                          maintainList[index].maintainStatus,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Người Tạo:', style: AppTheme.body1),
                            Text(
                              maintainList[index].creatorName,
                              style: AppTheme.title,
                            ),
                          ],
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            // Ngày Tạo
                            Column(
                              children: [
                                Text(
                                  "Ngày Tạo:",
                                  style: const TextStyle(color: Colors.blue),
                                ),
                                Text(
                                  DateFormat('dd/MM/yyyy').format(
                                    maintainList[index].createDay.toDate(),
                                  ),
                                  style: const TextStyle(color: Colors.blue),
                                ),
                              ],
                            ),
                            // Thời Gian Tạo
                            Column(
                              children: [
                                Text(
                                  "Thời Gian Tạo:",
                                  style: const TextStyle(color: Colors.blue),
                                ),
                                Text(
                                  DateFormat('HH:mm').format(
                                    maintainList[index].createDay.toDate(),
                                  ),
                                  style: const TextStyle(color: Colors.blue),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            // Ngày Kết Thúc
                            Column(
                              children: [
                                Text(
                                  "Ngày Kết Thúc:",
                                  style: const TextStyle(color: Colors.blue),
                                ),
                                Text(
                                  DateFormat('dd/MM/yyyy').format(
                                    maintainList[index].finishDay.toDate(),
                                  ),
                                  style: const TextStyle(color: Colors.blue),
                                ),
                              ],
                            ),
                            // Thời Gian Kết Thúc
                            Column(
                              children: [
                                Text(
                                  "Thời Gian Kết Thúc:",
                                  style: const TextStyle(color: Colors.blue),
                                ),
                                Text(
                                  DateFormat('HH:mm').format(
                                    maintainList[index].finishDay.toDate(),
                                  ),
                                  style: const TextStyle(color: Colors.blue),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          );
                        },
                      ),
                   ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
   Color getStatusColor(String maintainStatus) {
    switch (maintainStatus) {
      case 'Đang bảo trì':
        return Colors.redAccent;
      case 'Hoàn thành':
        return Colors.greenAccent;
      default:
        return Colors.black; // Default color
    }
  }
}
