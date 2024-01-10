import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:school_facility_management/Screen/borrow_slip_management_screen.dart';
import 'package:school_facility_management/Screen/create_borrow_slip_screen.dart';
import 'package:school_facility_management/Screen/create_maintain_slip_screen.dart';
import 'package:school_facility_management/Screen/create_report_screen.dart';
import 'package:school_facility_management/Screen/device_type_management_screen.dart';
import 'package:school_facility_management/Screen/in_out_management.dart';
import 'package:school_facility_management/Screen/report_management_screen.dart';
import 'package:school_facility_management/Screen/room_management_screen.dart';
import 'package:school_facility_management/Screen/statistical_screen.dart';
import 'package:school_facility_management/Screen/user_management_screen.dart';
import 'package:school_facility_management/Screen/violate_management_screen.dart';
import 'package:school_facility_management/Screen_user/feedback.dart';
import 'package:school_facility_management/Screen_user/feedback_management.dart';
import 'package:school_facility_management/Screen_user/user_home_screen.dart';
import '../CustomDrawer/drawer_user_controller.dart';
import '../CustomDrawer/home_drawer.dart';
import '../Model/AppTheme.dart';
import '../UserModel/user_model.dart';
import 'home_screen.dart';
import 'maintain_slip_management_screen.dart';
class NavigatorHomeScreen extends StatefulWidget {
  const NavigatorHomeScreen({super.key});
  @override
  State<NavigatorHomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<NavigatorHomeScreen> {
  Widget? screenView;
  DrawerIndex? drawerIndex;
  String role = '';
  @override
  void initState() {
    getInitValue();
    super.initState();
  }
  Future<void> getInitValue() async {
    await getCurrentUser();
    setState(() {
      drawerIndex = DrawerIndex.HOME;
      screenView =
      (role == 'Admin') ? const HomeScreen() : const UserHomeScreen();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.white,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          backgroundColor: AppTheme.nearlyWhite,
          body: DrawerUserController(
            screenIndex: drawerIndex,
            drawerWidth: MediaQuery
                .of(context)
                .size
                .width * 0.6,
            onDrawerCall: (DrawerIndex drawerIndexdata) {
              changeIndex(drawerIndexdata);
            },
            screenView: screenView,
            //we replace screen view as we need on navigate starting screens like MyHomePage, HelpScreen, FeedbackScreen, etc...
          ),
        ),
      ),
    );
  }
  Future<void> getCurrentUser() async {
    User? firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser != null) {
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
      await FirebaseFirestore.instance
          .collection("Client")
          .doc(firebaseUser.uid)
          .get();

      MyUser currentUser = MyUser.fromSnapShot(userSnapshot);
      role = currentUser.role;
    }
  }
  void changeIndex(DrawerIndex drawerIndexdata) {
    if (drawerIndex != drawerIndexdata) {
      drawerIndex = drawerIndexdata;
      switch (drawerIndex) {
        case DrawerIndex.HOME:
          setState(() {
            screenView = (role == 'Admin')?const HomeScreen():const UserHomeScreen();
          });
          break;
        case DrawerIndex.User:
          setState(() {
            screenView = const UserManagement();
          });
          break;
        case DrawerIndex.Device:
          setState(() {
            screenView = const DeviceTypeManagement();
          });
          break;
        case DrawerIndex.InOut:
          setState(() {
            screenView = const IoManagement();
          });
          break;
        case DrawerIndex.CreateReport:
          setState(() {
            screenView = const CreateReportScreen();
          });
          break;
        case DrawerIndex.Report:
          setState(() {
            screenView = const ReportManagementScreen();
          });
          break;
        case DrawerIndex.Borrow:
          setState(() {
            screenView = const CreateBorrowSlipScreen();
          });
          break;
        case DrawerIndex.BorrowManagement:
          setState(() {
            screenView = const BorrowSlipManagementScreen();
          });
          break;
        case DrawerIndex.Room:
          setState(() {
            screenView = const RoomManagementScreen();
          });
          break;
        case DrawerIndex.Broken:
          setState(() {
            screenView = const ViolateManagement();
          });
          break;
        case DrawerIndex.CreateMaintain:
          setState(() {
            screenView = const CreateMaintainSlip();
          });
          break;
        case DrawerIndex.Maintain:
          setState(() {
            screenView = const MaintainSlipManagementScreen();
          });
          break;
        case DrawerIndex.Statistical:
          setState(() {
            screenView = const LineChartSample2();
          });
          break;
        case DrawerIndex.Rating:
          setState(() {
            screenView = const FeedbackScreen();
          });
          break;
        case DrawerIndex.RatingManageMent:
          setState(() {
            screenView = const FeedbackManagementPage();
          });
          break;
        default:
          break;
      }
    }
  }
}
