import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_facility_management/Model/AppTheme.dart';
import 'package:school_facility_management/Model/theme.dart';
import 'package:school_facility_management/Screen/borrow_slip_info.dart';
import 'package:school_facility_management/Screen/create_borrow_slip_screen.dart';
import 'package:school_facility_management/UserModel/borrow_slip_model.dart';

class BorrowSlipManagementScreen extends StatefulWidget {
  const BorrowSlipManagementScreen({super.key});

  @override
  State<BorrowSlipManagementScreen> createState() =>
      _BorrowSlipManagementScreenState();
}

class _BorrowSlipManagementScreenState
    extends State<BorrowSlipManagementScreen> {
  var dataBorrowSlip = FirebaseFirestore.instance.collection("BorrowSlip");
  List<BorrowSlip> borrowList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text(
          'Quản lý phiếu mượn trả',
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
                            builder: (_) => const CreateBorrowSlipScreen()),
                      );
          }, icon: const Icon(Icons.add_box_rounded),)
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: StreamBuilder<QuerySnapshot>(
              stream: dataBorrowSlip.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text("Đã xảy ra lỗi");
                }
                if (snapshot.hasData) {
                  borrowList.clear();
                  for (var data in snapshot.data!.docs) {
                    borrowList.add(BorrowSlip.fromSnapshot(data));
                  }
                }
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: borrowList.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Get.to(BorrowSlipInfo(receivedBorrowSlip: borrowList[index]));
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 5, top: 5, left: 3, right: 3),
                              padding: const EdgeInsets.all(8.0),
                              width: context.width,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.black45, width: 0.5),
                                  borderRadius: BorderRadius.circular(20)),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          borrowList[index].borrowID,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.redAccent,
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          padding: const EdgeInsets.only(top: 5.0, bottom: 5.0, left: 7.0, right: 7.0),
                                          child: Text(
                                            borrowList[index].status,
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Divider(
                                      color: Colors.grey,
                                      thickness: 0.5,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text('Người Mượn:', style: TextStyle(fontSize: 15),),
                                              Text(borrowList[index].borrower, style: AppTheme.title,),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text("Người Tạo:",style: TextStyle(fontSize: 15),),
                                              SizedBox(width: 250, child: Text(borrowList[index].creatorEmail, style: AppTheme.title, overflow: TextOverflow.ellipsis,)),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text("Người Duyệt:", style: TextStyle(fontSize: 15),),
                                              Text(borrowList[index].returnProcessorEmail, style: AppTheme.title,),
                                            ],
                                          ),
                                          const Divider(
                                      color: Colors.grey,
                                      thickness: 0.5,
                                    ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  color: Colors.blue.shade50,
                                                  borderRadius: BorderRadius.circular(20),
                                                ),
                                                child: Text(
                                                    "Ngày mượn: ${borrowList[index].borrowDate}", style: const TextStyle(color: Colors.blue,  fontSize: 13),),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  color: Colors.blue.shade50,
                                                  borderRadius: BorderRadius.circular(20),
                                                ),
                                                child: Text(
                                                    "Ngày trả: ${borrowList[index].returnDate}", style: const TextStyle(color: Colors.blue, fontSize: 13),),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              }),
        ),
      ),
    );
  }
}
