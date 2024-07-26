import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ipohgo/config/api.dart';
import 'package:ipohgo/models/blog.dart';
import 'package:ipohgo/models/place.dart';
import 'package:http/http.dart' as http;

class BookmarkBloc extends ChangeNotifier {
  Future<List> getPlaceData() async {
    String collectionName = 'tour';
    // String type = 'bookmarked places';
    List<Place> data = [];
    // List<DocumentSnapshot> _snap = [];

    SharedPreferences sp = await SharedPreferences.getInstance();
    // String? _uid = sp.getString('uid');

    /*
    final DocumentReference ref =
        FirebaseFirestore.instance.collection('users').doc(_uid);              
    DocumentSnapshot snap = await ref.get();
    List d = snap[type];

    if (d.isNotEmpty) {
      QuerySnapshot rawData = await FirebaseFirestore.instance
          .collection(collectionName)
          .where('timestamp', whereIn: d)
          .get();
      _snap.addAll(rawData.docs);
      data = _snap.map((e) => Place.fromFirestore(e)).toList();
    }
    */
    // final uri =
    //     Uri.http(Api.domain, Api.path + '/user/bookmark-list', {'token': _uid});
    // final response = await http.get(uri);

    final response = await http.get(
      Uri.parse(Api.url + 'user/tour-wishlist'),
      // Uri.http(Api.domain, Api.path + '/user/tour-wishlist',
      //     {'type': collectionName}),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader:
            'Bearer ' + sp.getString('token').toString(),
      },
      // body: jsonEncode(<String, dynamic>{
      //   'object_model': collectionName,
      //   'object_id': id,
      // }),
    );

    if (response.statusCode == 200) {
      var _snapshot = jsonDecode(response.body);
      print('here');
      print(_snapshot);
      var snapshot = _snapshot['data'] as List;
      data = snapshot.map<Place>((json) => Place.fromJson(json)).toList();
    } else {
      print(sp.getString('token'));
      print(response.body);
    }

    return data;
  }

  /*
   * News
   */
  Future<List> getNewsData() async {
    String collectionName = 'news';
    // String type = 'bookmarked blogs';
    List<Blog> data = [];
    // List<DocumentSnapshot> _snap = [];
    SharedPreferences sp = await SharedPreferences.getInstance();
    // String? _uid = sp.getString('uid');

    final response = await http.get(
      Uri.http(Api.domain, Api.path + '/user/bookmark-list',
          {'type': collectionName}),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + sp.getString('token').toString(),
      },
    );

    if (response.statusCode == 200) {
      var _snapshot = jsonDecode(response.body);
      var snapshot = _snapshot['data'] as List;
      data = snapshot.map<Blog>((json) => Blog.fromJson(json)).toList();
    }

    return data;

    // final DocumentReference ref =
    //     FirebaseFirestore.instance.collection('users').doc(_uid);
    // DocumentSnapshot snap = await ref.get();
    // List d = snap[type];

    // if (d.isNotEmpty) {
    //   QuerySnapshot rawData = await FirebaseFirestore.instance
    //       .collection(collectionName)
    //       .where('timestamp', whereIn: d)
    //       .get();
    //   _snap.addAll(rawData.docs);
    //   // data = _snap.map((e) => Blog.fromFirestore(e)).toList();
    // }
    // return data;
  }

  Future<List> getBlogData() async {
    String collectionName = 'blogs';
    String type = 'bookmarked blogs';
    List<Blog> data = [];
    List<DocumentSnapshot> _snap = [];
    SharedPreferences sp = await SharedPreferences.getInstance();
    String? _uid = sp.getString('uid');

    final DocumentReference ref =
        FirebaseFirestore.instance.collection('users').doc(_uid);
    DocumentSnapshot snap = await ref.get();
    List d = snap[type];

    if (d.isNotEmpty) {
      QuerySnapshot rawData = await FirebaseFirestore.instance
          .collection(collectionName)
          .where('timestamp', whereIn: d)
          .get();
      _snap.addAll(rawData.docs);
      // data = _snap.map((e) => Blog.fromFirestore(e)).toList();
    }
    return data;
  }

  Future onBookmarkIconClick(String collectionName, String? timestamp) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    String? _uid = sp.getString('uid');
    String _type =
        collectionName == 'places' ? 'bookmarked places' : 'bookmarked blogs';

    final DocumentReference ref =
        FirebaseFirestore.instance.collection('users').doc(_uid);
    DocumentSnapshot snap = await ref.get();
    List d = snap[_type];

    if (d.contains(timestamp)) {
      List a = [timestamp];
      await ref.update({_type: FieldValue.arrayRemove(a)});
    } else {
      d.add(timestamp);
      await ref.update({_type: FieldValue.arrayUnion(d)});
    }

    notifyListeners();
  }

  Future onLoveIconClick(String collectionName, String? timestamp) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    String? _uid = sp.getString('uid');
    String _type = collectionName == 'places' ? 'loved places' : 'loved blogs';

    final DocumentReference ref =
        FirebaseFirestore.instance.collection('users').doc(_uid);
    final DocumentReference ref1 =
        FirebaseFirestore.instance.collection(collectionName).doc(timestamp);

    DocumentSnapshot snap = await ref.get();
    DocumentSnapshot snap1 = await ref1.get();
    List d = snap[_type];
    int? _loves = snap1['loves'];

    if (d.contains(timestamp)) {
      List a = [timestamp];
      await ref.update({_type: FieldValue.arrayRemove(a)});
      ref1.update({'loves': _loves! - 1});
    } else {
      d.add(timestamp);
      await ref.update({_type: FieldValue.arrayUnion(d)});
      ref1.update({'loves': _loves! + 1});
    }
  }

  //
  Future<int> onLoveIconClickHandle(
      String collectionName, int? id, int? totalLike) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();

    final response = await http.post(
      Uri.parse(Api.url + 'user/wishlist'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + sp.getString('token').toString(),
      },
      body: jsonEncode(<String, dynamic>{
        'object_model': collectionName,
        'object_id': id,
      }),
    );

    print(response.body);

    if (totalLike == null) {
      totalLike = 0;
    }

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      final active = data['class'];
      if (active == 'active') {
        print(data);
        totalLike++;
      } else {
        totalLike--;
      }
    }
    return totalLike;
  }

  Future<int> onBookmarkIconClickHandle(String collectionName, int? id) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();

    final response = await http.post(
      Uri.parse(Api.url + 'user/bookmark'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + sp.getString('token').toString(),
      },
      body: jsonEncode(<String, dynamic>{
        'object_model': collectionName,
        'object_id': id,
      }),
    );

    print(response.body);

    // if (totalLike == null) {
    //   totalLike = 0;
    // }

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      final active = data['class'];
      if (active == 'active') {
        print(data);
        return 1;
      } else {
        return 0;
      }
    }
    return 0;
  }
}
