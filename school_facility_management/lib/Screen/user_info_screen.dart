import 'package:flutter/material.dart';

class UserInfoScreen extends StatefulWidget {
  final String? id;
  const UserInfoScreen({super.key, this.id});
  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  String receivedData = "";
  @override
  void initState() {
    receivedData = widget.id!;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text(receivedData)),
    );
  }
}

