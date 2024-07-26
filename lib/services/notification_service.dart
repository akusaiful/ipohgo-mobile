import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../pages/notifications.dart';
import '../utils/next_screen.dart';
import '../utils/notification_dialog.dart';

class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  static const String fcmSubcriptionTopticforAll = 'all';

  Future _handleNotificationPermissaion() async {
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      debugPrint('User granted provisional permission');
    } else {
      debugPrint('User declined or has not accepted permission');
    }
  }

  Future initFirebasePushNotification(context) async {
    await _handleNotificationPermissaion();
    String? token = await _fcm.getToken();
    debugPrint('User FCM Token : $token}');

    RemoteMessage? initialMessage = await _fcm.getInitialMessage();

    debugPrint('inittal message : $initialMessage');
    if (initialMessage != null) {
      nextScreen(context, NotificationsPage());
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      debugPrint("onMessage: $message");
      showinAppDialog(
          context, message.notification!.title, message.notification!.body);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      nextScreen(context, NotificationsPage());
    });
  }

  Future<bool?> checkingPermisson() async {
    bool? accepted;
    await _fcm
        .getNotificationSettings()
        .then((NotificationSettings settings) async {
      if (settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional) {
        accepted = true;
      } else {
        accepted = false;
      }
    });
    return accepted;
  }

  Future subscribe() async {
    await _fcm.subscribeToTopic(fcmSubcriptionTopticforAll);
  }

  Future unsubscribe() async {
    await _fcm.unsubscribeFromTopic(fcmSubcriptionTopticforAll);
  }
}
