import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ipohgo/config/api.dart';
import 'package:ipohgo/models/place.dart';
import 'package:http/http.dart' as http;

class PopularPlacesBloc extends ChangeNotifier {
  List<Place> _data = [];
  List<Place> get data => _data;

  bool _hasData = true;
  bool get hasData => _hasData;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Future getData() async {
  //   QuerySnapshot rawData;
  //     rawData = await firestore
  //         .collection('places')
  //         .orderBy('loves', descending: true)
  //         .limit(10)
  //         .get();

  //     List<DocumentSnapshot> _snap = [];
  //     _snap.addAll(rawData.docs);
  //     _data = _snap.map((e) => Place.fromFirestore(e)).toList();
  //     notifyListeners();
  // }

  Future getData() async {
    final response = await http.get(Uri.parse(Api.url + "tour/popular"));

    // final response = await http.get(Uri.parse(link));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var _snapshot = jsonDecode(response.body);
      var snapshot = _snapshot['data'] as List;

      _data = snapshot.map<Place>((json) => Place.fromJson(json)).toList();

      if (_data.isEmpty) {
        _hasData = false;
      } else {
        _hasData = true;
      }

      notifyListeners();
      // response.map((data) => Place.fromJson(jsonDecode(response.body)))->toList();
      // _data = Place.fromJson(jsonDecode(response.body)).toList();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      _hasData = false;
      notifyListeners();
      throw Exception('Failed to load data');
    }

    // _getFeaturedListJson().then((featuredList) async {
    //   QuerySnapshot rawData;
    //   rawData = await firestore
    //       .collection('places')
    //       .where('timestamp', whereIn: featuredList)
    //       .limit(10)
    //       .get();

    //   List<DocumentSnapshot> _snap = [];
    //   _snap.addAll(rawData.docs);
    //   _data = _snap.map((e) => Place.fromFirestore(e)).toList();
    //   _data.sort((a, b) => b.timestamp!.compareTo(a.timestamp!));
    //   if (_data.isEmpty) {
    //     _hasData = false;
    //   } else {
    //     _hasData = true;
    //   }
    //   notifyListeners();
    // }).onError((error, stackTrace) {
    //   _hasData = false;
    //   notifyListeners();
    // });
  }

  onRefresh(mounted) {
    _data.clear();
    getData();
    notifyListeners();
  }
}
