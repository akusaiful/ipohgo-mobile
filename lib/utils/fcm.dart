import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Future<String?> getFcmToken() {
//   // String token = '';
//   FirebaseMessaging _firebaseMessaging =
//       FirebaseMessaging.instance; // Change here
//   // _firebaseMessaging.getToken().then((token) {});
//   // _firebaseMessaging.getToken().then((token) {
//   //   print('Call token 2');
//   //   return token;
//   // });
//   return _firebaseMessaging.getToken();

//   // print('Call token 1');
//   // return token;
// }

// String getFcmToken() async{
//   final SharedPreferences sp = await SharedPreferences.getInstance();
//   return sp.getString('fcmToken').toString();
// }

Future setFcmToken() async {
  // String token = '';
  final SharedPreferences sp = await SharedPreferences.getInstance();
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  // _firebaseMessaging.getToken().then((token) {});
  // _firebaseMessaging.getToken().then((token) {
  //   print('Call token 2');
  //   return token;
  // });
  _firebaseMessaging.getToken().then((token) {
    sp.setString('fcmToken', token.toString());
    print('FCM Token ' + token.toString());
  });

  // print('Call token 1');
  // return token;
}
