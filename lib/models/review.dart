import 'dart:convert';

import 'package:ipohgo/models/place.dart';

/*
* Random review for home
 */
class Review {
  String? id;
  String? content;
  String? createdAt;
  String? author;
  String? avatarUrl;
  Place? place;

  Review(
      {this.id,
      this.content,
      this.createdAt,
      this.author,
      this.avatarUrl,
      this.place});

  factory Review.fromJson(Map<String, dynamic> d) {
    // Map<String, dynamic> place = json.decode(d['place']);
    // print(d['place']);
    // print('Id Review' + d['id']);

    return Review(
      id: d['id'].toString(),
      author: d['author']['name'],
      avatarUrl: d['author']['avatar_url'],
      content: d['content'],
      createdAt: d['created_at'],
      place: Place.fromJson(d['place']),
    );
  }
}
