import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:school_facility_management/Model/theme.dart';
import 'package:school_facility_management/Screen/borrow_slip_management_screen.dart';
import 'package:school_facility_management/Screen/device_type_management_screen.dart';
import 'package:school_facility_management/Screen/in_out_management.dart';
import 'package:school_facility_management/Screen/maintain_slip_management_screen.dart';
import 'package:school_facility_management/Screen/report_management_screen.dart';
import 'package:school_facility_management/Screen/room_management_screen.dart';
import 'package:school_facility_management/Screen/statistical_screen.dart';
import 'package:school_facility_management/Screen/user_management_screen.dart';
import 'package:school_facility_management/Screen/violate_management_screen.dart';
import 'package:school_facility_management/Screen_user/feedback_management.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Color> colors = [
    Colors.red,
    Colors.orange,
    Colors.yellow.shade600,
    Colors.green,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
    Colors.blueGrey,
    Colors.deepOrange,
    Colors.blueAccent
  ];

  List<IconData> iconList =
   [
    Icons.person,
    Icons.devices,
    Icons.input,
    Icons.report,
    Icons.handshake,
    Icons.error_outline,
    Icons.room,
    Icons.handyman_rounded,
     Icons.star,
     Icons.bar_chart,
  ];

  List<String> textList = [
    'Người dùng',
    'Thiết bị',
    'Nhập xuất',
    'Báo hỏng',
    'Mượn trả',
    'Vi phạm',
    'Phòng',
    'Bảo trì',
    'Đánh giá',
    'Thống kê',
  ];


  final items = [
  Image.asset('assets/slide_1.jpg', fit: BoxFit.cover),
  Image.asset('assets/slide_1.jpg', fit: BoxFit.cover),
  Image.asset('assets/slide_1.jpg', fit: BoxFit.cover),
];

int currentIndex = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text(
          'Trang chủ',
          style: TextStyle(fontSize: 20),
        ),
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Stack(
              children: [
                CarouselSlider(
                  items: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: AspectRatio(
                          aspectRatio: 3 / 1,
                          child: items[0],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: AspectRatio(
                          aspectRatio: 3 / 1,
                          child: items[1],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: AspectRatio(
                          aspectRatio: 3 / 1,
                          child: items[2],
                        ),
                      ),
                    ),
                  ],
                  options: CarouselOptions(
                    height: 200,
                    viewportFraction: 1,
                    autoPlay: true,
                    onPageChanged: (index, reason) {
                      setState(() {
                        currentIndex = index;
                      });
                    },
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 3,
                  child: DotsIndicator(
                    dotsCount: items.length,
                    position: currentIndex,
                    decorator: DotsDecorator(
                      color: Colors.black.withOpacity(0.3),
                      activeColor: Colors.white,
                      size: const Size(14, 3),
                      activeSize: const Size(14, 3),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      activeShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 60,
              width: 180,
              margin: const EdgeInsets.only(top: 16),
              child: Stack(
                children: [
                  Positioned(
                    bottom: 0,
                    child: Container(
                      height: 50,
                      width: 120,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(50),
                          bottomRight: Radius.circular(50),
                        ),
                        color: Themes.gradientDeepClr,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      height: 50,
                      width: 160,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.amber,
                      ),
                      child: const Row(children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: 20,
                            right: 10,
                          ),
                          child: Icon(
                            Icons.maps_home_work_rounded,
                            color: Colors.white,
                            size: 35,
                          ),
                        ),
                        Text(
                          'DỊCH VỤ',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 5,
              ),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                childAspectRatio: 1,
                children: List.generate(10, (index) {
                  return GestureDetector(
                    onTap: () {
                      if (index == 0) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => const UserManagement()),
                        );
                      }
                      if (index == 1) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => const DeviceTypeManagement()),
                        );
                      }
                      if (index == 2) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => const IoManagement()),
                        );
                      }
                      if (index == 3) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => const ReportManagementScreen()),
                        );
                      }
                      if (index == 4) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => const BorrowSlipManagementScreen()),
                        );
                      }
                      if (index == 5) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => const ViolateManagement()),
                        );
                      }
                      if (index == 6) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => const RoomManagementScreen()),
                        );
                      }
                      if (index == 7) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => const MaintainSlipManagementScreen()),
                        );
                      }
                      if (index == 8) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => const FeedbackManagementPage()),
                        );
                      }
                      if (index == 9) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => const LineChartSample2()),
                        );
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(),
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            iconList[index],
                            size: 45,
                            color: colors[index]
                                ,
                          ),
                          Text(
                            textList[index],
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.blueGrey),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
            
          ],
        ),
      ),
    );
  
  }
}
