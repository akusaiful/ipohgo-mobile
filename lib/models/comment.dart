import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  String? uid;
  String? name;
  String? imageUrl;
  String? comment;
  String? date;
  String? timestamp;

  Comment(
      {this.uid,
      this.name,
      this.imageUrl,
      this.comment,
      this.date,
      this.timestamp});

  factory Comment.fromFirestore(DocumentSnapshot snapshot) {
    Map d = snapshot.data() as Map<dynamic, dynamic>;
    return Comment(
      uid: d['uid'],
      name: d['name'],
      imageUrl: d['image url'],
      comment: d['comment'],
      date: d['date'],
      timestamp: d['timestamp'],
    );
  }

  factory Comment.fromJson(Map<String, dynamic> d) {
    // Map d = snapshot.data() as Map<dynamic, dynamic>;
    return Comment(
      uid: d['id'].toString(),
      name: d['author']['name'],
      imageUrl: d['author']['avatar_url'],
      comment: d['content'],
      date: d['created_at'],
      timestamp: d['updated_at'],
    );
  }
}
