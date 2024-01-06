import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class CreateOutputSlipScreen extends StatefulWidget {
  const CreateOutputSlipScreen({super.key});

  @override
  State<CreateOutputSlipScreen> createState() => _CreateOutputSlipScreenState();
}

class _CreateOutputSlipScreenState extends State<CreateOutputSlipScreen> {
  CollectionReference deviceTypeStream =
      FirebaseFirestore.instance.collection('DevicesType');
  CollectionReference? deviceStream;
  String? deviceTypeSelected;
  String? deviceSelected;

  Stream<List<Map<String, dynamic>>> getDataFromFirebase(
      String deviceTypeId, String deviceId) {
    return FirebaseFirestore.instance
        .collection("DevicesType")
        .doc(deviceTypeId)
        .collection("Devices")
        .doc(deviceId)
        .collection("Device Detail")
        .snapshots()
        .map(
          (QuerySnapshot querySnapshot) => querySnapshot.docs
              .map((DocumentSnapshot documentSnapshot) =>
                  documentSnapshot.data() as Map<String, dynamic>)
              .toList(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: deviceTypeStream.snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (snapshot.hasData) {
                    List<DropdownMenuItem> deviceTypeItems = [];
                    for (var doc in snapshot.data!.docs) {
                      deviceTypeItems.add(
                        DropdownMenuItem(
                          value: doc.id,
                          child: Text(doc['DeviceType Name']),
                        ),
                      );
                    }
                    return Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.black12)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButton(
                          hint: DropdownMenuItem(
                            value: deviceTypeSelected,
                            child: const Text("Chose Device Type"),
                          ),
                          isExpanded: true,
                          value: deviceTypeSelected,
                          items: deviceTypeItems,
                          onChanged: (value) {
                            setState(() {
                              deviceTypeSelected = value!;
                              deviceSelected = null;
                              deviceStream = deviceTypeStream
                                  .doc(value)
                                  .collection("Devices");
                            });
                          },
                        ),
                      ),
                    );
                  }
                  return const Text("Not Found");
                },
              ),
              const SizedBox(
                height: 20,
              ),
              StreamBuilder<QuerySnapshot>(
                stream: deviceStream?.snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  List<DropdownMenuItem> deviceTypeItems = [];
                  if (snapshot.hasData) {
                    for (var doc in snapshot.data!.docs) {
                      deviceTypeItems.add(
                        DropdownMenuItem(
                          value: doc.id,
                          child: Text(doc['Device Name']),
                        ),
                      );
                    }
                  }
                  return Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.black12)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButton(
                        isExpanded: true,
                        hint: DropdownMenuItem(
                          value: deviceSelected,
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Devices"),
                          ),
                        ),
                        value: deviceSelected,
                        items: deviceTypeItems,
                        onChanged: (value) {
                          setState(() {
                            deviceSelected = value!;
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
              StreamBuilder<List<Map<String, dynamic>>>(
                stream: (deviceSelected != null && deviceTypeSelected != null)
                    ? getDataFromFirebase(deviceTypeSelected!, deviceSelected!)
                    : null,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData) {
                    return const Text('No data');
                  } else {
                    List<Map<String, dynamic>> dataTableData =
                        snapshot.data ?? [];
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text("Device Name")),
                          DataColumn(label: Text("Something")),
                          DataColumn(label: Text("")),
                        ],
                        rows: [

                        ],
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
