import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackModel {
  String? username;
  String? useremail;
  double? rating;
  List<String>? content;
  DateTime? rateDate;
  String? idUser;
  String? idDoc;

  FeedbackModel({
    this.username,
    this.useremail,
    this.rating,
    this.content,
    this.rateDate,
    this.idUser,
    this.idDoc,
  });

  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    Timestamp timestampSelectedDate = json['rateDate'];
    DateTime selectedDate = timestampSelectedDate.toDate();
    return FeedbackModel(
      username: json['username'],
      useremail: json['useremail'],
      rating: json['rating'],
      content: List<String>.from(json['content']),
      rateDate: selectedDate,
      idUser: json['idUser'],
      idDoc: json['idDoc'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username ?? '',
      'useremail': useremail ?? '',
      'rating': rating ?? 0,
      'content': List<dynamic>.from(content!),
      'rateDate': Timestamp.fromDate(rateDate!),
      'idUser': idUser ?? '',
      'idDoc': idDoc ?? '',
    };
  }
}
