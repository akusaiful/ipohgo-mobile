import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';

openNotificationPermissionDialog(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text('Allow Notifications from Settings'),
            content: Text(
                'You need to allow notifications from your settings first to enable this'),
            actions: [
              TextButton(
                child: Text('Close'),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: Text('Open Settings'),
                onPressed: () {
                  Navigator.pop(context);
                  // AppSettings.openNotificationSettings();
                  AppSettings.openAppSettings(
                      type: AppSettingsType.notification);
                },
              ),
            ],
          ));
}
