import 'package:cloud_firestore/cloud_firestore.dart';

class Device {
  final String deviceId;
  final String deviceTypeId;
  final String deviceName;
  final String description;
  int deviceAmount;

  Device(
      {required this.deviceId,
        required this.deviceName,
        required this.description,
        required this.deviceTypeId,
        this.deviceAmount = 0});

  Map<String, dynamic> toMap(){
    return {
      "Device Id": deviceId,
      "Device Name": deviceName,
      "Description": description,
      "DeviceType Id": deviceTypeId,
      "Device Amount": deviceAmount,
    };
  }
  factory Device.fromMap(Map<String, dynamic> map) {
    return Device(
      deviceId: map['Device Id'],
      deviceTypeId: map['DeviceType Id'],
      deviceName: map['Device Name'],
      description: map['Description'],
      deviceAmount: map['Device Amount'] ?? 0,
    );
  }

  factory Device.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

    if (data == null) {
      // Handle the case where data is null (if the document doesn't exist)
      throw Exception("Document does not exist");
    }

    return Device(
      deviceId: data['Device Id'],
      deviceTypeId: data['DeviceType Id'],
      deviceName: data['Device Name'],
      description: data['Description'],
      deviceAmount: data['Device Amount'] ?? 0,
    );
  }
}
