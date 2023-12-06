import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_facility_management/Model/AppTheme.dart';
import 'package:school_facility_management/Screen/area_manament_screen.dart';
import 'package:school_facility_management/Screen/create_input_slip.dart';

class IoManagement extends StatefulWidget {
  const IoManagement({super.key});

  @override
  State<IoManagement> createState() => _IoManagementState();
}

class _IoManagementState extends State<IoManagement> {
  final db = FirebaseFirestore.instance.collection("InOutLog");
  late List<Map<String, dynamic>> ioItems;
  bool isLoad = false;

  void loadIoLog() async {
    List<Map<String, dynamic>> tempList = [];
    var data = await db.get();
    for (var element in data.docs) {
      tempList.add(element.data());
    }
    setState(() {
      isLoad = true;
      ioItems = tempList;
    });
  }

  @override
  void initState() {
    super.initState();
    loadIoLog();
  }
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
                    onPressed: () {},
                    child: Text('-'),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.to(const CreateInputSlipScreen());
                    },
                    child: Text('+'),
                  ),
                ),
              ],
            ),
            Expanded(
              child: isLoad
                  ? ListView.builder(
                  itemCount: ioItems.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppTheme.nearlyBlack,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          shape: const RoundedRectangleBorder(
                            side: BorderSide(color: Colors.black12),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          onTap: () {
              
                          },
                          title: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(ioItems[index]["Type"] ?? "Not given",
                                    style: const TextStyle(color: AppTheme.white,fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  })
                  : const CircularProgressIndicator(),
            ),
          ],
        ),
      ),
      appBar: AppBar(),
    );
  }
}
