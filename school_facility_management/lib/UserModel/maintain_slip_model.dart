import 'package:cloud_firestore/cloud_firestore.dart';

class MaintainSlip {
  String maintainID;
  String confirmName;
  String creatorName;
  String maintainStatus;
  List<dynamic> maintainDeviceList;
  Timestamp createDay;
  Timestamp? finishDay;

  MaintainSlip({
    required this.maintainID,
    required this.confirmName,
    required this.creatorName,
    required this.maintainStatus,
    required this.maintainDeviceList,
    required this.createDay,
    required this.finishDay,

  });

  // Factory method to create an object from a map
  factory MaintainSlip.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

    if (data == null) {
      // Handle the case where data is null (if the document doesn't exist)
      throw Exception("Document does not exist");
    }

    return MaintainSlip(
      maintainID: data['MaintainId'],
      confirmName: data['Confirm Name'],
      creatorName: data['Creator Name'],
      maintainStatus: data['Maintain Status'],
      maintainDeviceList: data['Maintain Device List'],
      createDay: data['Create Day'],
      finishDay: data['Finish Day'],
    );
  }
  // Method to convert an object to a map
  Map<String, dynamic> toMap() {
    return {
      'MaintainId': maintainID,
      'Confirm Name':confirmName,
      'Creator Name':creatorName,
      'Maintain Status':maintainStatus,
      'Maintain Device List':maintainDeviceList,
      'Create Day':createDay,
      'Finish Day':finishDay,
    };
  }
  String timestampToString(Timestamp timestamp) {
    if (timestamp != null) {
      DateTime dateTime = timestamp.toDate();
      return dateTime.toString();
    } else {
      return 'N/A'; // Return a default value if the timestamp is null
    }
  }
}