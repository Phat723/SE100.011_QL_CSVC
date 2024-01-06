import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_facility_management/Model/AppTheme.dart';
import 'package:school_facility_management/Screen/create_input_slip.dart';
import 'package:school_facility_management/Screen/create_output_slip.dart';
import 'package:school_facility_management/UserModel/in_out_log_model.dart';

class IoManagement extends StatefulWidget {
  const IoManagement({super.key});

  @override
  State<IoManagement> createState() => _IoManagementState();
}

class _IoManagementState extends State<IoManagement> {
  final ioLogDb = FirebaseFirestore.instance.collection("InOutLog");
  List<InOutLog> listIo = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.to(const CreateOutputSlipScreen());
                    },
                    child: const Text('-'),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.to(const CreateInputSlipScreen());
                    },
                    child: const Text('+'),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Center(
                child: StreamBuilder<QuerySnapshot>(
                  stream: ioLogDb.snapshots(),
                  builder: (context, snapshot) {
                    if(snapshot.hasError){
                      return const Text("Something worng happen");
                    }
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return const CircularProgressIndicator();
                    }
                    for(var data in snapshot.data!.docs){
                      listIo.add(InOutLog.fromSnapshot(data));
                    }
                    return ListView.separated(
                      separatorBuilder: (context, index) => const SizedBox(height: 10),
                      shrinkWrap: true,
                      itemCount: listIo.length,
                      itemBuilder: (context, index) => Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Phiếu nhập xuất", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                              const Divider(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(listIo[index].createCase,),
                                  Text(listIo[index].createType, style: TextStyle(color: (listIo[index].createType == 'Input Slip')?Colors.green:Colors.red),),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Người tạo: ${listIo[index].creatorName}'??''),
                                  Text('Ngày tạo: ${listIo[index].createDay}'),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(),
    );
  }
}
