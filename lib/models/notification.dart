// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';

class NotificationModel {
  String? title;
  String? description;
  String? preview;
  var createdAt;
  String? timestamp;
  String? author;

  NotificationModel({
    this.title,
    this.description,
    this.preview,
    this.createdAt,
    this.timestamp,
    this.author,
  });

  // factory NotificationModelModel.fromFirestore(DocumentSnapshot snapshot) {
  //   Map d = snapshot.data() as Map<dynamic, dynamic>;
  //   return NotificationModelModel(
  //     title: d['title'],
  //     description: d['description'],
  //     createdAt: DateFormat('d MMM, y')
  //         .format(DateTime.parse(d['created_at'].toDate().toString())),
  //     timestamp: d['timestamp'],
  //   );
  // }

  factory NotificationModel.fromJson(Map<String, dynamic> d) {
    return NotificationModel(
      title: d['title'],
      description: d['body'],
      preview: d['preview'],
      createdAt: d['created_at'],
      timestamp: d['timestamp'],
      author: d['author']['display_name'],
    );
  }
}
