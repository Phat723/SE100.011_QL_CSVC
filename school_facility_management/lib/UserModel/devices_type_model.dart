class DeviceType {
  final String deviceTypeId;
  final String deviceTypeName;
  final int deviceTypeAmount;

  const DeviceType(
      {required this.deviceTypeId,
        required this.deviceTypeName,
        this.deviceTypeAmount = 0});

  Map<String, dynamic> toMap(){
    return {
      "DeviceType Id": deviceTypeId,
      "DeviceType Name": deviceTypeName,
      "DeviceType Amount": deviceTypeAmount,
    };
  }
}
