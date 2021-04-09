import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:scanner/ad_State.dart';
import 'package:scanner/appTheme.dart';

import 'add.dart';
import 'generate.dart';
import 'search.dart';

class Home extends StatefulWidget {
  @override
  MyTabsState createState() => new MyTabsState();
}

class MyTabsState extends State<Home> {
  final infuture = MobileAds.instance.initialize();
  late BannerAd _bannerAd;
  void showBannerAd() {
    super.didChangeDependencies();
    final adState = AdState(infuture);
    _bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: 'ca-app-pub-4604195146685998/7924638549',
        request: AdRequest(),
        listener: adState.listener)
      ..load();
  }

  var _currentIndex = 0;

  List<Widget> tab = [
   new   Generate(),
    new Search(),
    new  AddProduct(),
  ];
  @override
  void initState() {
    super.initState();
    showBannerAd();
  }

  @override
  void dispose() {
    super.dispose();
    _bannerAd.dispose();
  }

  @override
  Widget build(BuildContext context) => SafeArea(
          child: Scaffold(
        body: SingleChildScrollView(
          child: Column(children: [
            _bannerAd!=null?  Container(
                width: _bannerAd.size.width.toDouble(),
                height:50,
                child: AdWidget(ad: _bannerAd,)):SizedBox(),
            Container(
              height: MediaQuery.of(context).size.height,
              child: tab[_currentIndex],
            ),

          ]),
        ),
        bottomNavigationBar: ConvexAppBar.badge(
          {},
          initialActiveIndex: 0,
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: AppTheme.mix4),
          backgroundColor: AppTheme.a2,
          color: AppTheme.white,
          items: [
            tabItem(Icons.home,"Home"),
            tabItem(Icons.search,"Search"),
            tabItem(Icons.post_add_rounded,"Add Product"),
          ],
          onTap: (index) => setState(() => _currentIndex = index),
        ),
      ));

  TabItem tabItem(icon,title)=>TabItem(icon: icon, title: title,);

}
