import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ipohgo/blocs/sign_in_bloc.dart';
import 'package:ipohgo/config/api.dart';
import 'package:ipohgo/models/icon_data.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class BuildBookmarkIcon extends StatelessWidget {
  final String collectionName;
  final String? uid;
  final int? objectId;
  final String? timestamp;

  const BuildBookmarkIcon(
      {Key? key,
      required this.collectionName,
      required this.uid,
      required this.objectId,
      required this.timestamp})
      : super(key: key);

  @override
  Widget _build(BuildContext context) {
    final sb = context.watch<SignInBloc>();
    String _type =
        collectionName == 'places' ? 'bookmarked places' : 'bookmarked blogs';
    if (sb.isSignedIn == false) return BookmarkIcon().normal;
    return StreamBuilder(
      stream:
          FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
      builder: (context, AsyncSnapshot snap) {
        if (uid == null) return BookmarkIcon().normal;
        if (!snap.hasData) return BookmarkIcon().normal;
        List d = snap.data[_type];

        if (d.contains(timestamp)) {
          return BookmarkIcon().bold;
        } else {
          return BookmarkIcon().normal;
        }
      },
    );
  }

  Widget build(BuildContext context) {
    final sb = context.watch<SignInBloc>();
    if (sb.isSignedIn == false) return BookmarkIcon().normal;
    return FutureBuilder<bool>(
      future: getData(),
      // FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.data ?? false)
          return BookmarkIcon().bold;
        else
          return BookmarkIcon().normal;
      },
    );
  }

  Future<bool> getData() async {
    final uri = Uri.http(Api.domain, Api.path + '/bookmark/check',
        {'user_id': uid, 'object_id': objectId.toString()});

    final response = await http.get(uri);

    print("UID : " + uid.toString());
    // final response = await http.get(Uri.parse(link));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var _snapshot = jsonDecode(response.body);
      // return _snapshot;
      return _snapshot['status'];
      // var snapshot = _snapshot['data'] as List;

      // _data = snapshot.map<Place>((json) => Place.fromJson(json)).toList();
    }
    return false;
  }
}
