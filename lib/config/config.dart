import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Config {
  final String appName = 'IpohGo';
  final String mapAPIKey = 'AIzaSyDTqQdC5xd-LifeBzEkPDbY7rXM5RLUIXQ';
  final String countryName = 'Malaysia';
  final String splashIcon = 'assets/images/splash_ipohgo.png';
  final String supportEmail = 'ipohtourism@gmail.com';
  final String privacyPolicyUrl = 'https://ipohgo.net/web/public/privacy';
  final String iOSAppId = '000000';

  // parking
  final String parkingFlexi = 'https://a.lits.my/d.php?id=MBI';
  final String parkingParkPerak = 'https://a.lits.my/p.php?id=parkperak';

  final String yourWebsiteUrl = 'https://www.mbi.gov.my';
  final String facebookPageUrl = 'https://www.facebook.com/IpohTIC/';
  final String youtubeChannelUrl =
      'https://www.youtube.com/channel/UCmhJByHE05WJTDmyp-Yqi4Q';

  final String googleDrive =
      "https://drive.google.com/drive/folders/1yKPqht4R9zHaBjZ-HlxlD03WiDZm7wgy?usp=sharing";

  // app theme color - primary color
  static final Color appThemeColor = Colors.blueAccent;

  //special two states name that has been already upload from the admin panel
  final String specialState1 = 'Perak';
  final String specialState2 = 'Ipoh';

  //relplace by your country lattitude & longitude
  final CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(4.599684849497356, 101.07838891701732), //here
    zoom: 4,
  );

  //google maps marker icons
  final String hotelIcon = 'assets/images/hotel.png';
  final String restaurantIcon = 'assets/images/restaurant.png';
  final String hotelPinIcon = 'assets/images/hotel_pin.png';
  final String restaurantPinIcon = 'assets/images/restaurant_pin.png';
  final String drivingMarkerIcon = 'assets/images/driving_pin.png';
  final String destinationMarkerIcon =
      'assets/images/destination_map_marker.png';

  //Intro images
  final String introImage1 = 'assets/images/travel6.png';
  final String introImage2 = 'assets/images/travel1.png';
  final String introImage3 = 'assets/images/travel5.png';

  //Language Setup
  // final List<String> languages = ['English', 'Spanish', 'Arabic'];
  final List<String> languages = ['English'];

  static const String emptyImage =
      'https://innov8tiv.com/wp-content/uploads/2017/10/blank-screen-google-play-store-1280x720.png';
}
