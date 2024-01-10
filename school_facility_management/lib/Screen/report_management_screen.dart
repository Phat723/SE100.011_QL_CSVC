

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_facility_management/Controllers/Report_Controller.dart';
import 'package:school_facility_management/Model/theme.dart';
import 'package:school_facility_management/Screen/report_info_screen.dart';
import 'package:school_facility_management/UserModel/report_model.dart';

class ReportManagementScreen extends StatefulWidget {
  const ReportManagementScreen({Key? key}) : super(key: key);

  @override
  State<ReportManagementScreen> createState() => _ReportManagementScreenState();
}

class _ReportManagementScreenState extends State<ReportManagementScreen> {
  final CollectionReference reportRef =
      FirebaseFirestore.instance.collection("Report");
  ReportController reportController = Get.put(ReportController());
  List<String> statusList = ["Chờ duyệt", "Đang xử lý", "Đã xử lý", "Đóng"];
  String selectedList = '';
  Stream? reportStream;

  @override
  void initState() {
    super.initState();
    reportStream = reportRef.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: reportStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("Something wrong happened");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          List<Report> reportList = [];
          for (var data in snapshot.data!.docs) {
            Report report = Report.fromSnapshot(data);
            reportList.add(report);
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: reportList.length,
              itemBuilder: (context, index) => InkWell(
                onTap: () {
                  Get.to(ReportInfoScreen(
                    selectedReport: reportList[index],
                  ));
                },
                child: Container(
                  height: 140,
                  margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(14.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ID: ${reportList[index].reportId}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            reportList[index].creator,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            'Date: ${reportList[index].creationDate.year}/${reportList[index].creationDate.month}/${reportList[index].creationDate.day}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color:
                                  getColorFromCode(reportList[index].status),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                              children: [
                                const Icon(
                                  Icons.circle,
                                  color: Colors.white,
                                  size: 13,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  reportList[index].status,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 80,
                            width: 80,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.network(
                                reportList[index].imageList.first,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(height: 5),
            ),
          );
        },
      ),
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text(
          "Quản Lý Báo Hỏng",
          style: TextStyle(
            fontSize: 20,
          ),
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          
            child: 
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.blueGrey.withOpacity(0.8),
                      width: 0.3,
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: statusList
                          .map((status) => Padding(
                                padding: const EdgeInsets.only(
                                    left: 4.0, right: 4.0),
                                child: FilterChip(
                                  label: Text(
                                    status,
                                    style: TextStyle(
                                      color: selectedList == status
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: selectedList == status
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                  selected: selectedList == status,
                                  selectedColor:
                                      getColorFromCode(status),
                                  checkmarkColor: Colors.white,
                                  onSelected: (isSelected) {
                                    updateFilters(status, isSelected);
                                  },
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                ),
              ),
            
          ),
        ),
      );
    
  }

  void updateFilters(String status, bool isSelected) {
    setState(() {
      if (isSelected) {
        selectedList = status;
        reportStream = reportRef
            .where("Status", isEqualTo: selectedList)
            .snapshots();
      } else {
        selectedList = '';
        reportStream = reportRef.snapshots();
      }
    });
  }

  Color getColorFromCode(String status) {
    switch (status.toLowerCase()) {
      case 'đang xử lý':
        return const Color.fromARGB(255, 196, 176, 3);
      case 'đã xử lý':
        return Colors.green;
      case 'đóng':
        return const Color.fromARGB(255, 106, 181, 243);
      case 'chờ duyệt':
        return const Color.fromARGB(255, 236, 77, 77);
      default:
        return Colors.black; // Màu mặc định khi không tìm thấy một màu nào khớp
    }
  }
}
