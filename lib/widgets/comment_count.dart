import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ipohgo/config/api.dart';

class CommentCount extends StatelessWidget {
  final String collectionName;
  final int? id;
  const CommentCount({Key? key, required this.collectionName, required this.id})
      : super(key: key);

  Stream<http.Response> getRandomNumberFact() async* {
    yield* Stream.periodic(Duration(seconds: 5), (_) {
      return http.get(Uri.parse(Api.url + "tour/review/" + id.toString()));
    }).asyncMap((event) async => await event);
  }

  // Taking BuildContext to show SnackBar
  Stream getDataStream() async* {
    http.Response response =
        await http.get(Uri.parse(Api.url + "tour/review/" + id.toString()));

    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);

      // Return the value received using yield keyword
      yield map['data']['total_review'];
    }
    // Delay the next yield by 5 seconds
    await Future.delayed(const Duration(seconds: 5));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: getDataStream(),
      builder: (context, AsyncSnapshot snap) {
        if (!snap.hasData)
          return Text(
            0.toString(),
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.w600, color: Colors.grey),
          );
        // var data = jsonDecode(snap.data);
        return Text(
          snap.data.toString(),
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.w500, color: Colors.grey),
        );
      },
    );
  }
}
