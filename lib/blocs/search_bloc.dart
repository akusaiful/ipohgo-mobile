import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ipohgo/config/api.dart';
import 'package:ipohgo/models/place.dart';
import 'package:http/http.dart' as http;

class SearchBloc with ChangeNotifier {
  SearchBloc() {
    getRecentSearchList();
  }

  List<String> _recentSearchData = [];
  List<String> get recentSearchData => _recentSearchData;

  String _searchText = '';
  String get searchText => _searchText;

  bool _searchStarted = false;
  bool get searchStarted => _searchStarted;

  TextEditingController _textFieldCtrl = TextEditingController();
  TextEditingController get textfieldCtrl => _textFieldCtrl;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future getRecentSearchList() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    _recentSearchData = sp.getStringList('recent_search_data') ?? [];
    notifyListeners();
  }

  Future addToSearchList(String value) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    _recentSearchData.add(value);
    await sp.setStringList('recent_search_data', _recentSearchData);
    notifyListeners();
  }

  Future removeFromSearchList(String value) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    _recentSearchData.remove(value);
    await sp.setStringList('recent_search_data', _recentSearchData);
    notifyListeners();
  }

  // Future<List> getData2() async {
  //   List<Place> data = [];
  //   QuerySnapshot rawData = await firestore
  //       .collection('places')
  //       .orderBy('timestamp', descending: true)
  //       .get();

  //   List<DocumentSnapshot> _snap = [];
  //   _snap.addAll(rawData.docs.where((u) =>
  //       (u['place name'].toLowerCase().contains(_searchText.toLowerCase()) ||
  //           u['location'].toLowerCase().contains(_searchText.toLowerCase()))));
  //   data = _snap.map((e) => Place.fromFirestore(e)).toList();
  //   return data;
  // }

  Future<List> getData() async {
    List<Place> data = [];
    final uri =
        Uri.http(Api.domain, Api.path + '/tour/search', {'title': _searchText});
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      var _snapshot = jsonDecode(response.body);
      var snapshot = _snapshot['data'] as List;
      data = snapshot.map<Place>((json) => Place.fromJson(json)).toList();
    }

    return data;
  }

  setSearchText(value) {
    _textFieldCtrl.text = value;
    _searchText = value;
    _searchStarted = true;
    notifyListeners();
  }

  saerchInitialize() {
    _textFieldCtrl.clear();
    _searchStarted = false;
    notifyListeners();
  }
}
