import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:qrscan/qrscan.dart' as scanner;

import '../appTheme.dart';
import 'add.dart';

class Generate extends StatefulWidget {
  @override
  _GenrateState createState() => _GenrateState();
}

class _GenrateState extends State<Generate> {
  Uint8List bytes = Uint8List(0);
  late TextEditingController _inputController;
  late TextEditingController _outputController;

  @override
  initState() {
    super.initState();
    this._inputController = new TextEditingController();
    this._outputController = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "GENERATE",
          style: TextStyle(
            fontSize: 25,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => AddProduct())),
            icon: Icon(
              Icons.add,
              size: 30,
              color: Colors.white,
            ),
          )
        ],
      ),

      body: ListView(
        children: <Widget>[
          _qrCodeWidget(this.bytes, context),
          Container(
            margin: EdgeInsets.only(right: 20, left: 20, top: 10, bottom: 10),
            height: 50,
            child: TextField(
              controller: _inputController,
              cursorColor: AppTheme.a2,
              keyboardType: TextInputType.text,
              onSubmitted: (value) {
                setState(() {
                  generateBarCode(_inputController.text);
                });
              },
              decoration: InputDecoration(
                border: const OutlineInputBorder(gapPadding: 5),
                prefixIcon: Icon(
                  Icons.qr_code_scanner,
                  color: AppTheme.a2,
                  size: 50,
                ),
                labelStyle:
                    TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                labelText: "Barcode",
              ),
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _qrCodeWidget(Uint8List bytes, BuildContext context) {
    return Container(
      margin: EdgeInsets.all(30),
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.black,
                spreadRadius: 1,
                blurRadius: 10,
                offset: Offset(5, 10))
          ],
          borderRadius: BorderRadius.all(
            Radius.elliptical(25, 25),
          ),
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: AppTheme.mix4)),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(30),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 120,
                  child: bytes.isEmpty
                      ? Center(
                          child: Container(
                            height: 120,
                            width: 120,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              image: DecorationImage(
                                  image: AssetImage(
                                    'assets/qr.png',
                                  ),
                                  fit: BoxFit.cover),
                            ),
                          ),
                        )
                      : Center(
                          child: Image.memory(
                            bytes,
                          ),
                        ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 20,
                    left: 25,
                    right: 25,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Expanded(
                        flex: 5,
                        child: GestureDetector(
                          child: Text(
                            'remove',
                            style: TextStyle(
                                color: AppTheme.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          onTap: () {
                            this.setState(() {
                              this.bytes = Uint8List(0);
                              _inputController.clear();
                            });
                          },
                        ),
                      ),
                      Text(' |',
                          style: TextStyle(
                              color: AppTheme.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                      Expanded(
                        flex: 5,
                        child: GestureDetector(
                          onTap: () async {
                            SnackBar snackBar;
                            if (this.bytes.isNotEmpty) {
                              final success = await ImageGallerySaver.saveImage(
                                this.bytes,
                              );
                              if (success.toString().isNotEmpty) {
                                snackBar = new SnackBar(
                                    content: new Text(
                                        'Successful Preservation!  ${this._inputController.text}'));
                                Scaffold.of(context).showSnackBar(snackBar);
                              } else {
                                snackBar = new SnackBar(
                                    content: new Text('Save failed!'));
                              }
                            }
                          },
                          child: Text(
                            'save',
                            style: TextStyle(
                                color: AppTheme.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future scan() async {
    String barcode = await scanner.scan();
    this._outputController.text = barcode;
    Uint8List result =
        await scanner.generateBarCode(this._outputController.text);
    this.setState(() => this.bytes = result);
  }

  Future scanPhoto() async {
    String barcode = await scanner.scanPhoto();
    this._outputController.text = barcode;
    Uint8List result =
        await scanner.generateBarCode(this._outputController.text);
    this.setState(() => this.bytes = result);
  }

  Future scanPath(String path) async {
    String barcode = await scanner.scanPath(path);
    this._outputController.text = barcode;
  }

  Future generateBarCode(String inputCode) async {
    Uint8List result = await scanner.generateBarCode(inputCode);
    this.setState(() => this.bytes = result);
  }
}
