import 'package:cloud_firestore/cloud_firestore.dart';

class Blog {
  int? id;
  String? title;
  String? description;
  String? thumbnailImagelUrl;
  int? loves;
  String? sourceUrl;
  String? date;
  String? timestamp;

  Blog(
      {this.id,
      this.title,
      this.description,
      this.thumbnailImagelUrl,
      this.loves,
      this.sourceUrl,
      this.date,
      this.timestamp});

  // factory Blog.fromFirestore(DocumentSnapshot snapshot) {
  //   Map d = snapshot.data() as Map<dynamic, dynamic>;
  //   return Blog(
  //     title: d['title'],
  //     description: d['description'],
  //     thumbnailImagelUrl: d['image url'],
  //     loves: d['loves'],
  //     sourceUrl: d['source'],
  //     date: d['date'],
  //     timestamp: d['timestamp'],
  //   );
  // }

  factory Blog.fromJson(Map<String, dynamic> d) {
    return Blog(
      id: d['id'],
      title: d['title'],
      description: d['content'],
      thumbnailImagelUrl: d['image_url'],
      loves: d['loves'],
      sourceUrl: d['url'],
      date: d['created_at'],
      timestamp: d['timestamp'],
    );
  }
}
