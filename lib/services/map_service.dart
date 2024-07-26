import 'dart:io';
import 'package:ipohgo/utils/toast.dart';
import 'package:url_launcher/url_launcher.dart';

class MapService {
  MapService._();

  static Future<void> openMap(
      double latitude, double longitude, String placeId, context) async {
    final String googleUrlforIos =
        'comgooglemapsurl://www.google.com/maps/search/?api=1&query=$latitude$longitude&query_place_id=$placeId';
    final String googleUrlforAndroid =
        'https://www.google.com/maps/search/?api=1&query=$latitude$longitude&query_place_id=$placeId';
    final String appleUrl = 'https://maps.apple.com/?q=$latitude,$longitude';
    if (Platform.isAndroid) {
      final Uri uri = Uri.parse(googleUrlforAndroid);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        openToast1(context, 'Google Maps App is required for this action');
      }
    } else if (Platform.isIOS) {
      final Uri param = Uri.parse("comgooglemaps://");
      final Uri uri = Uri.parse(googleUrlforIos);
      final Uri uri1 = Uri.parse(appleUrl);
      if (await canLaunchUrl(param)) {
        await launchUrl(uri);
      } else {
        await launchUrl(uri1);
      }
    }
  }
}
