import 'package:flutter/material.dart';
import 'package:school_facility_management/Screen/borrow_slip_management_screen.dart';
import 'package:school_facility_management/Screen/create_borrow_slip_screen.dart';
import 'package:school_facility_management/Screen/create_report_screen.dart';
import 'package:school_facility_management/Screen/device_type_management_screen.dart';
import 'package:school_facility_management/Screen/in_out_management.dart';
import 'package:school_facility_management/Screen/report_management_screen.dart';
import 'package:school_facility_management/Screen/room_management_screen.dart';
import 'package:school_facility_management/Screen/user_management_screen.dart';
import '../CustomDrawer/drawer_user_controller.dart';
import '../CustomDrawer/home_drawer.dart';
import '../Model/AppTheme.dart';
import 'home_screen.dart';
class NavigatorHomeScreen extends StatefulWidget {
  const NavigatorHomeScreen({super.key});

  @override
  State<NavigatorHomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<NavigatorHomeScreen> {
  Widget? screenView;
  DrawerIndex? drawerIndex;

  @override
  void initState() {
    drawerIndex = DrawerIndex.HOME;
    screenView = const HomeScreen();
    super.initState();
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
            drawerWidth: MediaQuery.of(context).size.width * 0.6,
            onDrawerCall: (DrawerIndex drawerIndexdata) {
              changeIndex(drawerIndexdata);
              //callback from drawer for replace screen as user need with passing DrawerIndex(Enum index)
            },
            screenView: screenView,
            //we replace screen view as we need on navigate starting screens like MyHomePage, HelpScreen, FeedbackScreen, etc...
          ),
        ),
      ),
    );
  }

  void changeIndex(DrawerIndex drawerIndexdata) {
    if (drawerIndex != drawerIndexdata) {
      drawerIndex = drawerIndexdata;
      switch (drawerIndex) {
        case DrawerIndex.HOME:
          setState(() {
            screenView = const HomeScreen();
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
            screenView = const RoomManagementScreen();
          });
          break;
        default:
          break;
      }
    }
  }

}
