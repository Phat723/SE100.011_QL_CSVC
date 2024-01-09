import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:school_facility_management/Controllers/Report_Controller.dart';
import 'package:school_facility_management/Controllers/Room_Controller.dart';
import 'package:school_facility_management/Model/AppTheme.dart';
import 'package:school_facility_management/Model/theme.dart';
import 'package:school_facility_management/UserModel/devices_detail_model.dart';
import 'package:school_facility_management/UserModel/report_model.dart';

class ReportInfoScreen extends StatefulWidget {
  final Report selectedReport;

  const ReportInfoScreen({Key? key, required this.selectedReport}) : super(key: key);

  @override
  _ReportInfoScreenState createState() => _ReportInfoScreenState();
}

class _ReportInfoScreenState extends State<ReportInfoScreen> {
  ReportController reportController = Get.put(ReportController());
  Report? report;
  RoomController roomController = Get.put(RoomController());

  @override
  void initState() {
    report = widget.selectedReport;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    'Hình Ảnh',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                GridView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: report!.imageList.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    return LayoutBuilder(
                      builder: (BuildContext context, BoxConstraints constraints) {
                        return GestureDetector(
                          onTap: () {
                            Get.to(FullScreenImageScreen(
                              imageUrl: report!.imageList[index],
                              imageList: report!.imageList,
                            ));
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Hero(
                              tag: report!.imageList[index],
                              child: Image.network(
                                report!.imageList[index],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    'Mô tả chi tiết',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black12),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      report!.description,
                      style: AppTheme.body1.copyWith(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Trạng thái phiếu báo hỏng',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _updateReportStatus("Đã xử lý");
                      },
                      child: const Text("Đã Xử Lý"),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        primary: Color.fromARGB(255, 12, 139, 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        _updateReportStatus("Đang xử lý");
                      },
                      child: const Text("Đang Xử Lý"),
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(255, 197, 179, 17),
                        foregroundColor: Colors.white,                
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        _updateReportStatus("Đóng");
                      },
                      child: const Text("Đóng"),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        primary: Color.fromARGB(255, 6, 121, 214),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text(
          'Chi Tiết Báo Hỏng',
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
    );
  }

  void _updateReportStatus(String status) async {
    DocumentReference docRef =
        FirebaseFirestore.instance.collection("Report").doc(report!.reportId);
    report!.status = status;
    DeviceDetail deviceDetail = DeviceDetail.fromMap(report!.deviceDetail);
    await roomController.updateStatusDevice(
      deviceDetail.areaId,
      deviceDetail.roomId,
      deviceDetail,
      status == "Đóng" ? "Sẵn dùng" : status,
    );
    await docRef.update(report!.toMap());
    Get.back();
  }
}

class FullScreenImageScreen extends StatelessWidget {
  final String imageUrl;
  final List<String> imageList;

  const FullScreenImageScreen(
      {Key? key, required this.imageUrl, required this.imageList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Full Screen Image'),
      ),
      body: Center(
        child: Hero(
          tag: imageUrl,
          child: PhotoViewGallery.builder(
            itemCount: imageList.length,
            builder: (BuildContext context, int index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: NetworkImage(imageList[index]),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 2,
              );
            },
            scrollPhysics: const BouncingScrollPhysics(),
            backgroundDecoration: const BoxDecoration(
              color: Colors.black,
            ),
            pageController: PageController(initialPage: imageList.indexOf(imageUrl)),
          ),
        ),
      ),
    );
  }
}
