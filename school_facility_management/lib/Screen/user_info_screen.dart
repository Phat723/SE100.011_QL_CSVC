import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:school_facility_management/Model/theme.dart';
import 'package:school_facility_management/Screen/user_management_screen.dart';
import 'package:school_facility_management/UserModel/user_model.dart';

class UserInfoScreen extends StatefulWidget {
  final MyUser? userData;
  const UserInfoScreen({Key? key, this.userData}) : super(key: key);
  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
   


  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController birthDayController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  String selectedRole = "Admin";
  String selectedGender = "Nam";
  File? _selectedImage;
  late DateTime selectedDate = DateTime.now();
  bool isVisible = false;
  String? _imageURL;

  // Validation flags
  bool _validateName = false;
  bool _validateEmail = false;
  bool _validatePhone = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    super.dispose();
  }
  @override
  void initState() {
  super.initState();
  _loadUserData();
}

void _loadUserData() async {
  try {
    if (widget.userData != null) {
      setState(() {
        usernameController.text = widget.userData!.username;
        emailController.text = widget.userData!.email;
        phoneController.text = widget.userData!.phoneNum;
        birthDayController.text = widget.userData!.birthDay;
        selectedRole = widget.userData!.role;
        selectedGender = widget.userData!.gender;
        passwordController.text=widget.userData!.password;
        confirmPasswordController.text=widget.userData!.password;
        String imageURL = widget.userData!.imageURL;
        _imageURL = imageURL;
      });
    }
  } catch (error) {
    print("Error loading user data: $error");
  }
}

  @override
  Widget build(BuildContext context) {
    emailController.selection = TextSelection.fromPosition(
        TextPosition(offset: emailController.text.length));
    passwordController.selection = TextSelection.fromPosition(
        TextPosition(offset: passwordController.text.length));
    usernameController.selection = TextSelection.fromPosition(
        TextPosition(offset: usernameController.text.length));
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text(
          'Cập Nhật Thông Tin',
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _pickImage();
                        },
                        child: Stack(
                          children: [
                            Container(
                              width: 120,
                              height: 120,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color.fromARGB(255, 52, 122, 233)
                              ),
                              child: _selectedImage != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(60),
                                      child: Image.file(_selectedImage!,
                                          fit: BoxFit.cover),
                                    )
                                  : _imageURL != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(60),
                                  child: Image.network(
                                    _imageURL!,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : const SizedBox.shrink(),
                            ),
                            const Positioned(
                              bottom: 0,
                              right: 0,
                              child: CircleAvatar(
                                backgroundColor:
                                    Color.fromARGB(255, 10, 79, 144),
                                child: Icon(Icons.camera_alt,
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: usernameController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Nhập tên người dùng";
                      } else if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
                        return "Tên không hợp lệ";
                      }
                      return null;
                    },
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      hintText: "Tên người dùng",
                      prefixIcon: const Icon(
                          Icons.account_circle, color: Colors.grey),
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        color: Colors.grey.shade600,
                      ),
                      errorText: _validateName ? "Tên không hợp lệ" : null,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.black12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.black12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: emailController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Nhập email";
                      } else if (!RegExp(
                              r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                          .hasMatch(value)) {
                        return "Email không hợp lệ";
                      }
                      return null;
                    },
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      hintText: "Email",
                      prefixIcon:
                          const Icon(Icons.email, color: Colors.grey),
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        color: Colors.grey.shade600,
                      ),
                      errorText: _validateEmail ? "Email không hợp lệ" : null,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.black12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.black12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: phoneController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Nhập số điện thoại";
                      } else if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                        return "Số điện thoại không hợp lệ";
                      }
                      return null;
                    },
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      hintText: "Số điện thoại",
                      prefixIcon:
                          const Icon(Icons.phone, color: Colors.grey),
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        color: Colors.grey.shade600,
                      ),
                      errorText: _validatePhone
                          ? "Số điện thoại không hợp lệ"
                          : null,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.black12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.black12),
                      ),
                    ),
                  ),
                  // const SizedBox(height: 20),
                  // TextFormField(
                  //   controller: passwordController,
                  //   validator: (value) {
                  //     if (value!.isEmpty) {
                  //       return "Nhập mật khẩu";
                  //     }
                  //     return null;
                  //   },
                  //   obscureText: !isVisible,
                  //   style: const TextStyle(
                  //     fontSize: 18,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  //   decoration: InputDecoration(
                  //     hintText: "Mật khẩu",
                  //     suffixIcon: IconButton(
                  //         onPressed: () {
                  //           setState(() {
                  //             isVisible = !isVisible;
                  //           });
                  //         },
                  //         icon: Icon(isVisible
                  //             ? Icons.visibility
                  //             : Icons.visibility_off)),
                  //     prefixIcon: const Icon(
                  //       Icons.lock,
                  //       color: Colors.grey,
                  //     ),
                  //     hintStyle: TextStyle(
                  //       fontWeight: FontWeight.w500,
                  //       fontSize: 15,
                  //       color: Colors.grey.shade600,
                  //     ),
                  //     enabledBorder: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(10),
                  //       borderSide: const BorderSide(color: Colors.black12),
                  //     ),
                  //     focusedBorder: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(10),
                  //       borderSide: const BorderSide(color: Colors.black12),
                  //     ),
                  //   ),
                  // ),
                  // const SizedBox(height: 20),
                  // TextFormField(
                  //   controller: confirmPasswordController,
                  //   validator: (value) {
                  //     if (value!.isEmpty) {
                  //       return "Nhập mật khẩu";
                  //     } else if (passwordController.text !=
                  //         confirmPasswordController.text) {
                  //       return "Mật khẩu không đúng";
                  //     }
                  //     return null;
                  //   },
                  //   obscureText: !isVisible,
                  //   style: const TextStyle(
                  //     fontSize: 18,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  //   decoration: InputDecoration(
                  //     hintText: "Xác nhận mật khẩu",
                  //     suffixIcon: IconButton(
                  //         onPressed: () {
                  //           //In here we will create a click to show and hide the password a toggle button
                  //           setState(() {
                  //             //toggle button
                  //             isVisible = !isVisible;
                  //           });
                  //         },
                  //         icon: Icon(isVisible
                  //             ? Icons.visibility
                  //             : Icons.visibility_off)),
                  //     prefixIcon: const Icon(
                  //       Icons.lock,
                  //       color: Colors.grey,
                  //     ),
                  //     hintStyle: TextStyle(
                  //       fontWeight: FontWeight.w500,
                  //       fontSize: 15,
                  //       color: Colors.grey.shade600,
                  //     ),
                  //     enabledBorder: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(10),
                  //       borderSide: const BorderSide(color: Colors.black12),
                  //     ),
                  //     focusedBorder: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(10),
                  //       borderSide: const BorderSide(color: Colors.black12),
                  //     ),
                  //   ),
                  // ),
                  
                  const SizedBox(height: 20),
                  SizedBox(
                    width: context.width,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Container(
                        //   height: 55,
                        //   width: 100,
                        //   padding: const EdgeInsets.symmetric(
                        //       horizontal: 5, vertical: 5),
                        //   decoration: BoxDecoration(
                        //     color: Colors.white,
                        //     borderRadius:
                        //         BorderRadiusDirectional.circular(10),
                        //     border: Border.all(color: Colors.black12),
                        //   ),
                        //   child: DropdownButton<String>(
                        //     hint: Text(selectedRole),
                        //     isExpanded: true,
                        //     items: const [
                        //       DropdownMenuItem(
                        //         value: "Admin",
                        //         child: Text("Admin"),
                        //       ),
                        //       DropdownMenuItem(
                        //         value: "User",
                        //         child: Text("User"),
                        //       )
                        //     ],
                        //     onChanged: (String? value) {
                        //       setState(() {
                        //         selectedRole = value!;
                        //       });
                        //     },
                        //   ),
                        // ),
                        SizedBox(
                          height: 55,
                          width: 170,
                          child: TextFormField(
                            //style: TextStyle(fontSize: 10),
                            controller: birthDayController,
                            readOnly: true,
                            onTap: () {
                              showDatePicker(
                                context: context,
                                initialDate: selectedDate = DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime(2100),
                              ).then((pickedDate) {
                                if (pickedDate != null) {
                                  setState(() {
                                    selectedDate = pickedDate;
                                    birthDayController.text =
                                        DateFormat('dd/MM/yyyy')
                                            .format(selectedDate);
                                  });
                                }
                              });
                            },
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(horizontal: 10),
                              labelText: 'Ngày sinh',
                              suffixIcon:
                                  const Icon(Icons.calendar_today),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Colors.black12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Colors.black12),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 55,
                          width: 100,
                           padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadiusDirectional.circular(10),
                            border: Border.all(color: Colors.black12),
                          ),
                          child: DropdownButton<String>(
                            hint: Text(selectedGender),
                            isExpanded: true,
                            items: const [
                              DropdownMenuItem(
                                value: "Nam",
                                child: Text("Nam"),
                              ),
                              DropdownMenuItem(
                                value: "Nữ",
                                child: Text("Nữ"),
                              )
                            ],
                            onChanged: (String? value) {
                              setState(() {
                                selectedGender = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                 SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        _updateUserInfo();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue, // Thay đổi màu nền của nút
                      ),
                      child: Text(
                        "Cập nhật",
                        style: TextStyle(
                          color: Colors.white, 
                          fontSize: 18, // Thay đổi kích thước chữ của nút
                          fontWeight: FontWeight.bold, // Thay đổi độ đậm của chữ
                        ),
                      ),
                    ),
                  )

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
    _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  
  Future<String> _uploadImage(String filePath) async {
  String fileName = DateTime.now().millisecondsSinceEpoch.toString();
  Reference storageReference =
      FirebaseStorage.instance.ref('user_images/$fileName');
  UploadTask uploadTask = storageReference.putFile(File(filePath));
  TaskSnapshot taskSnapshot = await uploadTask;
  String imageURL = await taskSnapshot.ref.getDownloadURL();
  return imageURL;
}


   void _updateUserInfo() async {
    // Reset validation flags
    setState(() {
      _validateName = false;
      _validateEmail = false;
      _validatePhone = false;
    });

    if (_formKey.currentState!.validate()) {
      if (_selectedImage == null) {
        Get.snackbar('School facility', 'Vui lòng chọn ảnh',
            snackPosition: SnackPosition.BOTTOM);
        return;
      }
      // Extract user information from form fields
      String username = usernameController.text;
      String email = emailController.text;
      String password = passwordController.text;
      String role = selectedRole;
      String birthDay = birthDayController.text;
      String gender = selectedGender;
      String phone = phoneController.text;

      try {
        // Update user information in Firestore
        final myDB =
            FirebaseFirestore.instance.collection("Client").doc(widget.userData!.id);

        String imageURL = "";
        if (_selectedImage != null) {
          imageURL = await _uploadImage(_selectedImage!.path);
        }

        MyUser updatedUser = MyUser(
          id: widget.userData!.id,
          username: username,
          password: password,
          birthDay: birthDay,
          gender: gender,
          phoneNum: phone,
          email: email,
          role: role,
          imageURL: imageURL,
        );

        await myDB.set(updatedUser.toMap());
        Get.snackbar('School facility', 'Cập nhật thành công');

         Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => UserManagement(),
        ),
      );
      } catch (error) {
        print("Error during user information update: $error");
        Get.snackbar('Error', '$error');
      }
    }
  }
}