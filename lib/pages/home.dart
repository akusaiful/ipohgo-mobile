import 'dart:convert';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ipohgo/blocs/ads_bloc.dart';
import 'package:ipohgo/blocs/notification_bloc.dart';
import 'package:ipohgo/config/api.dart';
import 'package:ipohgo/pages/blogs.dart';
import 'package:ipohgo/pages/bookmark.dart';
import 'package:ipohgo/pages/contact.dart';
import 'package:ipohgo/pages/explore.dart';
import 'package:ipohgo/pages/profile.dart';
import 'package:provider/provider.dart';
import 'package:ipohgo/pages/states.dart';
import 'package:ipohgo/services/app_service.dart';
import 'package:ipohgo/utils/fcm.dart';
import 'package:ipohgo/utils/next_screen.dart';
import 'package:ipohgo/utils/snacbar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart' as http;
import '../services/notification_service.dart';
import 'package:mobile_number/mobile_number.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  PageController _pageController = PageController();

  String _mobileNumber = '';
  List<SimCard> _simCard = <SimCard>[];

  List<IconData> iconList = [
    Feather.home,
    Feather.grid,
    Feather.list,
    Feather.bookmark,
    Feather.user
  ];

  void onTabTapped(int index) {
    setState(() => _currentIndex = index);
    _pageController.animateToPage(index,
        curve: Curves.easeIn, duration: Duration(milliseconds: 100)); //300
  }

  Future configureAds() async {
    await context.read<AdsBloc>().initiateAdsOnApp();
    context.read<AdsBloc>().loadAds();
  }

  Future _initNotifications() async {
    await NotificationService()
        .initFirebasePushNotification(context)
        .then((value) => context.read<NotificationBloc>().checkPermission());
  }

  @override
  void initState() {
    super.initState();
    registerFcmToken();
    _initNotifications();
    AppService().checkInternet().then((hasInternet) {
      if (hasInternet == false) {
        openSnacbar(context, 'no internet'.tr());
      }
    });

    MobileNumber.listenPhonePermission((isPermissionGranted) {
      if (isPermissionGranted) {
        initMobileNumberState();
      } else {}
    });

    initMobileNumberState();

    Future.delayed(Duration(milliseconds: 0)).then((_) async {
      await context.read<AdsBloc>().checkAdsEnable().then((isEnabled) async {
        if (isEnabled != null && isEnabled == true) {
          debugPrint('ads enabled true');
          configureAds(); /* enable this line to enable ads on the app */
        } else {
          debugPrint('ads enabled false');
        }
      });
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initMobileNumberState() async {
    if (!await MobileNumber.hasPhonePermission) {
      await MobileNumber.requestPhonePermission;
      return;
    }
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      _mobileNumber = (await MobileNumber.mobileNumber)!;
      _simCard = (await MobileNumber.getSimCards)!;
      print('Mobile ' + _mobileNumber);
    } on PlatformException catch (e) {
      debugPrint("Failed to get mobile number because of '${e.message}'");
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {});
  }

  @override
  void dispose() {
    _pageController.dispose();
    //context.read<AdsBloc>().dispose();
    super.dispose();
  }

  Future _onWillPop() async {
    if (_currentIndex != 0) {
      setState(() => _currentIndex = 0);
      _pageController.animateToPage(0,
          duration: Duration(milliseconds: 300), curve: Curves.easeIn);
    } else {
      await SystemChannels.platform
          .invokeMethod<void>('SystemNavigator.pop', true);
    }
  }

  void registerFcmToken() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();

    // register FCM token
    await http.post(
      Uri.parse(Api.url + 'device/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body:
          jsonEncode(<String, dynamic>{'fcm_token': sp.getString('fcmToken')}),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => await _onWillPop(),
      child: Scaffold(
        appBar: AppBar(elevation: 0, toolbarHeight: 0),
        bottomNavigationBar: AnimatedBottomNavigationBar(
          // shape: const CircularNotchedRectangle(),
          icons: iconList,
          activeColor: Colors.blue,
          // gapLocation: GapLocation.none,
          activeIndex: _currentIndex,
          inactiveColor: Colors.grey[500],
          splashColor: Theme.of(context).primaryColor,
          backgroundColor: Colors.blueGrey[900],
          borderColor: Colors.blueGrey[700],
          // notchSmoothness: NotchSmoothness.verySmoothEdge,
          notchSmoothness: NotchSmoothness.defaultEdge,
          // leftCornerRadius: 10,
          // rightCornerRadius: 1,
          gapLocation: GapLocation.end,
          // gapLocation: GapLocation.center,

          // blurEffect: true,
          iconSize: 22,
          onTap: (index) => onTabTapped(index),
        ),
        body: PageView(
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            Explore(),
            StatesPage(),
            BlogPage(),
            BookmarkPage(),
            ProfilePage(),
          ],
        ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: FloatingActionButton(
          // backgroundColor: const Color.fromRGBO(82, 170, 94, 1.0),
          backgroundColor: Colors.blue[600],
          tooltip: 'Tourism Contact',
          // mini: true,
          onPressed: () => nextScreen(context, ContactPage()),
          child: const Icon(Icons.alt_route, color: Colors.white, size: 28),
        ),
      ),
    );
  }
}
