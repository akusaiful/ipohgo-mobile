import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:ipohgo/config/ad_config.dart';

class AdsBloc extends ChangeNotifier {
  int _clickCounter = 0;
  int get clickCounter => _clickCounter;

  bool? _adsEnabled = false;
  bool? get adsEnabled => _adsEnabled;

  bool _isAdLoaded = false;
  bool get isAdLoaded => _isAdLoaded;

  Future<bool?> checkAdsEnable() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore
        .collection('admin')
        .doc('ads')
        .get()
        .then((DocumentSnapshot snap) {
      bool? _enabled = snap['ads_enabled'];
      _adsEnabled = _enabled;
      notifyListeners();
    }).catchError((e) {
      debugPrint('error : $e');
    });
    return _adsEnabled;
  }

  void increaseClickCounter() {
    _clickCounter++;
    debugPrint('Clicks : $_clickCounter');
    notifyListeners();
  }

  //enable only one
  Future initiateAdsOnApp() async {
    await MobileAds.instance.initialize(); //admob
    //await FacebookAudienceNetwork.init();  //fb
  }

  //enable only one
  void loadAds() {
    if (_adsEnabled == true) {
      createInterstitialAdAdmob(); //admob
      //createInterstitialAdFb();      //fb
    }
  }

  //enable only one
  void initiateAds() {
    increaseClickCounter();
    showInterstitialAdAdmob(); //admob
    //showInterstitialAdFb();       //fb
  }

  //enable only one
  @override
  void dispose() {
    disposeAdmobInterstitial(); //admob
    //disposefbInterstitial();      //fb
    super.dispose();
  }

  // Admob Ads -- START --

  InterstitialAd? interstitialAdAdmob;

  void createInterstitialAdAdmob() {
    InterstitialAd.load(
        adUnitId: AdConfig().getAdmobInterstitialAdUnitId(),
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            debugPrint('$ad loaded');
            interstitialAdAdmob = ad;
            _isAdLoaded = true;
            notifyListeners();
          },
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('InterstitialAd failed to load: $error.');
            interstitialAdAdmob = null;
            _isAdLoaded = false;
            notifyListeners();
            loadAds();
          },
        ));
  }

  void showInterstitialAdAdmob() {
    if (_adsEnabled == true) {
      if (_clickCounter % AdConfig.userClicksAmountsToShowEachAd == 0) {
        if (interstitialAdAdmob != null) {
          interstitialAdAdmob!.fullScreenContentCallback =
              FullScreenContentCallback(
            onAdShowedFullScreenContent: (InterstitialAd ad) =>
                print('ad onAdShowedFullScreenContent.'),
            onAdDismissedFullScreenContent: (InterstitialAd ad) {
              debugPrint('$ad onAdDismissedFullScreenContent.');
              ad.dispose();
              interstitialAdAdmob = null;
              _isAdLoaded = false;
              notifyListeners();
              loadAds();
            },
            onAdFailedToShowFullScreenContent:
                (InterstitialAd ad, AdError error) {
              debugPrint('$ad onAdFailedToShowFullScreenContent: $error');
              ad.dispose();
              interstitialAdAdmob = null;
              _isAdLoaded = false;
              notifyListeners();
              loadAds();
            },
          );

          interstitialAdAdmob!.show();
          interstitialAdAdmob = null;
          notifyListeners();
        }
      }
    }
  }

  void disposeAdmobInterstitial() {
    if (_adsEnabled == true) {
      interstitialAdAdmob?.dispose();
    }
  }

  // Admob Ads -- END --

  // Fb Ads -- START --

  // void createInterstitialAdFb() {
  //   FacebookInterstitialAd.loadInterstitialAd(
  //     placementId: AdConfig().getFbInterstitialAdUnitId(),
  //     listener: (result, value) {
  //       debugPrint('ad result : $result');
  //       if (result == InterstitialAdResult.LOADED){
  //         _isAdLoaded = true;
  //         debugPrint('ads loaded');
  //         notifyListeners();
  //       }else if(result == InterstitialAdResult.DISMISSED && value["invalidated"] == true){
  //         _isAdLoaded = false;
  //         notifyListeners();
  //         debugPrint('ads dismissed or error : $result');
  //         loadAds();
  //       }
  //     }
  //   );
  // }

  // void showInterstitialAdFb() async{
  //   if(_adsEnabled == true){
  //     if(_clickCounter % AdConfig.userClicksAmountsToShowEachAd == 0){
  //       if(_isAdLoaded == true){
  //         await FacebookInterstitialAd.showInterstitialAd();
  //         _isAdLoaded = false;
  //         notifyListeners();
  //       }
  //     }
  //   }
  // }

  // Future disposefbInterstitial()async {
  //   if (_isAdLoaded == true) {
  //     FacebookInterstitialAd.destroyInterstitialAd();
  //     _isAdLoaded = false;
  //     notifyListeners();
  //   }
  // }

  // Fb Ads -- END --
}
