import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controllers/Auth_Controllers.dart';
import '../Model/AppTheme.dart';
import '../Screen/login_screen.dart';
import '../UserModel/user_model.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({Key? key,
    this.screenIndex,
    this.iconAnimationController,
    this.callBackIndex})
      : super(key: key);

  final AnimationController? iconAnimationController;
  final DrawerIndex? screenIndex;
  final Function(DrawerIndex)? callBackIndex;

  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  List<DrawerList> drawerList = [];
  String role = '';

  @override
  void initState() {
    setDrawerListArray();
    super.initState();
  }

  void setDrawerListArray() async{
    await getCurrentUser();
    if (role == 'Admin') {
      drawerList = <DrawerList>[
        DrawerList(
          index: DrawerIndex.HOME,
          labelName: 'Trang chủ',
          icon: const Icon(Icons.home),
        ),
        DrawerList(
          index: DrawerIndex.User,
          labelName: 'Quản lý người dùng',
          icon: const Icon(Icons.account_circle),
        ),
        DrawerList(
          index: DrawerIndex.Device,
          labelName: 'Quản lý thiết bị',
          icon: const Icon(Icons.devices),
        ),
        DrawerList(
          index: DrawerIndex.InOut,
          labelName: 'Quản lý nhập xuất',
          icon: const Icon(Icons.input),
        ),
        DrawerList(
          index: DrawerIndex.Report,
          labelName: 'Quản lý báo hỏng',
          icon: const Icon(Icons.report),
        ),
        DrawerList(
          index: DrawerIndex.BorrowManagement,
          labelName: 'Quản lý mượn trả',
          icon: const Icon(Icons.handshake),
        ),
        DrawerList(
          index: DrawerIndex.Broken,
          labelName: 'Danh mục vi phạm',
          icon: const Icon(Icons.error_outline),
        ),
        DrawerList(
          index: DrawerIndex.Room,
          labelName: 'Quản lý phòng',
          icon: const Icon(Icons.room),
        ),
        DrawerList(
          index: DrawerIndex.Maintain,
          labelName: 'Bảo Trì',
          icon: const Icon(Icons.handyman_rounded),
        ),
        DrawerList(
          index: DrawerIndex.RatingManageMent,
          labelName: 'Quản lý đánh giá',
          icon: const Icon(Icons.star),
        ),
        DrawerList(
          index: DrawerIndex.Statistical,
          labelName: 'Thông kê',
          icon: const Icon(Icons.bar_chart),
        ),
      ];
    } else {
      drawerList = <DrawerList>[
        DrawerList(
          index: DrawerIndex.CreateReport,
          labelName: 'Báo hỏng',
          icon: const Icon(Icons.warning),
        ),
        DrawerList(
          index: DrawerIndex.Rating,
          labelName: 'Đánh giá',
          icon: const Icon(Icons.edit_note_sharp),
        ),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthController authController = AuthController();
    var brightness = MediaQuery
        .of(context)
        .platformBrightness;
    bool isLightMode = brightness == Brightness.light;
    return Scaffold(
      backgroundColor: AppTheme.notWhite.withOpacity(0.5),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 40.0),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  AnimatedBuilder(
                    animation: widget.iconAnimationController!,
                    builder: (BuildContext context, Widget? child) {
                      return ScaleTransition(
                        scale: AlwaysStoppedAnimation<double>(1.0 -
                            (widget.iconAnimationController!.value) * 0.2),
                        child: RotationTransition(
                          turns: AlwaysStoppedAnimation<double>(Tween<double>(
                              begin: 0.0, end: 24.0)
                              .animate(CurvedAnimation(
                              parent: widget.iconAnimationController!,
                              curve: Curves.fastOutSlowIn))
                              .value /
                              360),
                          child: Container(
                            height: 120,
                            width: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: AppTheme.grey.withOpacity(0.6),
                                    offset: const Offset(2.0, 4.0),
                                    blurRadius: 8),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius:
                              const BorderRadius.all(Radius.circular(60.0)),
                              child: Image.asset(
                                  'assets/UserDefaultAvatar.png'),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 4),
                    child: Text(
                      authController.emailController.text,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: isLightMode ? AppTheme.grey : AppTheme.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          Divider(
            height: 1,
            color: AppTheme.grey.withOpacity(0.6),
          ),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(0.0),
              itemCount: drawerList?.length,
              itemBuilder: (BuildContext context, int index) {
                return inkwell(drawerList![index]);
              },
            ),
          ),
          Divider(
            height: 1,
            color: AppTheme.grey.withOpacity(0.6),
          ),
          Column(
            children: <Widget>[
              ListTile(
                title: const Text(
                  'Đăng xuất',
                  style: TextStyle(
                    fontFamily: AppTheme.fontName,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: AppTheme.darkText,
                  ),
                  textAlign: TextAlign.left,
                ),
                onTap: () {
                  AuthController.logoutUser();
                  Get.offAll(const LoginScreen());
                },
              ),
              SizedBox(
                height: MediaQuery
                    .of(context)
                    .padding
                    .bottom,
              )
            ],
          ),
        ],
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

  Widget inkwell(DrawerList listData) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.grey.withOpacity(0.1),
        highlightColor: Colors.transparent,
        onTap: () {
          navigationToScreen(listData.index!);
        },
        child: Stack(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Row(
                children: <Widget>[
                  const SizedBox(
                    width: 6.0,
                    height: 46.0,
                    // decoration: BoxDecoration(
                    //   color: widget.screenIndex == listData.index
                    //       ? Colors.blue
                    //       : Colors.transparent,
                    //   borderRadius: new BorderRadius.only(
                    //     topLeft: Radius.circular(0),
                    //     topRight: Radius.circular(16),
                    //     bottomLeft: Radius.circular(0),
                    //     bottomRight: Radius.circular(16),
                    //   ),
                    // ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                  ),
                  listData.isAssetsImage
                      ? SizedBox(
                    width: 24,
                    height: 24,
                    child: Image.asset(listData.imageName,
                        color: widget.screenIndex == listData.index
                            ? Colors.blue
                            : AppTheme.nearlyBlack),
                  )
                      : Icon(listData.icon?.icon,
                      color: widget.screenIndex == listData.index
                          ? Colors.blue
                          : AppTheme.nearlyBlack),
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                  ),
                  Text(
                    listData.labelName,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: widget.screenIndex == listData.index
                          ? Colors.black
                          : AppTheme.nearlyBlack,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            widget.screenIndex == listData.index
                ? AnimatedBuilder(
              animation: widget.iconAnimationController!,
              builder: (BuildContext context, Widget? child) {
                return Transform(
                  transform: Matrix4.translationValues(
                      (MediaQuery
                          .of(context)
                          .size
                          .width * 0.75 - 64) *
                          (1.0 -
                              widget.iconAnimationController!.value -
                              1.0),
                      0.0,
                      0.0),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: Container(
                      width:
                      MediaQuery
                          .of(context)
                          .size
                          .width * 0.75 - 64,
                      height: 46,
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.2),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(0),
                          topRight: Radius.circular(28),
                          bottomLeft: Radius.circular(0),
                          bottomRight: Radius.circular(28),
                        ),
                      ),
                    ),
                  ),
                );
              },
            )
                : const SizedBox()
          ],
        ),
      ),
    );
  }

  Future<void> navigationToScreen(DrawerIndex indexScreen) async {
    widget.callBackIndex!(indexScreen);
  }
}

enum DrawerIndex {
  HOME,
  User,
  Device,
  InOut,
  Report,
  CreateReport,
  Borrow,
  BorrowManagement,
  Broken,
  Room,
  CreateMaintain,
  Maintain,
  Rating,
  RatingManageMent,
  Statistical,
}

class DrawerList {
  DrawerList({
    this.isAssetsImage = false,
    this.labelName = '',
    this.icon,
    this.index,
    this.imageName = '',
  });

  String labelName;
  Icon? icon;
  bool isAssetsImage;
  String imageName;
  DrawerIndex? index;
}
