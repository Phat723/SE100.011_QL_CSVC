import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:school_facility_management/Model/AppTheme.dart';
import 'package:school_facility_management/Model/theme.dart';

class ViolateManagement extends StatefulWidget {
  const ViolateManagement({super.key});

  @override
  State<ViolateManagement> createState() => _ViolateManagementState();
}

class _ViolateManagementState extends State<ViolateManagement> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          foregroundColor: Colors.white,
          title: const Text(
            'Danh Mục Vi Phạm',
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
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('ViolateType')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                List<Map<String, dynamic>> violateList = [];
                if(snapshot.hasData){
                  for(var data in snapshot.data!.docs){
                    violateList.add(data.data() as Map<String, dynamic>);
                  }
                }
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: violateList.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xffff4f4f),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.white),
                            onPressed: () {
                              // Show a confirmation dialog before deleting
                              showDeleteConfirmationDialog(context, violateList[index]);
                            },
                          ),
                          contentPadding: EdgeInsets.zero, // Remove default padding
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Loại vi phạm: ${violateList[index]['Violate Name']}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Số tiền phạt: ${violateList[index]["Violate Money"]}đ',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            // Show the edit dialog when ListTile is tapped
                            showEditDialog(context, violateList[index]);
                          },
                        ),
                      );
                    },
                  ),
                );
              },
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
              'Thêm danh mục vi phạm',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            onPressed: () {
              showAddDialog(context);
            },
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
    );
  }
  void showDeleteConfirmationDialog(BuildContext context, Map<String, dynamic> violateData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận xóa'),
          content: const Text('Bạn có muốn xóa không?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                // Call the function to delete the violation
                deleteViolation(violateData);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Xóa'),
            ),
          ],
        );
      },
    );
  }
  void deleteViolation(Map<String, dynamic> violateData) {
    FirebaseFirestore.instance
        .collection('ViolateType')
        .doc(violateData['ViolateId'])
        .delete()
        .whenComplete(() => Get.snackbar('Thông báo', 'Xóa dữ liệu thành công'));
  }
  void showAddDialog(BuildContext context) async {
    TextEditingController nameController = TextEditingController();
    TextEditingController moneyController = TextEditingController();
    Map<String, dynamic> violateData = {};
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Thêm danh mục'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Tên vi phạm'),
              ),
              const SizedBox(height: 20,),
              TextField(
                controller: moneyController,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
                decoration: const InputDecoration(labelText: 'Tiền phạt'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                violateData['ViolateId'] = generateRandomString();
                violateData['Violate Name'] = nameController.text;
                violateData['Violate Money'] = int.parse(moneyController.text);
                FirebaseFirestore.instance.collection('ViolateType').doc(violateData['ViolateId']).set(violateData).whenComplete(() => Get.snackbar('Thông báo', 'Thêm dữ liệu thành công'));
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Lưu'),
            ),
          ],
        );
      },
    );
  }
  void showEditDialog(BuildContext context, Map<String, dynamic> violateData) async {
    TextEditingController nameController = TextEditingController();
    TextEditingController moneyController = TextEditingController();

    nameController.text = violateData['Violate Name'];
    moneyController.text = violateData['Violate Money'].toString();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sửa thông tin'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Tên vi phạm'),
              ),
              const SizedBox(height: 20,),

              TextField(
                controller: moneyController,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
                decoration: const InputDecoration(labelText: 'Tiền phạt'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                violateData['Violate Name'] = nameController.text;
                violateData['Violate Money'] = int.parse(moneyController.text);
                FirebaseFirestore.instance.collection('ViolateType').doc(violateData['ViolateId']).update(violateData).whenComplete(() => Get.snackbar('Thông báo', 'Thay đổi dữ liệu thành công'));
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
  String generateRandomString() {
    final random = Random();
    String randomDigits = '';

    // Tạo 8 số ngẫu nhiên
    for (int i = 0; i < 8; i++) {
      randomDigits += random.nextInt(10).toString();
    }

    // Thêm tiền tố "BR_"
    String result = "V_$randomDigits";
    return result;
  }
}