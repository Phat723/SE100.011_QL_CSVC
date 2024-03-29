import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:school_facility_management/Model/AppTheme.dart';
import 'package:school_facility_management/Model/theme.dart';
import 'package:school_facility_management/Screen/create_maintain_slip_screen.dart';
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

  Future<void> _deleteMaintainSlip(String maintainID) async {
    try {
      await FirebaseFirestore.instance
          .collection("Maintain")
          .doc(maintainID)
          .delete();
      // Optionally, you may want to update the UI or show a confirmation message
    } catch (e) {
      // Handle errors, show an error message, or log the error
      print("Error deleting Maintain Slip: $e");
    }
  }

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
          actions: [
          IconButton(onPressed: () {
    Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (_) => const CreateMaintainSlip()),
                      );
          }, icon: const Icon(Icons.add_box_rounded),)
        ],
        ),
        body: Center(
          child: StreamBuilder<QuerySnapshot>(
            stream: dataMaintainSlip.orderBy('Create Day',descending: true).snapshots(),
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: maintainList.length,
                        itemBuilder: (context, index) {
                          return Dismissible(
                            key: Key(maintainList[index].maintainID),
                            confirmDismiss: (direction) async {
                              if (maintainList[index].maintainStatus ==
                                  'Đang bảo trì') {
                                // Trạng thái là 'Đang bảo trì', không cho xóa
                                return false;
                              } else if (maintainList[index].maintainStatus ==
                                  'Hoàn thành') {
                                // Hiển thị hộp thoại xác nhận khi trạng thái là 'Hoàn thành'
                                bool confirmDelete = await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text("Xác nhận xóa"),
                                      content: const Text(
                                          "Bạn có chắc muốn xóa phiếu này không?"),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(false),
                                          child: const Text("Không"),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(true),
                                          child: const Text("Có"),
                                        ),
                                      ],
                                    );
                                  },
                                );

                                if (confirmDelete) {
                                  _deleteMaintainSlip(
                                      maintainList[index].maintainID);
                                }

                                return confirmDelete;
                              } else {
                                // Trường hợp khác, cho phép xóa
                                _deleteMaintainSlip(
                                    maintainList[index].maintainID);
                                return true;
                              }
                            },
                            background: Container(
                              color: Colors.redAccent,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20.0),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            child: InkWell(
                              onTap: () {
                                // Navigate to detail page when tapped
                                Get.to(
                                      () => MaintainSlipInfo(
                                    receivedMaintainSlip: maintainList[index],
                                  ),
                                );
                              },
                              child: Card(
                                margin: const EdgeInsets.only(bottom: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                elevation: 3,
                                child: ListTile(
                                  title: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        maintainList[index].maintainID,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: getStatusColor(
                                            maintainList[index].maintainStatus,
                                          ),
                                          borderRadius:
                                          BorderRadius.circular(50),
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
                                  subtitle: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 8),
                                      Divider(),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text('Người Tạo:',
                                              style: AppTheme.body1),
                                          Text(
                                            maintainList[index].creatorName,
                                            style: AppTheme.title,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text('Ngày Tạo: ',
                                              style: AppTheme.body1),
                                          Text(
                                            DateFormat('dd/MM/yyyy').format(
                                              maintainList[index]
                                                  .createDay
                                                  .toDate(),
                                            ) +
                                                " - " +
                                                DateFormat('HH:mm').format(
                                                  maintainList[index]
                                                      .createDay
                                                      .toDate(),
                                                ),
                                            style: const TextStyle(
                                                color: Colors.blue),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text('Ngày Kết Thúc: ',
                                              style: AppTheme.body1),
                                          (maintainList[index].finishDay !=
                                              null)
                                              ? Text(
                                            maintainList[index]
                                                .maintainStatus ==
                                                'Đang bảo trì'
                                                ? ''
                                                : "${DateFormat('dd/MM/yyyy').format(
                                              maintainList[index]
                                                  .finishDay!
                                                  .toDate(),
                                            )} - ${DateFormat('HH:mm').format(
                                              maintainList[index]
                                                  .finishDay!
                                                  .toDate(),
                                            )}" ??
                                                '',
                                            style: const TextStyle(
                                              color: Colors.blue,
                                            ),
                                          )
                                              : const Text(''),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
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