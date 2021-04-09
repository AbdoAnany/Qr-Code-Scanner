import 'dart:typed_data';
import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:scanner/appTheme.dart';
import 'package:scanner/provider_preferences.dart';
import 'package:scanner/screen/page_info.dart';
import '../components/items/product_item.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  late TextEditingController _inputController;
  final revirpod =
      ChangeNotifierProvider<UserPreference>((ref) => UserPreference());
  var data;
  Uint8List bytes = Uint8List(0);
  Path path = Path();
  String searchBy = 'name';
  var revirpod1 = FutureProvider((ref) => UserPreference().getData('', 'name'));
  @override
  void initState() {
    super.initState();
    this._inputController = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    final userPreferences = ChangeNotifierProvider<UserPreference>((ref)=>UserPreference());

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Container(
            height: 50,
            width: w * .7,
            decoration: BoxDecoration(
              color: Colors.white70,
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            child: Consumer(builder: (context, watch, _) {
              return TextField(
                controller: _inputController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.go,
                onSubmitted: (value) {
                  setState(() {
                    revirpod1 = FutureProvider((ref) => UserPreference()
                        .getData(_inputController.text, searchBy));
                    data = watch(revirpod1);
                  });
                },
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: AppTheme.a2,
                  ),
                  hintText: 'Please Input Your $searchBy',
                  hintStyle: TextStyle(fontSize: 15),
                ),
              );
            }),
          ),
          leading:   Consumer(builder: (context,watch,_){
            return  IconButton(
              icon: Icon(Theme.of(context).brightness == Brightness.light
                  ? Icons.brightness_4
                  : Icons.brightness_high),
              onPressed: () {
                Theme.of(context).brightness == Brightness.light
                    ? watch(userPreferences).changePreferences(2)
                    : watch(userPreferences).changePreferences(1);
              },
            );
          },),
          actions: [
            Tooltip(
              message: "Scan By Camera",
              child: Container(
                width: 30,
                color: Colors.transparent,
                child: IconButton(
                  onPressed: () => scanPhoto(),
                  icon: Icon(
                    Icons.camera,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Tooltip(
              message: "Scan from  Gallery",
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(5),
                      bottomRight: Radius.circular(5)),
                ),
                child: IconButton(
                  onPressed: () => scanPhoto(),
                  icon: Icon(
                    Icons.image,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              ListTile(
                title: Text("Search By : $searchBy",),
                trailing: PopupMenuButton<String>(
                  padding: EdgeInsets.zero,
                  onSelected: (value) => setState(() => searchBy = value),
                  itemBuilder: (context) => <PopupMenuEntry<String>>[
                    myPopupMenuItem('name', Icons.art_track),
                    myPopupMenuItem('price', Icons.attach_money),
                    myPopupMenuItem('barcode', Icons.qr_code),
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: AppTheme.a1,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15),
                      topLeft: Radius.circular(15)),
                ),
                child: Consumer(builder: (context, watch, _) {
                  data = watch(revirpod1);
                  return data.when(
                    data: (date) {
                      return date.isNotEmpty
                          ? viewerList(date)
                          : Center(
                              child: Text('Nothing Here',
                                  style: TextStyle(
                                    fontSize: 30,
                                    color: AppTheme.white,
                                    fontWeight: FontWeight.bold,
                                  )),
                            );
                    },
                    loading: () {
                      return Center(
                        child: CircularProgressIndicator(
                          backgroundColor: AppTheme.white,
                        ),
                      );
                    },
                    error: (e, stack) {
                      return Text(e.toString());
                    },
                  );
                }),
              ),
              SizedBox(height: 60,)
            ],
          ),
        ));
  }

  PopupMenuItem<String> myPopupMenuItem(String value, icons) {
    return PopupMenuItem<String>(
      value: value,
      child: ListTile(
        leading: Icon(icons, size: 25, color: AppTheme.a2),
        title: Text(value.toUpperCase(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            )),
      ),
    );
  }

  Widget viewerList(date) {
    return GridView.builder(
      itemCount: date.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        childAspectRatio: 0.75,
      ),
      itemBuilder: (context, index) =>
          Item(item: date[index],
            onPressed: () {print(2);}
            ,),
    );
  }
  Route _createRoute(page) {
    return PageRouteBuilder<SlideTransition>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var tween = Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset.zero);
        var curveTween = CurveTween(curve: Curves.ease);

        return SlideTransition(
          position: animation.drive(curveTween).drive(tween),
          child: child,
        );
      },
    );
  }
  Future<String> scan() async {
    String barcode = await scanner.scan();
    this._inputController.text = barcode;
    Uint8List result =
        await scanner.generateBarCode(this._inputController.text);
    setState(() {
      this.bytes = result;
    });
    return barcode;
  }

  Future<String> scanPhoto() async {
    String barcode = await scanner.scanPhoto();
    this._inputController.text = barcode;
    Uint8List result =
        await scanner.generateBarCode(this._inputController.text);
    setState(() {
      this.bytes = result;
    });
    return barcode;
  }

  Future _scanBytes() async {
    final _picker = ImagePicker();
    PickedFile pickedFile =
        (await _picker.getImage(source: ImageSource.camera))!;
    final File file = File(pickedFile.path);

    Uint8List bytes = file.readAsBytesSync();
    String barcode = await scanner.scanBytes(bytes);
    this._inputController.text = barcode;
  }
}
