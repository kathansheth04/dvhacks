import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:dvhacks/screens/dashboard.dart';
import 'package:dvhacks/screens/mldetection.dart';
import 'package:dvhacks/screens/splash.dart';

class ConfirmationScreen extends StatelessWidget {
  final String file;

  ConfirmationScreen(this.file);

  @override
  Widget build(BuildContext context) {
    Future readText() async {
      FirebaseVisionImage ourImage = FirebaseVisionImage.fromFile(File(file));
      TextRecognizer recognizeText = FirebaseVision.instance.textRecognizer();
      VisionText readText = await recognizeText.processImage(ourImage);

      for (TextBlock block in readText.blocks) {
        for (TextLine line in block.lines) {
          print(line.text);
        }
      }
    }

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Stack(
        children: <Widget>[
          SizedBox.expand(
            child: Center(
              child: Image.file(File(file)),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: 120,
              padding: EdgeInsets.all(20.0),
              color: Color.fromRGBO(0, 0, 0, .3),
              child: Column(
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ButtonTheme(
                        height: 50,
                        child: Container(
                          padding: EdgeInsets.only(bottom: 20),
                          width: MediaQuery.of(context).size.width * 0.42,
                          child: RaisedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => dashboard()));
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0))),
                              child: Text('Done',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 17)),
                              padding: const EdgeInsets.all(13.0),
                              splashColor: Colors.lightBlue[100],
                              color: const Color(0xFFABF6D4)),
                        ),
                      ),
                      ButtonTheme(
                        height: 50,
                        child: Container(
                          padding: EdgeInsets.only(bottom: 20),
                          width: MediaQuery.of(context).size.width * 0.42,
                          child: RaisedButton(
                              onPressed: readText,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0))),
                              child: Text('Detect Text',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 17)),
                              padding: const EdgeInsets.all(13.0),
                              splashColor: Colors.lightBlue[100],
                              color: const Color(0xFFABF6D4)),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
