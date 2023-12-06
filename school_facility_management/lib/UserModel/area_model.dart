class Area {
  final String areaId;
  final String areaName;
  const Area(
      {required this.areaId,
        required this.areaName,});

  Map<String, dynamic> toMap(){
    return {
      "Area Id": areaId,
      "Area Name": areaName,
    };
  }
}
