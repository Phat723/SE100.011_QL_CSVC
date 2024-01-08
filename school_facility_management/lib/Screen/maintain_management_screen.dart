import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:school_facility_management/UserModel/maintain_model.dart';

class MaintainManagement extends StatefulWidget {
  const MaintainManagement({super.key});

  @override
  State<MaintainManagement> createState() => _MaintainManagementState();
}

class _MaintainManagementState extends State<MaintainManagement> {
  List<MaintainTicket> maintainList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('Maintain').snapshots(),
                builder: (context, snapshot) {
                  if(snapshot.hasError){
                    return Text(snapshot.error.toString());
                  }
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return const CircularProgressIndicator();
                  }
                  if(snapshot.hasData){
                    for(var data in snapshot.data!.docs){
                      maintainList.add(MaintainTicket.fromSnapshot(data));
                    }
                  }
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: maintainList.length,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black12),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: ListTile(
                              title: Text(maintainList[index].maintainId),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                }
              ),
            ],
          ),
        ),
      ),
    );
  }
}
