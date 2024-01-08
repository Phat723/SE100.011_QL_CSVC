import 'package:cloud_firestore/cloud_firestore.dart';

class DeviceDetail {
  String deviceDetailId;
  String deviceId;
  String deviceTypeId;
  String areaId;
  String roomId;
  String storeCode;
  String deviceDetailName;
  String deviceStatus;
  String deviceCost;
  int maintainTime;
  String storingDay;
  final String? deviceOwner;

  DeviceDetail({
    required this.deviceDetailId,
    required this.deviceId,
    required this.deviceTypeId,
    this.areaId = "Not given",
    this.roomId = "Not given",
    required this.storeCode,
    required this.deviceDetailName,
    required this.deviceStatus,
    this.deviceOwner = "Unknown",
    required this.deviceCost,
    required this.storingDay,
    required this.maintainTime,
  });

  Map<String, dynamic> toMap() {
    return {
      "DeviceType Id": deviceTypeId,
      "Device Id": deviceId,
      "DeviceDetail Id": deviceDetailId,
      "AreaId": areaId,
      "RoomId": roomId,
      "StoreCode": storeCode,
      "DeviceDetail Name": deviceDetailName,
      "DeviceDetail Status": deviceStatus,
      "DeviceDetail Owner": deviceOwner,
      "DeviceDetail Cost": deviceCost,
      "DeviceDetail MaintainTime": maintainTime,
      "DeviceDetail StoringDay": storingDay,
    };
  }

  factory DeviceDetail.fromMap(Map<String, dynamic> map) {
    return DeviceDetail(
      deviceDetailId: map["DeviceDetail Id"],
      deviceId: map["Device Id"],
      deviceTypeId: map["DeviceType Id"],
      areaId: map["AreaId"],
      roomId: map["RoomId"],
      storeCode: map["StoreCode"],
      deviceDetailName: map["DeviceDetail Name"],
      deviceStatus: map["DeviceDetail Status"],
      deviceOwner: map["DeviceDetail Owner"],
      deviceCost: map["DeviceDetail Cost"]??'',
      maintainTime: map["DeviceDetail MaintainTime"]??0,
      storingDay: map["DeviceDetail StoringDay"]??'',
    );
  }

  // Hàm chuyển đổi từ DocumentSnapshot sang đối tượng DeviceDetail
  factory DeviceDetail.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> map = snapshot.data() as Map<String, dynamic>;
    return DeviceDetail.fromMap(map);
  }
}
