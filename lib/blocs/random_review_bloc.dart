import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ipohgo/config/api.dart';
import 'package:http/http.dart' as http;
import 'package:ipohgo/models/review.dart';

class RandomReviewBloc extends ChangeNotifier {
  List<Review> _data = [];
  List<Review> get data => _data;

  bool _hasData = true;
  bool get hasData => _hasData;

  Future getData() async {
    final response = await http.get(Uri.parse(Api.url + "review/random"));

    // final response = await http.get(Uri.parse(link));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var _snapshot = jsonDecode(response.body);
      var snapshot = _snapshot['data'] as List;

      _data = snapshot.map<Review>((json) => Review.fromJson(json)).toList();

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
  }

  onRefresh(mounted) {
    _data.clear();
    getData();
    notifyListeners();
  }
}
