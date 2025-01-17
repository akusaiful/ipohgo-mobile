import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ipohgo/config/api.dart';
import 'package:ipohgo/models/place.dart';
import 'package:http/http.dart' as http;

class RecommandedPlacesBloc extends ChangeNotifier {
  List<Place> _data = [];
  List<Place> get data => _data;

  // final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future getData() async {
    final response = await http.get(Uri.parse(Api.url + "tour/recommended"));
    // QuerySnapshot rawData;
    // rawData = await firestore
    //     .collection('places')
    //     .orderBy('comments count', descending: true)
    //     .limit(5)
    //     .get();
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var _snapshot = jsonDecode(response.body);
      var snapshot = _snapshot['data'] as List;

      _data = snapshot.map<Place>((json) => Place.fromJson(json)).toList();
      print(_snapshot);

      notifyListeners();
      // response.map((data) => Place.fromJson(jsonDecode(response.body)))->toList();
      // _data = Place.fromJson(jsonDecode(response.body)).toList();
    }

    // List<DocumentSnapshot> _snap = [];
    // _snap.addAll(rawData.docs);
    // _data = _snap.map((e) => Place.fromFirestore(e)).toList();
    // notifyListeners();
  }

  onRefresh(mounted) {
    _data.clear();
    getData();
    notifyListeners();
  }
}
