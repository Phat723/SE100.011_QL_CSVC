import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:school_facility_management/Controllers/Auth_Controllers.dart';
import 'package:school_facility_management/Model/theme.dart';
import 'package:school_facility_management/Screen/signup_screen.dart';
import 'package:school_facility_management/Screen/user_info_screen.dart';

class UserManagement extends StatefulWidget {
  const UserManagement({Key? key}) : super(key: key);

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
    for (var element in data.docs) {
      tempList.add(element.data());
    }
    setState(() {
      items = tempList;
      items.sort((a, b) => a["Username"].compareTo(b["Username"]));
      isLoaded = true;
    });
  }

  Future<void> showConfirmationDialog(int index) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // Ngăn người dùng đóng hộp thoại bằng cách nhấn bên ngoài
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Bạn có chắc chắn muốn xóa người dùng này?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Xóa'),
              onPressed: () {
                Navigator.of(context).pop();
                deleteUser(index);
              },
            ),
          ],
        );
      },
    );
  }


   void deleteUser(int index) async {
    String id = items[index]["Id"];
    await collection.doc(id).delete();
    await FirebaseAuth.instance.currentUser!.delete();
    Fluttertoast.showToast(msg: "Successfully deleted");
    loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text(
          'Quản Lý Người Dùng',
          style: TextStyle(fontSize: 20),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Themes.gradientDeepClr, Themes.gradientLightClr],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
      ),
      body: Center(
        child: isLoaded
            ? ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                     onTap: () async {
                      var myUser = await AuthController.getUserDetail(items[index]["Id"]);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserInfoScreen(userData: myUser),
                        ),
                      );
                    },

                      shape: RoundedRectangleBorder(
                        side: const BorderSide(width: 2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      leading: CircleAvatar(
                        backgroundColor: const Color.fromARGB(255, 52, 122, 233),
                        child: items[index]["imageURL"] != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child: Image.network(
                                  items[index]["imageURL"],
                                  fit: BoxFit.cover,
                                  width: 70,
                                  height: 70,
                                ),
                              )
                            : const Icon(Icons.person),
                        foregroundColor: Colors.white,
                      ),
                    
                     title: RichText(
          text: TextSpan(
            text: 'Họ tên: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 16, // Set the desired color
            ),
            children: <TextSpan>[
              TextSpan(
                text: items[index]["Username"] ?? "Not given",
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8,),

            RichText(
              text: TextSpan(
                text: 'Vai trò: ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black, fontSize: 16, // Set the desired color
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: items[index]["Role"] ?? "Not given",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,fontSize: 16, 
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8,),
            SizedBox(
              width: 260,
              child: RichText(
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                  text: 'Email: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,fontSize: 16,  // Set the desired color
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: items[index]["Email"] ?? "Not given",
                      style: TextStyle(
                        fontWeight: FontWeight.normal,fontSize: 16, 
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          showConfirmationDialog(index);
                        },
                      ),
                    ),
                  );
                },
              )
            : const Text("No data"),
      ),
      floatingActionButton: FloatingActionButton.extended(
            icon: const Icon(
              Icons.person_add,
              color: Colors.white,
            ),
            backgroundColor: Themes.gradientDeepClr,
            label: const Text(
              'Thêm người dùng',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            onPressed: () {
              Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => const SignUpScreen()),
                        );
                        loadUsers();
            },
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
    );
  }
}