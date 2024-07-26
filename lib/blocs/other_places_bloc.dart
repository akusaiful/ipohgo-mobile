import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:ipohgo/models/place.dart';
import 'package:http/http.dart' as http;
import 'package:ipohgo/config/api.dart';

class OtherPlacesBloc extends ChangeNotifier {
  List<Place> _data = [];
  List<Place> get data => _data;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future _getData(String? stateName, String? timestamp) async {
    _data.clear();
    QuerySnapshot rawData;
    rawData = await firestore
        .collection('places')
        .where('state', isEqualTo: stateName)
        .where('timestamp', isNotEqualTo: timestamp)
        .orderBy('timestamp', descending: true)
        .limit(6)
        .get();

    List<DocumentSnapshot> _snap = [];
    _snap.addAll(rawData.docs);
    // _data = _snap.map((e) => Place.fromFirestore(e)).toList();
    notifyListeners();
  }

  Future getData(String? stateName, String? timestamp, int? id) async {
    _data.clear();
    List<Place> _snap = [];
    // List<Place> data = [];
    final uri = Uri.http(
        Api.domain, Api.path + '/tour/view/category', {'id': id.toString()});
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var _snapshot = jsonDecode(response.body);
      var snapshot = _snapshot['data'] as List;

      _data = snapshot.map<Place>((json) => Place.fromJson(json)).toList();
    }

    _snap.addAll(_data);
    // _data = _snap.map((e) => Place.fromFirestore(e)).toList();
    notifyListeners();
  }

  onRefresh(mounted, String stateName, String timestamp, int id) {
    _data.clear();
    getData(stateName, timestamp, id);
    notifyListeners();
  }
}
