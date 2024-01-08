import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_facility_management/Model/AppTheme.dart';

class ViolateManagement extends StatefulWidget {
  const ViolateManagement({super.key});

  @override
  State<ViolateManagement> createState() => _ViolateManagementState();
}

class _ViolateManagementState extends State<ViolateManagement> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Danh sách các danh mục phạm lỗi', style: AppTheme.title,),
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
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xffff4f4f),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: Colors.white),
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
                                SizedBox(height: 8),
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Call a function to show a dialog for adding new data
          showAddDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
  void showDeleteConfirmationDialog(BuildContext context, Map<String, dynamic> violateData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this violation?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Call the function to delete the violation
                deleteViolation(violateData);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Delete'),
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
          title: Text('Add Violation'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Violation Name'),
              ),
              TextField(
                controller: moneyController,
                decoration: InputDecoration(labelText: 'Violation Money'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                violateData['ViolateId'] = generateRandomString();
                violateData['Violate Name'] = nameController.text;
                violateData['Violate Money'] = int.parse(moneyController.text);
                FirebaseFirestore.instance.collection('ViolateType').doc(violateData['ViolateId']).set(violateData).whenComplete(() => Get.snackbar('Thông báo', 'Thêm dữ liệu thành công'));
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Save'),
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
          title: Text('Edit Violation'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Violation Name'),
              ),
              TextField(
                controller: moneyController,
                decoration: InputDecoration(labelText: 'Violation Money'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                violateData['ViolateId'] = generateRandomString();
                violateData['Violate Name'] = nameController.text;
                violateData['Violate Money'] = int.parse(moneyController.text);
                FirebaseFirestore.instance.collection('ViolateType').doc(violateData['ViolateId']).update(violateData).whenComplete(() => Get.snackbar('Thông báo', 'Thay đổi dữ liệu thành công'));
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Save'),
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
