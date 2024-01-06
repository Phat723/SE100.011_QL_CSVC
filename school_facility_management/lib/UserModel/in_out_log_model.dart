
import 'package:cloud_firestore/cloud_firestore.dart';

class InOutLog {
   String inOutId;
   String? creatorName;
   String createDay;
   String createType;
   String createCase;

   InOutLog(
       {required this.inOutId,
         required this.creatorName,
         required this.createDay,
         required this.createType,
         required this.createCase});

   Map<String, dynamic> toMap(){
    return {
      "In_Out Id": inOutId,
      "Creator's Name": creatorName,
      "Created Day": createDay,
      "Type": createType,
      "Create Case": createCase,
    };
  }
  factory InOutLog.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return InOutLog(
      inOutId: data['In_Out Id'] ?? '',
      creatorName: data["Creator's Name"],
      createDay: data['Created Day'] ?? '',
      createType: data['Type'] ?? '',
      createCase: data['Create Case'] ?? '',
    );
  }

  factory InOutLog.fromMap(Map<String, dynamic> map) {
    return InOutLog(
      inOutId: map['In_Out Id'] ?? '',
      creatorName: map["Creator's Name"],
      createDay: map['Created Day'] ?? '',
      createType: map['Type'] ?? '',
      createCase: map['Create Case'] ?? '',
    );
  }
}