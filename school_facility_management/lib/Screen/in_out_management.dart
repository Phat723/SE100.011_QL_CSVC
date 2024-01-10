import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_facility_management/Model/theme.dart';
import 'package:school_facility_management/Screen/create_input_slip.dart';
import 'package:school_facility_management/UserModel/in_out_log_model.dart';

class IoManagement extends StatefulWidget {
  const IoManagement({Key? key}) : super(key: key);

  @override
  State<IoManagement> createState() => _IoManagementState();
}

class _IoManagementState extends State<IoManagement> {
  final ioLogDb = FirebaseFirestore.instance.collection("InOutLog");
  List<InOutLog> listIo = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text(
          'Quản lý nhập xuất',
          style: TextStyle(fontSize: 20),
        ),
        elevation: 0,
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
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: ioLogDb.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text("Something went wrong");
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                listIo.clear(); // Clear the list before updating it
                for (var data in snapshot.data!.docs) {
                  listIo.add(InOutLog.fromSnapshot(data));
                }
                listIo.sort((a, b) => b.createDay.compareTo(a.createDay));
                return ListView.separated(
                  separatorBuilder: (context, index) => const SizedBox(height: 10),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: listIo.length,
                  itemBuilder: (context, index) => Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(14.0),
                      title: Text(
                        "Phiếu nhập xuất",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Text('Mã phiếu:'),
                              Text(
                                  '${listIo[index].inOutId.toUpperCase()}',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              // Text(listIo[index].createCase),
                              Row(
                                children: [
                                  Icon(
                                    (listIo[index].createType == 'Input Slip')
                                        ? Icons.arrow_downward // Use the check icon for Input Slip
                                        : Icons.arrow_upward,
                                    color: (listIo[index].createType == 'Input Slip')
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    (listIo[index].createType == 'Input Slip')
                                        ? 'Phiếu Nhập'
                                        : 'Phiếu Xuất',
                                    style: TextStyle(
                                      color: (listIo[index].createType == 'Input Slip')
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 250,
                            child: Text(
                              'Người tạo: ${listIo[index].creatorName}' ?? '',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text('Ngày tạo: ${listIo[index].createDay}'),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 100),
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
          'Thêm phiếu nhập',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        onPressed: () {
          Get.to(const CreateInputSlipScreen());
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
