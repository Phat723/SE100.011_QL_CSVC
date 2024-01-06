import 'package:cloud_firestore/cloud_firestore.dart';

class Room {
  String areaId;
  String roomId;
  String roomName;
  String floor;
  String description;
  List<dynamic>? devices;

  Room({
    required this.areaId,
    required this.roomId,
    required this.roomName,
    required this.floor,
    required this.description,
    this.devices,
  });

  Room.fromMap(Map<String, dynamic> map)
      : areaId = map['AreaId'],
        roomId = map['RoomId'],
        roomName = map['Room Name'],
        floor = map['Floor'],
        description = map['Description'],
        devices = List<Map<String, dynamic>>.from(map['Devices'] ?? []);

  Map<String, dynamic> toMap() {
    return {
      'AreaId': areaId,
      'RoomId': roomId,
      'Room Name': roomName,
      'Floor': floor,
      'Description': description,
      'Devices': devices,
    };
  }

  static Room fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Room(areaId: data['AreaId'],
      roomId: data['RoomId'],
      roomName: data['Room Name'],
      description: data['Description'],
      floor: data['Floor'],
      devices: data['Devices'],
    );
  }
}