class Device {
  final String deviceId;
  final String deviceName;
  final String description;
  final int deviceAmount;

  const Device(
      {required this.deviceId,
        required this.deviceName,
        required this.description,
        this.deviceAmount = 0});

  Map<String, dynamic> toMap(){
    return {
      "Device Id": deviceId,
      "Device Name": deviceName,
      "Description": description,
      "Device Amount": deviceAmount,
    };
  }
}
