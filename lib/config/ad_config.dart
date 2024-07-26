import 'dart:io';

class AdConfig {


  static const int userClicksAmountsToShowEachAd  = 3;


  
  //-- Admob Ads --
  static const String admobAppIdAndroid = 'ca-app-pub-3940256099942544~3347511713';
  static const String admobAppIdiOS = 'ca-app-pub-3940256099942544~1458002511';

  // interstitial ad ids - admob
  static const String admobInterstitialAdUnitIdAndroid = 'ca-app-pub-3940256099942544/1033173712';
  static const String admobInterstitialAdUnitIdiOS = 'ca-app-pub-3940256099942544/4411468910';

  //-- Fb Ads --
  static const String fbInterstitialAdUnitIdAndroid = '19318634199191*************';
  static const String fbInterstitialAdUnitIdiOS = '1931863419919*************';




  // -- Don't edit these --
  
  String getAdmobAppId () {
    if(Platform.isAndroid){
      return admobAppIdAndroid;
    } 
    else{
      return admobAppIdiOS;
    }
  }


  String getAdmobInterstitialAdUnitId (){
    if(Platform.isAndroid){
      return admobInterstitialAdUnitIdAndroid;
    }
    else{
      return admobInterstitialAdUnitIdiOS;
    }
  }


  String getFbInterstitialAdUnitId (){
    if(Platform.isAndroid){
      return fbInterstitialAdUnitIdAndroid;
    }
    else{
      return fbInterstitialAdUnitIdiOS;
    }
  }

  
}
