import 'package:cloud_firestore/cloud_firestore.dart';

class Area {
  String areaId;
  String areaName;

  Area.fromMap(Map<String, dynamic> map)
      : areaId = map['AreaId'],
        areaName = map['AreaName'];

  Area({
    required this.areaId,
    required this.areaName,
  });

  Map<String, dynamic> toMap() {
    return {
      'AreaId': areaId,
      'Area Name': areaName,
    };
  }

  factory Area.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

    if (data == null) {
      // Handle the case where data is null (if the document doesn't exist)
      throw Exception("Document does not exist");
    }

    return Area(
      areaId: data['Area Id'],
      areaName: data['Area Name'],
    );
  }
}
