import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:ipohgo/config/config.dart';
import 'package:ipohgo/models/place.dart';
import 'package:url_launcher/url_launcher.dart';

class Parking extends StatelessWidget {
  final Place? place;
  const Parking({
    Key? key,
    required this.place,
  }) : super(key: key);

  Future<void> _launchUrl(String url) async {
    final Uri _url = Uri.parse(url);
    print(url);
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return place!.paidParking!
        ? Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(color: Colors.black38),
                SizedBox(
                  height: 30,
                ),
                Text(
                  'There is a paid parking space in this area. You can use the button below to make a payment',
                  style: TextStyle(fontWeight: FontWeight.normal),
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: ElevatedButton(
                      onPressed: () {
                        _launchUrl(Config().parkingParkPerak);
                      },
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30))),
                      child: Ink(
                          decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                  colors: [Colors.blue, Colors.red]),
                              borderRadius: BorderRadius.circular(30)),
                          child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.local_parking),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  const Text(
                                    'Paid with Park@Perak',
                                  ),
                                ],
                              )))),
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: ElevatedButton(
                      onPressed: () {
                        _launchUrl(Config().parkingFlexi);
                      },
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30))),
                      child: Ink(
                          decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                  colors: [Colors.cyan, Colors.green]),
                              borderRadius: BorderRadius.circular(30)),
                          child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.paid),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  const Text(
                                    'Paid with FlexiParking',
                                  ),
                                ],
                              )))),
                ),
              ],
            ),
          )
        : SizedBox.shrink();
  }
}
