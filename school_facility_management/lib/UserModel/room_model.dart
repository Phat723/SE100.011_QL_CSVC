class Room {
  final String roomId;
  final String roomName;
  final String roomDesc;
  final String roomFloor;
  const Room(
      {required this.roomId,
        required this.roomName,
        required this.roomDesc,
        required this.roomFloor,
      });

  Map<String, dynamic> toMap(){
    return {
      "Room Id": roomId,
      "Room Name": roomName,
      "Room Name": roomDesc,
      "Room Name": roomFloor,
    };
  }
}
