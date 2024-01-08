
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:school_facility_management/Controllers/Report_Controller.dart';
import 'package:school_facility_management/Controllers/Room_Controller.dart';
import 'package:school_facility_management/Model/AppTheme.dart';
import 'package:school_facility_management/UserModel/devices_detail_model.dart';
import 'package:school_facility_management/UserModel/report_model.dart';

class ReportInfoScreen extends StatefulWidget {
  final Report selectedReport;

  const ReportInfoScreen({super.key, required this.selectedReport});

  @override
  State<ReportInfoScreen> createState() => _ReportInfoScreenState();
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
              children: [
                GridView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: report!.imageList.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 3.0,
                    mainAxisSpacing: 3.0,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    return LayoutBuilder(builder:
                        (BuildContext context, BoxConstraints constraints) {
                      return Center(
                        child: Container(
                          height: constraints.maxWidth - 10,
                          width: constraints.maxHeight - 10,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: Colors.grey,
                          ),
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: constraints.maxWidth - 10,
                                width: constraints.maxHeight - 10,
                                child: GestureDetector(
                                  onTap: () {
                                    Get.to(FullScreenImageScreen(
                                        imageUrl: report!.imageList[index],imageList: report!.imageList),);
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: Hero(
                                      tag: report!.imageList[index],
                                      child: Image.network(
                                        report!.imageList[index],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
                  },
                ),
                Container(
                  height: 100,
                  width: context.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border:  Border.all(color: Colors.black12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(report!.description, style: AppTheme.body1,),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(onPressed: (){
                      DocumentReference docRef = FirebaseFirestore.instance.collection("Report").doc(report!.reportId);
                      report!.status = "Đã xử lý";
                      DeviceDetail deviceDetail = DeviceDetail.fromMap(report!.deviceDetail);
                      roomController.updateStatusDevice(deviceDetail.areaId, deviceDetail.roomId, deviceDetail, report!.status);
                      docRef.update(report!.toMap());
                      Get.back();
                    }, child: const Text("Đã Xử Lý")),
                    ElevatedButton(onPressed: ()async{
                      DocumentReference docRef = FirebaseFirestore.instance.collection("Report").doc(report!.reportId);
                      report!.status = "Đang xử lý";
                      DeviceDetail deviceDetail = DeviceDetail.fromMap(report!.deviceDetail);
                      roomController.updateStatusDevice(deviceDetail.areaId, deviceDetail.roomId, deviceDetail, report!.status);
                      await docRef.update(report!.toMap());
                      Get.back();
                    }, child: const Text("Đang Xử Lý")),
                    ElevatedButton(onPressed: ()async{
                      DocumentReference docRef = FirebaseFirestore.instance.collection("Report").doc(report!.reportId);
                      report!.status = "Đóng";
                      DeviceDetail deviceDetail = DeviceDetail.fromMap(report!.deviceDetail);
                      roomController.updateStatusDevice(deviceDetail.areaId, deviceDetail.roomId, deviceDetail, "Sẵn dùng");
                      await docRef.update(report!.toMap());
                      Get.back();
                    }, child: const Text("Đóng")),
                  ],
                ),
                //Row(children: [ElevatedButton(onPressed: onPressed, child: child), ElevatedButton(onPressed: onPressed, child: child)],)
              ],
            ),
          ),
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Report Info",
          style: AppTheme.headline,
        ),
      ),
    );
  }
}

class FullScreenImageScreen extends StatelessWidget {
  final String imageUrl;
  final List<String> imageList;

  const FullScreenImageScreen({super.key, required this.imageUrl, required this.imageList});

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
