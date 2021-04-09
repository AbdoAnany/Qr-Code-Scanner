// @dart=2.9

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:scanner/ad_State.dart';
import 'package:scanner/provider_preferences.dart';

import 'appTheme.dart';
import 'screen/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final infuture = MobileAds.instance.initialize();

  AdState(infuture);
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, watch) {
    final userPreference =
        ChangeNotifierProvider<UserPreference>((ref) => UserPreference());
    final userPreferences = watch(userPreference);
    ThemeMode _themeMode = userPreferences.themeMode;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Scanner',
      themeMode: _themeMode,
      theme: ThemeData(
        fontFamily: GoogleFonts.chelseaMarket(
                fontSize: 20, letterSpacing: 3, fontWeight: FontWeight.bold)
            .fontFamily,
        primarySwatch: Colors.teal,
        primaryColor: AppTheme.a1,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          size: 25,
          color: Color(0xff263238),
        ),
        accentColor: Color(0xff263238),
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.teal,
        primaryColor: Colors.deepPurple[900],
        accentColor: Color(0xff263238),
        brightness: Brightness.dark,
      ),
      home: Home(),
    );
  }
}
