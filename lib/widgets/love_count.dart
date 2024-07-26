import 'dart:convert';
// import 'dart:math';

// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart' as http;
import 'package:ipohgo/config/api.dart';

class LoveCount extends StatelessWidget {
  final String collectionName;
  final int? id;
  final int? totalLike;
  const LoveCount(
      {Key? key,
      required this.collectionName,
      required this.id,
      required this.totalLike})
      : super(key: key);

  // Stream<http.Response> getRandomNumberFact() async* {
  //   yield* Stream.periodic(Duration(seconds: 5), (_) {
  //     return http.get(Uri.parse(Api.url + "stream"));
  //   }).asyncMap((event) async => await event);
  // }

  // Taking BuildContext to show SnackBar
  Stream getDataStream(BuildContext context) async* {
    // int i = 1;
    // while (i <= 10) {

    http.Response response =
        await http.get(Uri.parse(Api.url + "tour/like/" + id.toString()));

    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);

      print(response.body);

      print('Like data : ' + map['data'].toString());
      // Return the value received using yield keyword
      yield map['data'];
    }

    // Delay the next yield by 5 seconds
    // await Future.delayed(const Duration(seconds: 5));
    //   i++;
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          EvaIcons.heart,
          color: Colors.grey[500],
          size: 20,
        ),
        SizedBox(
          width: 5,
        ),
        StreamBuilder(
          stream: getDataStream(context),
          builder: (context, AsyncSnapshot snap) {
            // print('test');
            // print(snap.hasData);

            if (!snap.hasData)
              return Text(
                0.toString(),
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey),
              );

            // var data = jsonDecode(snap.data);
            return Text(
              totalLike.toString(),
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey),
            );
          },
        ),
        SizedBox(
          width: 5,
        ),
        Text(
          'people like this'.tr(),
          maxLines: 1,
          style: TextStyle(
              fontSize: 13, fontWeight: FontWeight.w500, color: Colors.grey),
        )
      ],
    );
  }
}
