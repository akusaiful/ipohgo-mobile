class Api {
  // static const String domain = "ipohgo.net";
  // static const String path = '/web/public/api';
  // static const String url = "https://" + domain + path + "/";

  static const String domain = "ipohgo.my";

  // static const String domain = "10.11.0.153:8000";
  static const String path = '/web/public/api';
  static const String url = "https://" + domain + path + "/";

  String get uri => domain + path;
}
