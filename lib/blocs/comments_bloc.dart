import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ipohgo/config/api.dart';
import 'package:ipohgo/utils/toast.dart';
import 'package:http/http.dart' as http;

class CommentsBloc extends ChangeNotifier {
  String? date;
  String? newTimestamp;

  List<String> _flagList = [];
  List<String> get flagList => _flagList;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future saveNewComment(
      String collectionName, String? timestamp, String newComment) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    String? _name = sp.getString('name');
    String? _uid = sp.getString('uid');
    String? _imageUrl = sp.getString('image_url');

    await _getDate()
        .then((value) => firestore
                .collection('$collectionName/$timestamp/comments')
                .doc('$_uid$newTimestamp')
                .set({
              'name': _name,
              'comment': newComment,
              'date': date,
              'image url': _imageUrl,
              'timestamp': newTimestamp,
              'uid': _uid
            }))
        .then((value) {
      if (collectionName == 'places') {
        commentInrement(collectionName, timestamp);
      }
    });

    notifyListeners();
  }

  Future saveNewCommentApi(String collectionName, String? timestamp,
      String newComment, int id) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    // String? _name = sp.getString('name');
    // String? _uid = sp.getString('uid');
    // String? _imageUrl = sp.getString('image_url');

    // await _getDate()
    // .then((value) => firestore
    //    .collection('$collectionName/$timestamp/comments')
    //    .doc('$_uid$newTimestamp').set({
    //     'name': _name,
    //     'comment' : newComment,
    //     'date' : date,
    //     'image url' : _imageUrl,
    //     'timestamp': newTimestamp,
    //     'uid' : _uid
    //    })).then((value){
    //      if(collectionName == 'places'){
    //        commentInrement(collectionName, timestamp);
    //      }
    //    });
    final response = await http.post(
      Uri.parse(Api.url + 'tour/write-review/' + id.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + sp.getString('token').toString(),
      },
      body: jsonEncode(<String, dynamic>{
        'review_title': 'Title for review (System Default)',
        'review_content': newComment,
      }),
    );

    // print(response.body);

    notifyListeners();
    return response.body;
  }

  Future deleteComment(
    String collectionName,
    timestamp,
    uid,
    timestamp2,
  ) async {
    await firestore
        .collection('$collectionName/$timestamp/comments')
        .doc('$uid$timestamp2')
        .delete()
        .then((value) {
      if (collectionName == 'places') {
        commentDecrement(collectionName, timestamp);
      }
    });
    notifyListeners();
  }

  Future commentInrement(String collectionName, String? timestamp) async {
    final DocumentReference ref =
        firestore.collection(collectionName).doc(timestamp);
    DocumentSnapshot snap = await ref.get();
    int _commentsAmount = snap['comments count'];
    await ref.update({'comments count': _commentsAmount + 1});
  }

  Future commentDecrement(String collectionName, String? timestamp) async {
    final DocumentReference ref =
        firestore.collection(collectionName).doc(timestamp);
    DocumentSnapshot snap = await ref.get();
    int _commentsAmount = snap['comments count'];
    await ref.update({'comments count': _commentsAmount - 1});
  }

  Future _getDate() async {
    DateTime now = DateTime.now();
    String _date = DateFormat('dd MMMM yy').format(now);
    String _timestamp = DateFormat('yyyyMMddHHmmss').format(now);
    date = _date;
    newTimestamp = _timestamp;
  }

  Future getFlagList() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    _flagList = sp.getStringList('flag_list') ?? [];
    notifyListeners();
  }

  Future addToFlagList(context, String? commentsDocumentName) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    await getFlagList().then((value) async {
      List<String> a = _flagList;
      if (a.contains(commentsDocumentName)) {
        openToast1(context, 'You have flagged this comment already');
      } else {
        a.add(commentsDocumentName!);
        await sp.setStringList('flag_list', a);
      }
    });
  }

  Future removeFromFlagList(context, String? commentsDocumentName) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    await getFlagList().then((value) async {
      List<String> a = _flagList;
      if (a.contains(commentsDocumentName)) {
        a.remove(commentsDocumentName);
        await sp.setStringList('flag_list', a);
      }
    });
  }

  Future reportComment(String collectionName, String? postDocumentName,
      String? uid, String? commnetTimestamp) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    final String? _reporterUId = sp.getString('uid');
    final String _documentName =
        collectionName == 'places' ? 'place_reports' : 'blog_reports';
    final String _commentDocumentName = '$uid$commnetTimestamp';

    final CollectionReference ref = firestore
        .collection('user_reports')
        .doc(_documentName)
        .collection('reported_list');
    await _getDate().then((value) async {
      await ref.add({
        'reporter_uid': _reporterUId,
        'reported_uid': uid,
        'reported_at': DateTime.now(),
        'reported_document': _commentDocumentName,
        'timestamp': newTimestamp
      });
    });
  }
}
