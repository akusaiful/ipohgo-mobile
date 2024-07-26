import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:ipohgo/config/api.dart';
import 'package:device_information/device_information.dart';
import 'package:ipohgo/utils/fcm.dart';

class SignInBloc extends ChangeNotifier {
  SignInBloc() {
    checkSignIn();
    checkGuestUser();
    initPackageInfo();
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googlSignIn = new GoogleSignIn();
  final FacebookAuth _fbAuth = FacebookAuth.instance;
  final String defaultUserImageUrl =
      'https://www.seekpng.com/png/detail/115-1150053_avatar-png-transparent-png-royalty-free-default-user.png';
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  bool _guestUser = false;
  bool get guestUser => _guestUser;

  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;

  bool _hasError = false;
  bool get hasError => _hasError;

  String? _errorCode;
  String? get errorCode => _errorCode;

  String? _name;
  String? get name => _name;

  // id token from firebase
  String? _uid;
  String? get uid => _uid;

  String? _email;
  String? get email => _email;

  String? _imageUrl;
  String? get imageUrl => _imageUrl;

  // authorization token for auth user
  String? _token;
  String? get token => _token;

  // id user from mysql
  String? _id;
  String? get id => _id;

  String? _joiningDate;
  String? get joiningDate => _joiningDate;

  String? _signInProvider;
  String? get signInProvider => _signInProvider;

  String? timestamp;

  String _appVersion = '0.0';
  String get appVersion => _appVersion;

  String _packageName = '';
  String get packageName => _packageName;

  String? _fcmToken = '';
  String? get fcmToken => _fcmToken;

  void initPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    _appVersion = packageInfo.version;
    _packageName = packageInfo.packageName;
    notifyListeners();
  }

  Future signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googlSignIn.signIn();
    if (googleUser != null) {
      try {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        User userDetails =
            (await _firebaseAuth.signInWithCredential(credential)).user!;

        this._name = userDetails.displayName;
        this._email = userDetails.email;
        this._imageUrl = userDetails.photoURL;
        this._uid = userDetails.uid;
        this._signInProvider = 'google';

        // await setFcmToken();
        final SharedPreferences sp = await SharedPreferences.getInstance();
        this._fcmToken = sp.getString('fcmToken');
        print('Sign in token google : ' + this._fcmToken.toString());

        _hasError = false;
        notifyListeners();
      } catch (e) {
        _hasError = true;
        _errorCode = e.toString();
        notifyListeners();
      }
    } else {
      _hasError = true;
      notifyListeners();
    }
  }

  Future signInwithFacebook() async {
    User currentUser;
    final LoginResult facebookLoginResult = await FacebookAuth.instance
        .login(permissions: ['email', 'public_profile']);
    debugPrint('fb login result: ${facebookLoginResult.message}');
    if (facebookLoginResult.status == LoginStatus.success) {
      final _accessToken = await FacebookAuth.instance.accessToken;
      debugPrint('access token: $_accessToken');
      if (_accessToken != null) {
        try {
          final AuthCredential credential =
              FacebookAuthProvider.credential(_accessToken.token);
          final User user =
              (await _firebaseAuth.signInWithCredential(credential)).user!;
          // assert(user.email != null);
          // assert(user.displayName != null);
          // assert(!user.isAnonymous);
          await user.getIdToken();
          currentUser = _firebaseAuth.currentUser!;
          assert(user.uid == currentUser.uid);

          this._name = user.displayName;
          this._email = user.email;
          this._imageUrl = user.photoURL;
          this._uid = user.uid;
          this._signInProvider = 'facebook';

          _hasError = false;
          notifyListeners();
        } catch (e) {
          _hasError = true;
          _errorCode = e.toString();
          notifyListeners();
        }
      }
    } else {
      _hasError = true;
      _errorCode = 'cancel or error';
      notifyListeners();
    }
  }

  Future signInWithApple() async {
    final _firebaseAuth = FirebaseAuth.instance;
    final result = await TheAppleSignIn.performRequests([
      AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
    ]);

    if (result.status == AuthorizationStatus.authorized) {
      try {
        final appleIdCredential = result.credential!;
        final oAuthProvider = OAuthProvider('apple.com');
        final credential = oAuthProvider.credential(
          idToken: String.fromCharCodes(appleIdCredential.identityToken!),
          accessToken:
              String.fromCharCodes(appleIdCredential.authorizationCode!),
        );
        final authResult = await _firebaseAuth.signInWithCredential(credential);
        final firebaseUser = authResult.user!;

        this._uid = firebaseUser.uid;
        this._name =
            '${appleIdCredential.fullName!.givenName} ${appleIdCredential.fullName!.familyName}';
        this._email = appleIdCredential.email;
        this._imageUrl = firebaseUser.photoURL ?? defaultUserImageUrl;
        this._signInProvider = 'apple';

        debugPrint(firebaseUser.toString());
        _hasError = false;
        notifyListeners();
      } catch (e) {
        _hasError = true;
        _errorCode = e.toString();
        notifyListeners();
      }
    } else if (result.status == AuthorizationStatus.error) {
      _hasError = true;
      _errorCode = 'Appple Sign In Error! Please try again';
      notifyListeners();
    } else if (result.status == AuthorizationStatus.cancelled) {
      _hasError = true;
      _errorCode = 'Sign In Cancelled!';
      notifyListeners();
    }
  }

  Future<bool> checkUserExists() async {
    DocumentSnapshot snap = await firestore.collection('users').doc(_uid).get();
    if (snap.exists) {
      debugPrint('User Exists');
      return true;
    } else {
      debugPrint('new user');
      return false;
    }
  }

  Future<bool> checkUserExistsMysql() async {
    final uri =
        Uri.http(Api.domain, Api.path + '/auth/exists', {'email': _email});
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      var _snapshot = jsonDecode(response.body);
      if (_snapshot['data']) {
        debugPrint('User Exists');
        return true;
      }
      // print(_snapshot);
    }

    debugPrint('new user');
    return false;
    // DocumentSnapshot snap = await firestore.collection('users').doc(_uid).get();
    // if (snap.exists) {
    //   debugPrint('User Exists');
    //   return true;
    // } else {
    //   debugPrint('new user');
    //   return false;
    // }
  }

  Future saveToFirebase() async {
    final DocumentReference ref =
        FirebaseFirestore.instance.collection('users').doc(_uid);
    var userData = {
      'name': _name,
      'email': _email,
      'uid': _uid,
      'image url': _imageUrl,
      'joining date': _joiningDate,
      'loved blogs': [],
      'loved places': [],
      'bookmarked blogs': [],
      'bookmarked places': []
    };
    await ref.set(userData);
  }

  Future saveToMysql() async {
    final response = await http.post(
      Uri.parse(Api.url + 'auth/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'first_name': _name,
        'last_name': _name,
        'email': _email,
        'password': _email,
        'firebase_token': _uid,
        'fcm_token': _fcmToken,
        'avatar_url': _imageUrl,
        'joining date': _joiningDate,
        'loved blogs': [],
        'loved places': [],
        'bookmarked blogs': [],
        'bookmarked places': [],
        'sign_in_provider': _signInProvider,
        'phone': '-',
        'publish': 1,
        'term': 1,
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      _id = data['user_id'].toString();
      print(data);
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      //throw Exception('Failed to create album.');
      print('Failed to create user');
      print(response.body);
    }
    // final uri = Uri.http(Api.domain, Api.path + '/news', userData);
    // await http.post(uri);
  }

  Future getJoiningDate() async {
    DateTime now = DateTime.now();
    String _date = DateFormat('dd-MM-yyyy').format(now);
    _joiningDate = _date;
    notifyListeners();
  }

  Future saveDataToSP() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();

    await sp.setString('name', _name!);
    await sp.setString('email', _email!);
    await sp.setString('image_url', _imageUrl!);
    await sp.setString('uid', _uid!);
    await sp.setString('id', _id!);
    await sp.setString('token', _token!);
    // await sp.setString('joining_date', _joiningDate!);
    await sp.setString('sign_in_provider', _signInProvider!);

    // setFcmToken();
  }

  Future getDataFromSp() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    _name = sp.getString('name');
    _email = sp.getString('email');
    _imageUrl = sp.getString('image_url');
    _uid = sp.getString('uid');
    _id = sp.getString('id');
    _joiningDate = sp.getString('joining_date');
    _signInProvider = sp.getString('sign_in_provider');
    _fcmToken = sp.getString('fcmToken');
    notifyListeners();
  }

  Future getUserDatafromFirebase(uid) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((DocumentSnapshot snap) {
      this._uid = snap['uid'];
      this._name = snap['name'];
      this._email = snap['email'];
      this._imageUrl = snap['image url'];
      this._joiningDate = snap['joining date'];
      debugPrint(_name);
    });
    notifyListeners();
  }

  Future getUserDataFromMysql(token) async {
    final uri =
        Uri.http(Api.domain, Api.path + '/auth/profile', {'token': token});
    final response = await http.get(uri);

    // await http.get(uri).then((response) {
    //   var snap = jsonDecode(response.body);
    //   print(snap);
    //   // print(jsonDecode(response.body));
    // });
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var snap = data['data'];
      this._id = snap['id'].toString();
      this._name = snap['name'];
      this._email = snap['email'];
      this._imageUrl = snap['avatar_url'];
      this._joiningDate = snap['joining_date'];
      debugPrint(snap['name']);
    }

    notifyListeners();
  }

  Future signInWithMysql(username, password) async {
    // FirebaseMessaging _firebaseMessaging =
    //     FirebaseMessaging.instance; // Change here
    // _firebaseMessaging.getToken().then((token) {});

    // getFcmToken();

    final deviceName = await DeviceInformation.deviceModel;
    final response = await http.post(
      Uri.parse(Api.url + 'auth/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'email': username,
        'password': password,
        'device_name': deviceName,
        // 'fcm_token': fcmToken
      }),
    );

    print('Sign in ' + fcmToken.toString());

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      final user = data['user'];
      this._token = data['access_token'];

      this._id = user['id'].toString();
      this._name = user['first_name'];
      this._email = user['email'];
      this._imageUrl = user['avatar_url'];
      this._joiningDate = user['joining_date'];

      print(this._token);
      print(data);
    }

    notifyListeners();
  }

  Future setSignIn() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setBool('signed_in', true);
    _isSignedIn = true;
    notifyListeners();
  }

  void checkSignIn() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    _isSignedIn = sp.getBool('signed_in') ?? false;
    notifyListeners();
  }

  Future userSignout() async {
    if (_signInProvider == 'apple') {
      await _firebaseAuth.signOut();
    } else if (_signInProvider == 'facebook') {
      await _firebaseAuth.signOut().then((_) async => await _fbAuth.logOut());
    } else {
      await _firebaseAuth.signOut().then((_) async => _googlSignIn.signOut());
    }
  }

  Future afterUserSignOut() async {
    await clearAllData();
    _isSignedIn = false;
    _guestUser = false;
    notifyListeners();
  }

  Future setGuestUser() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setBool('guest_user', true);
    _guestUser = true;

    // register FCM token
    await http.post(
      Uri.parse(Api.url + 'device/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{'fcm_token': fcmToken}),
    );

    notifyListeners();
  }

  void checkGuestUser() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    _guestUser = sp.getBool('guest_user') ?? false;
    notifyListeners();
  }

  Future clearAllData() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.clear();
  }

  Future guestSignout() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setBool('guest_user', false);
    _guestUser = false;
    notifyListeners();
  }

  Future updateUserProfile(String newName, String newImageUrl) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();

    final response = await http.post(
      Uri.parse(Api.url + 'auth/update-profile'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'name': newName,
        'avatar_url': newImageUrl,
        'firebase_token': uid,
      }),
    );

    // FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(_uid)
    //     .update({'name': newName, 'image url': newImageUrl});

    // final uri = Uri.http(Api.domain, Api.path + '/auth/update-profile',
    //     {'firebase_token': uid, 'name': newName, 'avatar_uri': newImageUrl});
    // final response = await http.get(uri);
    print(response.body);
    if (response.statusCode == 200) {
      sp.setString('name', newName);
      sp.setString('image_url', newImageUrl);
      print(response);
      _name = newName;
      _imageUrl = newImageUrl;

      notifyListeners();
    }
  }

  Future<int> getTotalUsersCount() async {
    final String fieldName = 'count';
    final DocumentReference ref =
        firestore.collection('item_count').doc('users_count');
    DocumentSnapshot snap = await ref.get();
    if (snap.exists == true) {
      int itemCount = snap[fieldName] ?? 0;
      return itemCount;
    } else {
      await ref.set({fieldName: 0});
      return 0;
    }
  }

  Future increaseUserCount() async {
    await getTotalUsersCount().then((int documentCount) async {
      await firestore
          .collection('item_count')
          .doc('users_count')
          .update({'count': documentCount + 1});
    });
  }

  Future deleteUserDatafromDatabase() async {
    FirebaseFirestore _db = FirebaseFirestore.instance;
    await _db.collection('users').doc(uid).delete();
  }
}
