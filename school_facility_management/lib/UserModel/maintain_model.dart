import 'package:cloud_firestore/cloud_firestore.dart';

class MaintainTicket {
  String maintainId;
  DateTime createDay;
  DateTime finishDay;
  String creatorName;
  String confirmName;
  String maintainStatus;
  List<dynamic> maintainDeviceList;

  MaintainTicket({
    required this.maintainId,
    required this.createDay,
    required this.finishDay,
    required this.creatorName,
    required this.confirmName,
    required this.maintainStatus,
    required this.maintainDeviceList,
  });

  // Convert MaintenanceTicket object to a Map
  Map<String, dynamic> toMap() {
    return {
      'MaintainId': maintainId,
      'Create Day': createDay,
      'Finish Day': finishDay,
      'Creator Name': creatorName,
      'Confirm Name': confirmName,
      'Maintain Status': maintainStatus,
      'Maintain Device List': maintainDeviceList,
    };
  }

  // Create a MaintenanceTicket object from a Map
  factory MaintainTicket.fromMap(Map<String, dynamic> map) {
    return MaintainTicket(
      maintainId: map['MaintainId'],
      createDay: map['Create Day'].toDate(),
      finishDay: map['Finish Day'].toDate(),
      creatorName: map['Creator Name'],
      confirmName: map['Confirm Name'],
      maintainStatus: map['Maintain Status'],
      maintainDeviceList: List<dynamic>.from(map['Maintain Device List']),
    );
  }

  // Create a MaintenanceTicket object from a Firestore snapshot
  factory MaintainTicket.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> map = snapshot.data() as Map<String, dynamic>;
    return MaintainTicket.fromMap(map);
  }
}