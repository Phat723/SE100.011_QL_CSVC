import 'package:flutter/material.dart';
import 'package:school_facility_management/Screen/signup_screen.dart';
import 'package:school_facility_management/Screen/user_info_screen.dart';
import 'package:school_facility_management/Screen/user_management_screen.dart';
import 'package:school_facility_management/my_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const SingleChildScrollView(child: Column(
        ),
      ),
      appBar: AppBar(
        title: const Text("School facility"),
        backgroundColor: Colors.green,
      ),
      drawer: Drawer(
        width: 250,
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.green,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("School Facility", style: TextStyle(color: Colors.white,fontSize: 20)),
                  SizedBox(
                    child: Image.asset("assets/img.png"),
                  )
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.manage_accounts),
              title: const Text('User Management'),
              onTap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const UserManagement()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
