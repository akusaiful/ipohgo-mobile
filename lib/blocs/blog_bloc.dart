import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ipohgo/config/api.dart';
import 'package:ipohgo/models/blog.dart';
import 'package:http/http.dart' as http;

class BlogBloc extends ChangeNotifier {
  DocumentSnapshot? _lastVisible;
  DocumentSnapshot? get lastVisible => _lastVisible;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  List<Blog> _data = [];
  List<Blog> get data => _data;

  String _popSelection = 'popular';
  String get popupSelection => _popSelection;

  List<DocumentSnapshot> _snap = [];
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  bool? _hasData;
  bool? get hasData => _hasData;

  int _offset = 0;

  Future<Null> getData(mounted, String orderBy) async {
    _hasData = true;
    // QuerySnapshot rawData;

    // if (_lastVisible == null)
    //   rawData = await firestore
    //       .collection('blogs')
    //       .orderBy(orderBy, descending: true)
    //       .limit(5)
    //       .get();
    // else
    //   rawData = await firestore
    //       .collection('blogs')
    //       .orderBy(orderBy, descending: true)
    //       .startAfter([_lastVisible![orderBy]])
    //       .limit(5)
    //       .get();
    List<Blog> rawData = [];
    final uri = Uri.http(
        Api.domain, Api.path + '/news', {'offset': _offset.toString()});
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var _snapshot = jsonDecode(response.body);
      var snapshot = _snapshot['data'] as List;

      rawData = snapshot.map<Blog>((json) => Blog.fromJson(json)).toList();
    }

    // if (rawData.docs.length > 0) {
    //   _lastVisible = rawData.docs[rawData.docs.length - 1];
    //   if (mounted) {
    //     _isLoading = false;
    //     _snap.addAll(rawData.docs);
    //     _data = _snap.map((e) => Blog.fromFirestore(e)).toList();
    //   }
    // } else {
    //   if (_lastVisible == null) {
    //     _isLoading = false;
    //     _hasData = false;
    //     debugPrint('no items');
    //   } else {
    //     _isLoading = false;
    //     _hasData = true;
    //     debugPrint('no more items');
    //   }
    // }
    if (rawData.isNotEmpty) {
      // _lastVisible = rawData.length - 1;
      _offset += rawData.length;
      if (mounted) {
        _isLoading = false;
        _data.addAll(rawData);
        // _data = _snap.map((e) => Blog.fromFirestore(e)).toList();
      }
    } else {
      if (_offset == 0) {
        _isLoading = false;
        _hasData = false;
        debugPrint('no items');
      } else {
        _isLoading = false;
        _hasData = true;
        debugPrint('no more items');
      }
    }

    notifyListeners();
    return null;
  }

  afterPopSelection(value, mounted, orderBy) {
    _popSelection = value;
    onRefresh(mounted, orderBy);
    notifyListeners();
  }

  setLoading(bool isloading) {
    _isLoading = isloading;
    notifyListeners();
  }

  onRefresh(mounted, orderBy) {
    _isLoading = true;
    _snap.clear();
    _data.clear();
    // _lastVisible = null;
    _offset = 0;
    getData(mounted, orderBy);
    notifyListeners();
  }
}
