
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:school_facility_management/Controllers/User_Profile_Controllers.dart';
import 'package:school_facility_management/UserModel/user_model.dart';
import '../generated/assets.dart';

class UserInfoScreen extends StatelessWidget {
  const UserInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MyUser user = Get.arguments[0];
    UserProfileController userProfileController =
        Get.put(UserProfileController());
    userProfileController.updateValue(user);
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(tDefaultSize),
          child: Column(
            children: [
              // const FormHeaderWidget(
              //     image: 'assets/UserDefaultAvatar.png',
              //     title: "",
              //     subtitle: ""),
              Container(
                padding: const EdgeInsets.symmetric(vertical: tFormHeight - 10),
                child: Form(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                        controller: userProfileController.fullNameController,
                        decoration: const InputDecoration(
                            label: Text(tFullName),
                            prefixIcon: (Icon(Icons.person_rounded)))),
                    const SizedBox(height: tFormHeight - 20),
                    TextFormField(
                        controller: userProfileController.emailController,
                        decoration: const InputDecoration(
                            label: Text(tEmail),
                            prefixIcon: (Icon(Icons.email)))),
                    const SizedBox(height: tFormHeight - 20),
                    TextFormField(
                        controller: userProfileController.phoneController,
                        decoration: const InputDecoration(
                            label: Text(tPhone),
                            prefixIcon: (Icon(Icons.phone)))),
                    const SizedBox(height: tFormHeight - 20),
                    TextFormField(
                        controller: userProfileController.passwordController,
                        decoration: const InputDecoration(
                            label: Text(tPass),
                            prefixIcon: (Icon(Icons.fingerprint)))),
                    const SizedBox(height: tFormHeight - 20),


                    SizedBox(
                      width: double.infinity,
                      // width: 100,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              side: BorderSide.none,
                              shape: const StadiumBorder()),
                          onPressed: () => Get.back(),
                          child: const Text(tConfirm)),
                    ),

                  ],

                )),
              ),
              // Row(
              //   children: [
              //     Container(
              //       height: 55,
              //       width: 100,
              //       padding:
              //       const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              //       decoration: BoxDecoration(
              //         color: Colors.white,
              //         borderRadius: BorderRadiusDirectional.circular(10),
              //         border: Border.all(color: Colors.black12),
              //       ),
              //       child: DropdownButton<String>(
              //         isExpanded: true,
              //         items: const [
              //           DropdownMenuItem(
              //             value: "Admin",
              //             child: Text("Admin"),
              //           ),
              //           DropdownMenuItem(
              //             value: "User",
              //             child: Text("User"),
              //           )
              //         ],
              //         onChanged: (String? value) {
              //             selectedRole = value!;
              //
              //         },
              //       ),
              //     ),
              //     const SizedBox(width: 20,),
              //     SizedBox(
              //       width: 150,
              //       child: TextFormField(
              //         //controller: birthDayController,
              //         readOnly: true,
              //         // onTap: () {
              //         //   showDatePicker(
              //         //     context: context,
              //         //     initialDate: selectedDate ?? DateTime.now(),
              //         //     firstDate: DateTime(1900),
              //         //     lastDate: DateTime(2100),
              //         //   ).then((pickedDate) {
              //         //     if (pickedDate != null) {
              //         //       setState(() {
              //         //         selectedDate = pickedDate;
              //         //         birthDayController.text =
              //         //             DateFormat('dd/MM/yyyy').format(selectedDate!);
              //         //       });
              //         //     }
              //         //   });
              //         // },
              //         decoration: InputDecoration(
              //           labelText: 'Birthday',
              //           suffixIcon: const Icon(Icons.calendar_today),
              //           enabledBorder: OutlineInputBorder(
              //             borderRadius: BorderRadius.circular(10),
              //             borderSide: const BorderSide(color: Colors.black12),
              //           ),
              //           focusedBorder: OutlineInputBorder(
              //             borderRadius: BorderRadius.circular(10),
              //             borderSide: const BorderSide(color: Colors.black12),
              //           ),
              //         ),
              //
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    ));
  }
}
