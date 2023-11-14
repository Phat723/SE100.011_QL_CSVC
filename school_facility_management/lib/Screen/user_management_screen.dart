import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:school_facility_management/Controllers/Auth_Controllers.dart';
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
  late final AuthController authController;

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
                    onTap: ()async{
                     var myUser= await AuthController.getUserDetail(items[index]["Id"]);
                      Get.to(const UserInfoScreen(),arguments:[myUser]);
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

                    trailing: PopupMenuButton<int>(

                      itemBuilder: (BuildContext context) =>[
                        const PopupMenuItem(value: 0, child: Text("Remove")
                        ),
                        const PopupMenuItem(value: 1, child: Text("Edit"))
                      ],
                      onSelected:(int value) {
                        switch(value){
                          case 0: //Remove
                            collection.doc(items[index]["id"]).delete();
                            Fluttertoast.showToast(msg: "Successfully deleted");
                            loadUsers();
                            break;
                          case 1:
                            break;
                        }
                      },
                    )

                ),
              );
            })
            : const Text("No data"),
      ),
      appBar: AppBar(
        title: const Text("School facility"),
        backgroundColor: Colors.green,
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
