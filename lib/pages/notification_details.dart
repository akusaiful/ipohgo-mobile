import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ipohgo/models/notification.dart';
import 'package:easy_localization/easy_localization.dart';

import '../widgets/html_body.dart';

class NotificationDetails extends StatelessWidget {
  final NotificationModel data;
  const NotificationDetails({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.5,
        title: Text('notification details').tr(),
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 30, bottom: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(CupertinoIcons.timer_fill,
                          size: 20, color: Colors.green),
                      SizedBox(
                        width: 3,
                      ),
                      Text(
                        data.createdAt,
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Icon(CupertinoIcons.person,
                          size: 20, color: Colors.green),
                      SizedBox(
                        width: 3,
                      ),
                      Text(
                        'Publish by ' + data.author!,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    data.title!,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 15, bottom: 20),
                    height: 3,
                    width: 300,
                    decoration:
                        BoxDecoration(color: Theme.of(context).primaryColor),
                  ),
                ],
              ),
            ),
            HtmlBodyWidget(
              content: data.description.toString(),
              isIframeVideoEnabled: true,
              isVideoEnabled: true,
              isimageEnabled: true,
              fontSize: null,
            ),
            SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }
}
