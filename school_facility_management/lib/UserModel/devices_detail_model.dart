class DeviceDetail {
  final String deviceDetailId;
  final String areaId;
  final String? roomId;
  final String storeCode;
  final String deviceDetailName;
  final String deviceStatus;
  final String deviceOwner;

  const DeviceDetail({
    required this.deviceDetailId,
    required this.areaId,
    this.roomId = "",
    required this.storeCode,
    required this.deviceDetailName,
    required this.deviceStatus,
    required this.deviceOwner
  });

  Map<String, dynamic> toMap(){
    return {
      "DeviceDetail Id": deviceDetailId,
      "AreaId": areaId,
      "RoomId": roomId,
      "StoreCode": storeCode,
      "DeviceDetail Name": deviceDetailName,
      "DeviceDetail Status": deviceStatus,
      "DeviceDetail Owner": deviceOwner,
    };
  }
}