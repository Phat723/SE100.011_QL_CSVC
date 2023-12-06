import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AreaManagement extends StatefulWidget {
  const AreaManagement({super.key});

  @override
  State<AreaManagement> createState() => _AreaManagementState();
}

class _AreaManagementState extends State<AreaManagement> {
  final areaDb = FirebaseFirestore.instance.collection("Area");
  @override
  Widget build(BuildContext context) {
    return Placeholder();
  }
}
