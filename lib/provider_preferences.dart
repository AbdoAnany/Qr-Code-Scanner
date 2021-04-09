import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:scanner/ad_State.dart';
import 'package:scanner/appTheme.dart';
import 'package:qrscan/qrscan.dart' as scanner;

enum preferences { SystemPreference, Light, Dark }
enum revState { non, waiting, Done }

class UserPreference with ChangeNotifier {
  bool systemPreferenceSwitch = true, lightSwitch = false, darkSwitch = false;
  ThemeMode themeMode = ThemeMode.system;
  // Uint8List bytes = Uint8List(0);
  var  save1 = [];
  final urlPost = Uri.parse('https://morning-bayou-24260.herokuapp.com/post');
  late InterstitialAd _interstitialAd;

  Future<List> getData(input, searchBy) async {
   try{
     save1.clear();
     if (input.isEmpty) {
       http.Response response = await http
           .get(Uri.parse('https://morning-bayou-24260.herokuapp.com/get/all'));
       save1 = json.decode(response.body);

       revState.Done;
       notifyListeners();
       return save1;
     }
     else {
       revState.waiting;
       http.Response response = await http.
       get(Uri.parse('https://morning-bayou-24260.herokuapp.com/get/${searchBy}/${input}'));
       save1 = json.decode(response.body);
       notifyListeners();
       return save1;
     }
   }catch(e){
     return [];
   }
  }

  showInterstitialAd() {
    final infuture = MobileAds.instance.initialize();
    final adState = AdState(infuture);
    _interstitialAd = InterstitialAd(
        adUnitId: 'ca-app-pub-4604195146685998/5845270114',
        request: AdRequest(),
        listener: adState.listener);
    _interstitialAd
      ..load()
      ..show();
    notifyListeners();
  }

  Future addProduct(context, name, price, barcode, description) async {
    if (name.text.isEmpty || price.text.isEmpty || barcode.text.isEmpty) {
      showAlert("name , price & barcode are required", context);
      notifyListeners();
    } else {
      await http.post(urlPost, body: {
        "description": [description.text].toString(),
        "name": name.text.toString(),
        "price": int.tryParse(price.text).toString(),
        "barcode": barcode.text.toString()
      }).then((response) {
        if (response.statusCode == 200) showInterstitialAd();;
        showAlert("Product Added", context);
        notifyListeners();
      });
    }
    notifyListeners();
  }

  Future showAlert(String error, myContext) async {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: myContext,
        builder: (context) {
          return Container(
            width: MediaQuery.of(context).size.width / 2,
            height: 60,
            decoration: BoxDecoration(
                color: AppTheme.a2,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(50),
                    topLeft: Radius.circular(50))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  error,
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          );
        });
  }

  void changePreferences(selectedPreference) {
    print(selectedPreference);
    print(preferences.Dark);
    print("System preference" + systemPreferenceSwitch.toString());
    print(lightSwitch);
    print(darkSwitch);
    switch (selectedPreference) {
      case 0:
        systemPreferenceSwitch = true;
        lightSwitch = false;
        darkSwitch = false;
        themeMode = ThemeMode.system;
        break;
      case 1:
        systemPreferenceSwitch = false;
        lightSwitch = true;
        darkSwitch = false;
        themeMode = ThemeMode.light;
        break;
      case 2:
        systemPreferenceSwitch = false;
        lightSwitch = false;
        darkSwitch = true;
        themeMode = ThemeMode.dark;
        break;
      default:
    }
    notifyListeners();
  }

  Future<String> scan() async {
    String barcode = await scanner.scan();
    Uint8List result = await scanner.generateBarCode(barcode);
    notifyListeners();
    return barcode;
  }

  Future<String> scanPhoto(barcode) async {
    String barcode1 = await scanner.scanPhoto();
    barcode.text = barcode1;
    Uint8List result = await scanner.generateBarCode(barcode.text);
    notifyListeners();
    return barcode1;
  }

  Future _scanPath(String path) async {
    String barcode1 = await scanner.scanPath(path);
    notifyListeners();
    // barcode = barcode1;
  }
}
