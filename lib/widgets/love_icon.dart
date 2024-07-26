// import 'dart:convert';

// import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ipohgo/blocs/sign_in_bloc.dart';
import 'package:ipohgo/config/api.dart';
import 'package:ipohgo/models/icon_data.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class BuildLoveIcon extends StatelessWidget {
  final String collectionName;
  final String? uid;
  final int? objectId;
  final String? timestamp;

  const BuildLoveIcon(
      {Key? key,
      required this.collectionName,
      required this.uid,
      required this.objectId,
      required this.timestamp})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sb = context.watch<SignInBloc>();
    // String _type = collectionName == 'places' ? 'loved places' : 'loved blogs';
    if (sb.isSignedIn == false) return LoveIcon().normal;
    // final bool data = getData();
    // if (data) {}
    // print(data['status']);
    return FutureBuilder<bool>(
      future: getData(),
      // FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.data ?? false)
          return LoveIcon().bold;
        else
          return LoveIcon().normal;

        // var convertedData = jsonDecode(snapshot.data?.body);
        /*
        if (snapshot.connectionState == ConnectionState.waiting) {
          // return Center(child: Text('Please wait its loading...'));
          return LoveIcon().normal;
        } else {
          if (snapshot.hasError) {
            return LoveIcon().normal;
            // return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            if (snapshot.data ?? false)
              return LoveIcon().bold;
            else
              return LoveIcon().normal;
          }
        }
        */
        // return LoveIcon().bold;

        // return LoveIcon().normal;
        // if (uid == null) return LoveIcon().normal;
        // if (!snap.hasData) return LoveIcon().normal;
        // List d = snap.data[_type];

        // if (d.contains(timestamp)) {
        //   return LoveIcon().bold;
        // } else {
        //   return LoveIcon().normal;
        // }
      },
    );
  }

  Future<bool> getData() async {
    final uri = Uri.http(Api.domain, Api.path + '/tour/ilike',
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

  @override
  Widget _build(BuildContext context) {
    final sb = context.watch<SignInBloc>();
    // String _type = collectionName == 'places' ? 'loved places' : 'loved blogs';
    if (sb.isSignedIn == false) return LoveIcon().normal;
    return StreamBuilder<http.Response>(
      stream: checkLike(),
      // FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // var convertedData = jsonDecode(snapshot.data?.body);
          return LoveIcon().bold;
        }
        return LoveIcon().normal;
        // if (uid == null) return LoveIcon().normal;
        // if (!snap.hasData) return LoveIcon().normal;
        // List d = snap.data[_type];

        // if (d.contains(timestamp)) {
        //   return LoveIcon().bold;
        // } else {
        //   return LoveIcon().normal;
        // }
      },
    );
  }

  Stream<http.Response> checkLike() async* {
    final uri = Uri.http(Api.domain, Api.path + '/tour/ilike',
        {'user_id': uid, 'object_id': objectId.toString()});

    yield* Stream.periodic(Duration(seconds: 5), (_) {
      print('hello ' + uid.toString());
      return http.get(uri);
    }).asyncMap((event) async => await event);
  }

  // @override
  // Widget build(BuildContext context) {
  //   final sb = context.watch<SignInBloc>();
  //   String _type = collectionName == 'places' ? 'loved places' : 'loved blogs';
  //   if(sb.isSignedIn == false) return LoveIcon().normal;
  //   return StreamBuilder(
  //   stream: FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
  //   builder: (context, AsyncSnapshot snap) {
  //     if (uid == null) return LoveIcon().normal;
  //     if (!snap.hasData) return LoveIcon().normal;
  //     List d = snap.data[_type];

  //     if (d.contains(timestamp)) {
  //       return LoveIcon().bold;
  //     } else {
  //       return LoveIcon().normal;
  //     }
  //   },
  // );
  // }
}
