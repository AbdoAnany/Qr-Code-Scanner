


import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdState{
  Future<InitializationStatus>initialie;
  AdState(this.initialie);
  String get bannerID=>'ca-app-pub-4604195146685998/5845270114';

  AdListener get listener=>_listener;

  final AdListener _listener = AdListener(
    // Called when an ad is successfully received.
    onAdLoaded: (Ad ad) => print('Ad loaded.'),
    // Called when an ad request failed.
    onAdFailedToLoad: (Ad ad, LoadAdError error) {
      ad.dispose();
      print('Ad failed to load: $error');
    },
    // Called when an ad opens an overlay that covers the screen.
    onAdOpened: (Ad ad) => print('Ad opened.'),
    // Called when an ad removes an overlay that covers the screen.
    onAdClosed: (Ad ad) => print('Ad closed.'),
    // Called when an ad is in the process of leaving the application.
    onApplicationExit: (Ad ad) => print('Left application.'),
  );
}
