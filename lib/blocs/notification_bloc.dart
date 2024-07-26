import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ipohgo/config/api.dart';

import '../models/notification.dart';
import '../services/notification_service.dart';
import '../services/sp_service.dart';
import '../utils/notification_permission_dialog.dart';
import 'package:http/http.dart' as http;

class NotificationBloc extends ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  DocumentSnapshot? _lastVisible;
  DocumentSnapshot? get lastVisible => _lastVisible;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  bool? _hasData;
  bool? get hasData => _hasData;

  List<DocumentSnapshot> _snap = [];

  List<NotificationModel> _data = [];
  List<NotificationModel> get data => _data;

  bool _subscribed = false;
  bool get subscribed => _subscribed;

  // Future<Null> getData(mounted) async {
  //   _hasData = true;
  //   QuerySnapshot rawData;
  //   if (_lastVisible == null)
  //     rawData = await firestore
  //         .collection('notifications')
  //         .orderBy('timestamp', descending: true)
  //         .limit(10)
  //         .get();
  //   else
  //     rawData = await firestore
  //         .collection('notifications')
  //         .orderBy('timestamp', descending: true)
  //         .startAfter([_lastVisible!['timestamp']])
  //         .limit(10)
  //         .get();

  //   if (rawData.docs.length > 0) {
  //     _lastVisible = rawData.docs[rawData.docs.length - 1];
  //     if (mounted) {
  //       _isLoading = false;
  //       _snap.addAll(rawData.docs);
  //       _data = _snap.map((e) => NotificationModel.fromFirestore(e)).toList();
  //     }
  //   } else {
  //     if (_lastVisible == null) {
  //       _isLoading = false;
  //       _hasData = false;
  //       debugPrint('no items');
  //     } else {
  //       _isLoading = false;
  //       _hasData = true;
  //       debugPrint('no more items');
  //     }
  //   }

  //   notifyListeners();
  //   return null;
  // }

  Future<Null> getData(mounted) async {
    _hasData = true;

    final response = await http.get(Uri.parse(Api.url + "notification"));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var _snapshot = jsonDecode(response.body);
      var snapshot = _snapshot['data'] as List;

      _data = snapshot
          .map<NotificationModel>((json) => NotificationModel.fromJson(json))
          .toList();
      // notifyListeners();
      _isLoading = false;

      if (_data.isEmpty) {
        _hasData = false;
      } else {
        _hasData = true;
      }
    } else {
      _hasData = false;
      throw Exception('Failed to load data');
    }

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
    _lastVisible = null;
    getData(mounted);
    notifyListeners();
  }

  onReload(mounted) {
    _isLoading = true;
    _snap.clear();
    _data.clear();
    _lastVisible = null;
    getData(mounted);
    notifyListeners();
  }

  Future checkPermission() async {
    await NotificationService()
        .checkingPermisson()
        .then((bool? accepted) async {
      if (accepted != null && accepted) {
        checkSubscription();
      } else {
        await SPService().setNotificationSubscription(false);
        _subscribed = false;
        notifyListeners();
      }
    });
  }

  Future checkSubscription() async {
    await SPService().getNotificationSubscription().then((bool value) async {
      if (value) {
        await NotificationService().subscribe();
        _subscribed = true;
      } else {
        await NotificationService().unsubscribe();
        _subscribed = false;
      }
    });
    notifyListeners();
  }

  handleSubscription(context, bool newValue) async {
    if (newValue) {
      await NotificationService()
          .checkingPermisson()
          .then((bool? accepted) async {
        if (accepted != null && accepted) {
          await NotificationService().subscribe();
          await SPService().setNotificationSubscription(newValue);
          _subscribed = true;
          Fluttertoast.showToast(msg: 'Notification turned On');
          notifyListeners();
        } else {
          openNotificationPermissionDialog(context);
        }
      });
    } else {
      await NotificationService().unsubscribe();
      await SPService().setNotificationSubscription(newValue);
      _subscribed = newValue;
      Fluttertoast.showToast(msg: "Notification turned Off");
      notifyListeners();
    }
  }
}
