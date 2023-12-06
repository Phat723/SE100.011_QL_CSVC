import 'package:flutter/material.dart';
import 'package:school_facility_management/Screen/device_management_screen.dart';
import 'package:school_facility_management/Screen/device_type_management_screen.dart';
import 'package:school_facility_management/Screen/in_out_management.dart';
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
        case DrawerIndex.Help:
          setState(() {
            screenView = const UserManagement();
          });
          break;
        case DrawerIndex.FeedBack:
          setState(() {
            screenView = const DeviceTypeManagement();
          });
          break;
        case DrawerIndex.Invite:
          setState(() {
            screenView = const IoManagement();
          });
          break;
        default:
          break;
      }
    }
  }

}
