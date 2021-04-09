import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scanner/provider_preferences.dart';
import '../appTheme.dart';
import '../provider_preferences.dart';
import 'dart:async';
import 'dart:typed_data';

class AddProduct extends StatefulWidget {
  @override
  AddProductState createState()=>AddProductState();
}

class AddProductState extends State<AddProduct> {
  late TextEditingController name,price,description,barcode;
  final revirpod =
  ChangeNotifierProvider<UserPreference>((ref) => UserPreference());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    price = new TextEditingController();
    barcode = new TextEditingController();
    name = new TextEditingController();
    description = new TextEditingController();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Add New Product",
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: [
            Consumer(builder: (context, watch, _) {
              final _scan = watch(revirpod);
              return Container(
                width: 50,
                child: IconButton(
                  onPressed: () => _scan.scanPhoto(barcode.text),
                  icon: Icon(Icons.image, color: Colors.white,),
                ),
              );
            }),
            Consumer(builder: (context, watch, _) {
              final _scan = watch(revirpod);
              return Container(
                width: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: IconButton(
                  onPressed: () => _scan.scan(),
                  icon: Icon(
                    Icons.settings_overscan, color: Colors.white,
                  ),
                ),
              );
            })
          ],
        ),
        body: Container(
          alignment: Alignment.topCenter,
           padding: EdgeInsets.only(top: 40),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                inputFiled(name,TextInputType.name,Icons.local_grocery_store, "Product Name",1,''),
                inputFiled(price,TextInputType.number, Icons.attach_money, "Price ",1,'EL'),
                inputFiled(barcode,TextInputType.number,Icons.qr_code_scanner, "Barcode",1,''),
                inputFiled(description,TextInputType.text,Icons.description, "Description (optional)",3,''),
                   Container(
                       decoration: BoxDecoration(
                           borderRadius: BorderRadius.all(Radius.circular(15)),
                           gradient: LinearGradient(
                               begin: Alignment.topLeft,
                               end: Alignment.bottomRight,
                               colors: AppTheme.mix41)),

                    margin: EdgeInsets.only(top: 40,bottom: 30),
                    child: Tooltip(
                      message: "Add New Product in System",
                      child: Consumer(builder: (context, watch, _) {
                        final add = watch(revirpod);
                        return  FloatingActionButton.extended(
                          backgroundColor: Colors.transparent,
                          icon:  Icon(Icons.add),
                          label: Text(
                            "Add Product",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            add.addProduct(
                                context, name, price, barcode, description);
                          },
                        );
                      } ,
                    ),

                  )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget inputFiled(name,textInputType,icon,labelText,line,suffixText){
    return     Container(
      margin:
      EdgeInsets.only(right: 20, left: 20, top: 10, bottom: 10),
      child: TextFormField(
        controller: name,
        keyboardType: textInputType,
        decoration: InputDecoration(
          border: const OutlineInputBorder(gapPadding: 5),
          prefixIcon: Icon(icon,),
          labelStyle:
          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          labelText: labelText,
          suffixText: suffixText,
        ),
        maxLines: line,
      ),
    );
  }
}
