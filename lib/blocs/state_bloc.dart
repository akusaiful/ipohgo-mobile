import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ipohgo/config/api.dart';
import 'package:ipohgo/models/state.dart';
import 'package:http/http.dart' as http;

class StateBloc extends ChangeNotifier {
  DocumentSnapshot? _lastVisible;
  DocumentSnapshot? get lastVisible => _lastVisible;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  List<StateModel> _data = [];
  List<StateModel> get data => _data;

  List<DocumentSnapshot> _snap = [];
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  bool? _hasData;
  bool? get hasData => _hasData;

  int _offset = 0;

  Future<Null> getData(mounted) async {
    _hasData = true;
    // QuerySnapshot rawData;
    List<StateModel> rawData = [];

    print(_offset);

    final uri = Uri.http(Api.domain, Api.path + '/tour/category',
        {'offset': _offset.toString()});
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var _snapshot = jsonDecode(response.body);
      var snapshot = _snapshot['data'] as List;

      rawData = snapshot
          .map<StateModel>((json) => StateModel.fromJson(json))
          .toList();
    }

    // if (_lastVisible == null)
    //   rawData = await firestore
    //       .collection('states')
    //       .orderBy('timestamp', descending: false)
    //       .limit(10)
    //       .get();
    // else
    //   rawData = await firestore
    //       .collection('states')
    //       .orderBy('timestamp', descending: false)
    //       .startAfter([_lastVisible!['timestamp']])
    //       .limit(10)
    //       .get();

    // if (rawData.docs.length > 0) {
    //   _lastVisible = rawData.docs[rawData.docs.length - 1];
    //   if (mounted) {
    //     _isLoading = false;
    //     _snap.addAll(rawData.docs);
    //     _data = _snap.map((e) => StateModel.fromFirestore(e)).toList();
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
      // _lastVisible = rawData.docs[rawData.docs.length - 1];
      _offset += rawData.length;
      print(_offset.toString());
      // _isLoading = false;
      if (mounted) {
        _isLoading = false;
        _data.addAll(rawData);
        print('Here');
        // _data = _snap.map((e) => StateModel.fromFirestore(e)).toList();
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

    print("last status " + _isLoading.toString());

    notifyListeners();
    return null;
  }

  setLoading(bool isloading) {
    _isLoading = isloading;
    notifyListeners();
  }

  onRefresh(mounted) {
    _isLoading = true;
    _snap.clear();
    _data.clear();
    _offset = 0;
    // _lastVisible = null;
    getData(mounted);
    notifyListeners();
  }

  onReload(mounted) {
    _isLoading = true;
    _snap.clear();
    _data.clear();
    // _lastVisible = null;
    _offset = 0;
    getData(mounted);
    notifyListeners();
  }
}
