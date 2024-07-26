import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:ipohgo/models/place.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ipohgo/config/config.dart';

class GoogleDrive extends StatelessWidget {
  const GoogleDrive({
    Key? key,
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
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(color: Colors.black38),
          SizedBox(
            height: 30,
          ),
          Text(
            'No Network? Prepare for a rainy day. Download our travel maps FREE for use when there is no network coverage.',
            style: TextStyle(fontWeight: FontWeight.normal),
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: ElevatedButton(
                onPressed: () {
                  _launchUrl(Config().googleDrive);
                },
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30))),
                child: Ink(
                    decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            colors: [Colors.blue, Colors.deepPurple]),
                        borderRadius: BorderRadius.circular(30)),
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.download_for_offline_outlined),
                            SizedBox(
                              width: 10,
                            ),
                            const Text(
                              'Offline Maps - Please Download Here',
                            ),
                          ],
                        )))),
          ),
        ],
      ),
    );
  }
}
