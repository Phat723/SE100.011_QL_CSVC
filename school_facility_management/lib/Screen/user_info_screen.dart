import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../generated/assets.dart';

class UserInfoScreen extends StatelessWidget {
  const UserInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(tDefaultSize),
          child:  Column(
            children: [
              // const FormHeaderWidget(
              //     image: 'assets/UserDefaultAvatar.png',
              //     title: "",
              //     subtitle: ""),
              Container(
                padding: const EdgeInsets.symmetric(vertical: tFormHeight-10),
                child: Form(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                      TextFormField(
                        decoration: const InputDecoration(
                              label: Text (tFullName),
                              prefixIcon: (Icon(Icons.person_rounded))
                        )
                      ),
                    const SizedBox(height: tFormHeight -20),
                    TextFormField(
                        decoration: const InputDecoration(
                            label: Text (tEmail),
                            prefixIcon: (Icon(Icons.email))
                        )
                    ),
                    const SizedBox(height: tFormHeight -20),
                    TextFormField(
                        decoration: const InputDecoration(
                            label: Text (tPhone),
                            prefixIcon: (Icon(Icons.phone))
                        )
                    ),
                    const SizedBox(height: tFormHeight -20),
                    TextFormField(
                        decoration: const InputDecoration(
                            label: Text (tPass),
                            prefixIcon: (Icon(Icons.fingerprint))
                        )
                    ),
                    SizedBox(
                      width: double.infinity,
                     // width: 100,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom( backgroundColor: Colors.black, side: BorderSide.none,shape: const StadiumBorder()),
                          onPressed:() =>      Get.back(), child: const Text(tConfirm)
                      ),

                    ),
                  ],

                )),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
