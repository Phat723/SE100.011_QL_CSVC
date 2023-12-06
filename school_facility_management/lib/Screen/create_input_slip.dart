import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CreateInputSlipScreen extends StatefulWidget {
  const CreateInputSlipScreen({super.key});

  @override
  State<CreateInputSlipScreen> createState() => _CreateInputSlipScreenState();
}

class _CreateInputSlipScreenState extends State<CreateInputSlipScreen> {
  String deviceTypeSelected = '';
  String deviceSelected = '';
  final stream = FirebaseFirestore.instance
      .collection('DevicesType');


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: stream.snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return SizedBox();
                  }
                  List<DropdownMenuItem> deviceTypeItems = [];
                  for (var doc in snapshot.data!.docs) {
                    deviceTypeItems.add(
                      DropdownMenuItem(
                        value: doc.id,
                        child: Text(doc['DeviceType Name']),
                      ),
                    );
                  }
                  return DropdownButton(
                    isExpanded: true,
                    value: deviceTypeSelected == ''?snapshot.data!.docs.first.id:deviceTypeSelected,
                    items: deviceTypeItems,
                    onChanged: (value) {
                      setState(() {
                        deviceTypeSelected = value!;
                        deviceSelected = '';
                      });
                    },
                  );
                },
              ),
              StreamBuilder<QuerySnapshot>(
                stream: deviceTypeSelected != ''?stream.doc(deviceTypeSelected).collection("Devices").snapshots():null,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return SizedBox();
                  }
                  if(snapshot.hasData){
                    List<DropdownMenuItem> deviceTypeItems = [];
                    for (var doc in snapshot.data!.docs) {
                      deviceTypeItems.add(
                        DropdownMenuItem(
                          value: doc.id,
                          child: Text(doc['Device Name']),
                        ),
                      );
                    }
                    return DropdownButton(
                      isExpanded: true,
                      value: deviceSelected == ''?snapshot.data!.docs.first.id:deviceSelected,
                      items: deviceTypeItems,
                      onChanged: (value) {
                        setState(() {
                          deviceSelected = value!;
                        });
                      },
                    );
                  }
                  return const SizedBox();
                },
              ),
              TextField(
                decoration: InputDecoration(hintText: deviceSelected ?? ''),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
