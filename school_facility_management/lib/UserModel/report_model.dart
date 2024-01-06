import 'package:cloud_firestore/cloud_firestore.dart';

class Report {
  List<String> imageList;
  String reportId; // Report code
  String areaId; // Area code
  String roomId; // Room code
  Map<String, dynamic> deviceDetail; // Device detail code
  String creator; // Creator of the report
  DateTime creationDate; // Date when the report was created
  String status; // Status of the report (unprocessed, processed, closed)
  String description; // Description of the damage

  Report({
    required this.reportId,
    required this.areaId,
    required this.roomId,
    required this.deviceDetail,
    required this.creator,
    required this.creationDate,
    required this.status,
    required this.description,
    required this.imageList,
  });
  // Convert the object to a Map for Firebase storage
  Map<String, dynamic> toMap() {
    return {
      'ReportId': reportId,
      'AreaId': areaId,
      'RoomId': roomId,
      'DeviceDetail': deviceDetail,
      'Creator': creator,
      'CreationDate': Timestamp.fromDate(creationDate),
      'Status': status,
      'Description': description,
      'ImageList': imageList,
    };
  }

  // Create an object from Firebase snapshot
  static Report fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Report(
      reportId: data['ReportId'],
      areaId: data['AreaId'],
      roomId: data['RoomId'],
      deviceDetail: data['DeviceDetail'],
      creator: data['Creator'],
      creationDate: (data['CreationDate'] as Timestamp).toDate(),
      status: data['Status'],
      description: data['Description'],
      imageList: List<String>.from(data['ImageList'] ?? []),
    );
  }
}
