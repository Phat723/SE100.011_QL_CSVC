import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:school_facility_management/Screen/home_screen.dart';
import 'package:school_facility_management/Screen/signup_screen.dart';
import 'package:school_facility_management/Screen/user_info_screen.dart';

class UserManagement extends StatefulWidget {
  const UserManagement({super.key});

  @override
  State<UserManagement> createState() => _UserManagementState();
}

class _UserManagementState extends State<UserManagement> {
  var collection = FirebaseFirestore.instance.collection("Client");
  late List<Map<String, dynamic>> items;
  bool isLoaded = false;

  @override
  void initState() {
    loadUsers();
    super.initState();
  }

  void loadUsers() async {
    List<Map<String, dynamic>> tempList = [];
    var data = await collection.get();
    data.docs.forEach((element) {
      tempList.add(element.data());
    });
    setState(() {
      items = tempList;
      items.sort((a, b) => a["Username"].compareTo(b["Username"]));
      isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isLoaded
            ? ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => UserInfoScreen(id: items[index]["id"])));
                      },
                      shape: RoundedRectangleBorder(
                          side: const BorderSide(width: 2),
                          borderRadius: BorderRadius.circular(20)),
                      leading: const CircleAvatar(
                        backgroundColor: Colors.green,
                        child: Icon(Icons.person),
                      ),
                      title: Row(
                        children: [
                          Text(items[index]["Username"] ?? "Not given"),
                          const SizedBox(width: 10),
                          Text(items[index]["Role"] ?? "Not given"),
                        ],
                      ),
                      subtitle: Text(items[index]["Email"]),
                      trailing: const Icon(Icons.more_vert),
                    ),
                  );
                })
            : const Text("No data"),
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
                  const Text("School Facility",
                      style: TextStyle(color: Colors.white, fontSize: 20)),
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
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_add_alt_1),
              title: const Text('User Management'),
              onTap: () {},
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () async{
          await Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpScreen()));
          loadUsers();
        },
        child: const Icon(Icons.person_add_alt_1),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
