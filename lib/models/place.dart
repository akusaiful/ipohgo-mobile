import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ipohgo/models/comment.dart';
import 'package:ipohgo/models/exclude.dart';
import 'package:ipohgo/models/faq.dart';
import 'package:ipohgo/models/include.dart';
import 'package:ipohgo/widgets/custom_cache_image.dart';
import 'package:ipohgo/widgets/reviews.dart';

class Place {
  int? id;
  int? categoryId;
  String? state;
  String? category;
  String? name;
  String? location;
  double? latitude;
  double? longitude;
  String? description;
  String? content;
  String? bannerImage;
  String? featuredImage;
  String? imageUrl1;
  String? imageUrl2;
  String? imageUrl3;
  bool? freeParking;
  bool? paidParking;
  int? loves;
  int? commentsCount;
  int? views;
  String? date;
  String? timestamp;
  List<Faq>? faqs;
  List<Include>? include;
  List<Exclude>? exclude;
  List<Comment>? reviews;
  List<Widget>? sliders;

  Place({
    this.id,
    this.categoryId,
    this.category,
    this.state,
    this.name,
    this.location,
    this.latitude,
    this.longitude,
    this.description,
    this.content,
    this.bannerImage,
    this.featuredImage,
    this.imageUrl1,
    this.imageUrl2,
    this.imageUrl3,
    this.freeParking,
    this.paidParking,
    this.loves,
    this.commentsCount,
    this.views,
    this.date,
    this.timestamp,
    this.faqs,
    this.include,
    this.exclude,
    this.reviews,
    this.sliders,
  });

  // factory Place.fromFirestore(DocumentSnapshot snapshot) {
  //   Map d = snapshot.data() as Map<dynamic, dynamic>;
  //   return Place(
  //     state: d['state'],
  //     name: d['place name'],
  //     location: d['location'],
  //     latitude: d['latitude'],
  //     longitude: d['longitude'],
  //     description: d['description'],
  //     imageUrl1: d['image-1'],
  //     imageUrl2: d['image-2'],
  //     imageUrl3: d['image-3'],
  //     loves: d['loves'],
  //     commentsCount: d['comments count'],
  //     date: d['date'],
  //     faqs: d['faqs'],
  //     timestamp: d['timestamp'],
  //   );
  // }

  factory Place.fromJson(Map<String, dynamic> d) {
    List<Faq> _faqs = [];
    List<Include> _include = [];
    List<Exclude> _exclude = [];
    List<Comment> _reviews = [];
    List<Widget> _sliders = [];

    if (d['faqs'] != null) {
      var tagObjsJson = d['faqs'] as List;
      _faqs = tagObjsJson.map((tagJson) => Faq.fromJson(tagJson)).toList();
    }

    if (d['include'] != null) {
      var json = d['include'] as List;
      _include = json.map((tagJson) => Include.fromJson(tagJson)).toList();
    }

    if (d['exclude'] != null) {
      var json = d['exclude'] as List;
      _exclude = json.map((tagJson) => Exclude.fromJson(tagJson)).toList();
    }

    if (d['reviews'] != null) {
      var json = d['reviews'] as List;
      _reviews = json.map((tagJson) => Comment.fromJson(tagJson)).toList();
    }

    if (d['sliders'] != null) {
      var sliders = d['sliders'] as List;
      for (var i = 0; i < sliders.length; i++) {
        // print(sliders[i]);
        _sliders.add(CustomCacheImage(imageUrl: sliders[i]));
      }

      // Map map = d['sliders'];
      // map.forEach((key, value) {
      //   // _images.add(CustomCacheImage(imageUrl: ))
      //   print(value);
      // });
    }

    return Place(
      id: d['id'],
      categoryId: d['category_id'],
      category: d['category'],
      state: d['state']['name'],
      name: d['place name'],
      location: d['location'],
      latitude: double.parse(d['latitude'].toString()),
      longitude: double.parse(d['longitude'].toString()),
      description: d['description'],
      content: d['content'],
      bannerImage: d['banner_image'],
      featuredImage: d['featured_image'],
      imageUrl1: d['image-1'],
      imageUrl2: d['image-2'],
      imageUrl3: d['image-3'],
      freeParking: d['free_parking'],
      paidParking: d['paid_parking'],
      loves: d['loves'],
      commentsCount: d['review_score']['total_review'],
      views: d['views'],
      date: d['date'],
      faqs: _faqs,
      include: _include,
      exclude: _exclude,
      reviews: _reviews,
      sliders: _sliders,
      timestamp: d['timestamp'],
    );
  }
}
