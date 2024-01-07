import 'package:cloud_firestore/cloud_firestore.dart';

class DeviceType {
  final String deviceTypeId;
  final String deviceTypeName;
  final String? imageURL;
  int deviceTypeAmount;

  DeviceType(
      {required this.deviceTypeId,
      required this.deviceTypeName,
      this.imageURL,
      this.deviceTypeAmount = 0});

  Map<String, dynamic> toMap() {
    return {
      "DeviceType Id": deviceTypeId,
      "DeviceType Name": deviceTypeName,
      "DeviceType Amount": deviceTypeAmount,
      "imageURL": imageURL,
    };
  }

  factory DeviceType.fromMap(Map<String, dynamic> map) {
    return DeviceType(
      deviceTypeId: map['DeviceType Id'],
      deviceTypeName: map['DeviceType Name'],
      deviceTypeAmount: map['DeviceType Amount'] ?? 0,
      imageURL: map['imageURL'] ?? '',
    );
  }

  factory DeviceType.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

    if (data == null) {
      // Handle the case where data is null (if the document doesn't exist)
      throw Exception("Document does not exist");
    }

    return DeviceType(
      deviceTypeId: data['DeviceType Id'],
      deviceTypeName: data['DeviceType Name'],
      deviceTypeAmount: data['DeviceType Amount'] ?? 0,
      imageURL: data['imageURL'] ?? '',
    );
  }
}
