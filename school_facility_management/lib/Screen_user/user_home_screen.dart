import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:school_facility_management/Model/theme.dart';
import 'package:school_facility_management/Screen_user/create_report_screen.dart';
import 'package:school_facility_management/Screen_user/feedback.dart';
import 'package:school_facility_management/Screen_user/feedback_management.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

final items = [
  Image.asset('assets/slide_1.jpg', fit: BoxFit.cover),
  Image.asset('assets/slide_1.jpg', fit: BoxFit.cover),
  Image.asset('assets/slide_1.jpg', fit: BoxFit.cover),
];

int currentIndex = 0;

class _UserHomeScreenState extends State<UserHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text(
          'Báo hỏng và đánh giá CSVC',
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
                crossAxisCount: 2,
                childAspectRatio: 1,
                children: List.generate(2, (index) {
                  return GestureDetector(
                    onTap: () {
                      if (index == 0) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => const CreateReportScreen()),
                        );
                      }
                      if (index == 1) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => const FeedbackScreen()),
                        );
                      }
                    },
                    child: Container(
                      height: 100,
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
                            (index == 0)
                                ? Icons.report_problem_rounded
                                : Icons.rate_review,
                            size: 100,
                            color:
                                (index == 0) ? Colors.amber : Colors.blueAccent,
                          ),
                          Text(
                            (index == 0) ? 'Báo hỏng' : 'Đánh giá',
                            style: const TextStyle(
                                fontSize: 20,
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
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (_) => const FeedbackManagementPage()),
                );
              },
              child: Text('HAHAHAHA'),
            )
          ],
        ),
      ),
    );
  }
}
