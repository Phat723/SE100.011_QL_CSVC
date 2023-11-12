import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_facility_management/Screen/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:school_facility_management/Screen/navigator_home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Firebase/firebase_options.dart';
import '../Model/AppTheme.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
 // runApp(const MyApp());
  Get.testMode= true;
  runApp ( GetMaterialApp(
      theme: AppTheme.lightTheme,
      home: const LoginScreen()));
  _init();
}

_init() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final token = prefs.getString("userID");
  if (token != null) {
    print('Token: $token');
    Get.offAll(const NavigatorHomeScreen());

  }
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,

      home:LoginScreen(),
      title: "School Facility App",
    );
  }
}
