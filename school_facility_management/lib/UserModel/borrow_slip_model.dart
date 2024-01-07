import 'package:cloud_firestore/cloud_firestore.dart';

class BorrowSlip {
  String borrowID;
  String borrowDate;
  String returnDate;
  String borrower;
  String creatorEmail;
  String returnProcessorEmail;
  String status;
  double totalLostAmount;
  List<dynamic> borrowDevices;

  BorrowSlip({
    required this.borrowID,
    required this.borrowDate,
    required this.returnDate,
    required this.borrower,
    required this.creatorEmail,
    required this.returnProcessorEmail,
    required this.status,
    required this.totalLostAmount,
    required this.borrowDevices,
  });

  // Factory method to create an object from a map
  factory BorrowSlip.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

    if (data == null) {
      // Handle the case where data is null (if the document doesn't exist)
      throw Exception("Document does not exist");
    }

    return BorrowSlip(
      borrowID: data['BorrowID'],
      borrowDate: data['BorrowDate'],
      returnDate: data['ReturnDate']??"Not Found",
      borrower: data['Borrower'],
      creatorEmail: data['CreatorEmail'],
      returnProcessorEmail: data['ReturnProcessorEmail'],
      status: data['Status'],
      totalLostAmount: data['TotalLostAmount'].toDouble(),
      borrowDevices: data['BorrowDevices'],
    );
  }
  // Method to convert an object to a map
  Map<String, dynamic> toMap() {
    return {
      'BorrowID': borrowID,
      'BorrowDate': borrowDate,
      'ReturnDate': returnDate,
      'Borrower': borrower,
      'CreatorEmail': creatorEmail,
      'ReturnProcessorEmail': returnProcessorEmail,
      'Status': status,
      'TotalLostAmount': totalLostAmount,
      'BorrowDevices': borrowDevices,
    };
  }
}