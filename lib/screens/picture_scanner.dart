import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dvhacks/algorithm.dart';
import 'package:dvhacks/screens/approved.dart';
import 'package:dvhacks/screens/rejected.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dvhacks/screens/splash.dart';
import 'package:dvhacks/screens/mldetection.dart';

class Detection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DetectionScreen(),
    );
  }
}

class DetectionScreen extends StatefulWidget {
  @override
  _DetectionScreenState createState() => _DetectionScreenState();
}

class _DetectionScreenState extends State<DetectionScreen> {
  File pickedImage;

  bool imageUploaded = false;

  Future pickImage() async {
    var tempStore = await ImagePicker().getImage(source: ImageSource.gallery);

    setState(() {
      pickedImage = File(tempStore.path);
      imageUploaded = true;
    });
  }

  CollectionReference firebase = Firestore.instance.collection("users");
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<double> existing = new List<double>();
  List<double> vals = new List<double>();

  var approvalResult = "";
  Future<void> evaluateFood() async {
    final FirebaseUser user = await auth.currentUser();
    final uid = user.uid;
    FirebaseVisionImage ourImage = FirebaseVisionImage.fromFile(pickedImage);
    TextRecognizer recognizeText = FirebaseVision.instance.textRecognizer();
    VisionText readText = await recognizeText.processImage(ourImage);
    List<String> variables = new List<String>();
    List<double> variableValues = new List<double>();
    for (TextBlock block in readText.blocks) {
      for (TextLine line in block.lines) {
        if (line.text.toLowerCase().contains("crude") ||
            line.text.toLowerCase().contains("moisture") ||
            line.text.toLowerCase().contains("fat") ||
            line.text.toLowerCase().contains("fiber") ||
            line.text.toLowerCase().contains("protein")) {
          variables.add(line.text);
        } else if (line.text.toLowerCase().contains("%")) {
          final intValue = int.parse(
              line.text.toLowerCase().replaceAll(RegExp('[^0-9]'), ''));
          double floatValues = intValue / 100.0;
          variableValues.add(floatValues);
        }
      }
    }
    print("Variables: ");
    print(variables);
    print("");
    print("values");
    print(variableValues);
    /*
     * Order of arrays: [protein, fat, fiber, moisture] 
     */
    return firebase
        .document(uid.toString())
        .get()
        .then((DocumentSnapshot snapshot) async {
      existing.add(double.parse(snapshot.data["protein"].toString()));
      existing.add(double.parse(snapshot.data["fat"].toString()));
      existing.add(double.parse(snapshot.data["fiber"].toString()));
      print("existing: " + existing.toString());
      vals = variableValues;
      approvalResult = purchaseDecision(vals, existing, "dog");
      print(approvalResult);
    });
  }

  Future<void> readText() async {
    FirebaseVisionImage ourImage = FirebaseVisionImage.fromFile(pickedImage);
    TextRecognizer recognizeText = FirebaseVision.instance.textRecognizer();
    VisionText readText = await recognizeText.processImage(ourImage);
    List<String> variables = new List<String>();
    List<double> variableValues = new List<double>();
    for (TextBlock block in readText.blocks) {
      for (TextLine line in block.lines) {
        if (line.text.toLowerCase().contains("crude") ||
            line.text.toLowerCase().contains("moisture") ||
            line.text.toLowerCase().contains("fat") ||
            line.text.toLowerCase().contains("fiber") ||
            line.text.toLowerCase().contains("protein")) {
          variables.add(line.text);
        } else if (line.text.toLowerCase().contains("%")) {
          final intValue = int.parse(
              line.text.toLowerCase().replaceAll(RegExp('[^0-9]'), ''));
          double floatValues = intValue / 10.0;
          variableValues.add(floatValues);
        }
      }
    }
    print("Variables: ");
    print(variables);
    print("");
    print("values");
    print(variableValues);
  }

  Future decode() async {
    FirebaseVisionImage ourImage = FirebaseVisionImage.fromFile(pickedImage);
    BarcodeDetector barcodeDetector = FirebaseVision.instance.barcodeDetector();
    List barCodes = await barcodeDetector.detectInImage(ourImage);

    for (Barcode readableCode in barCodes) {
      print(readableCode.displayValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFf66D5C1),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.black,
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => DetectionPortal()))),
        title: Text(
          'Petcare Analytics',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                  onTap: () async {
                    print("pressed");
                    await FirebaseAuth.instance.signOut().then((value) =>
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => splash())));
                  },
                  child: Icon(
                    Icons.portrait_rounded,
                    color: Colors.black,
                  )))
        ],
      ),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/assets/dashboardbg.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 100.0),
          imageUploaded
              ? Center(
                  child: Container(
                      height: 200.0,
                      width: 200.0,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: FileImage(pickedImage),
                              fit: BoxFit.cover))),
                )
              : Container(
                  margin: EdgeInsets.only(
                      top: 40,
                      left: 30,
                      right: 30,
                      bottom: MediaQuery.of(context).size.height * 0.1),
                  child: pickedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: Container(
                            color: const Color(0xFF424359),
                            child: SizedBox(
                              child: Image.file(pickedImage),
                              height: MediaQuery.of(context).size.height * 0.4,
                              width: MediaQuery.of(context).size.width * 0.9,
                            ),
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: Container(
                            color: const Color(0xFf66D5C1),
                            child: SizedBox(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.camera_alt,
                                    size: 50,
                                    color: Colors.black,
                                  ),
                                  Text("No image uploaded",
                                      style: TextStyle(color: Colors.black))
                                ],
                              ),
                              height: MediaQuery.of(context).size.height * 0.4,
                              width: MediaQuery.of(context).size.width * 0.9,
                            ),
                          ),
                        ),
                ),
          SizedBox(height: 10.0),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.41,
                bottom: 20,
                left: MediaQuery.of(context).size.width * 0.15),
            width: MediaQuery.of(context).size.width * 0.7,
            child: RaisedButton.icon(
                icon: Icon(Icons.check_box),
                onPressed: () {
                  evaluateFood().then((value) => {
                        if (approvalResult.toLowerCase() == "approve")
                          {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => approved()))
                          }
                        else
                          {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => rejected()))
                          }
                      });
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0))),
                label: Text('Evaluate',
                    style: TextStyle(color: Colors.black, fontSize: 17)),
                padding: const EdgeInsets.all(13.0),
                splashColor: Colors.lightBlue[100],
                color: const Color(0xFf66D5C1)),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.2,
                bottom: 20,
                left: MediaQuery.of(context).size.width * 0.15),
            width: MediaQuery.of(context).size.width * 0.7,
            child: RaisedButton.icon(
                icon: Icon(Icons.cloud_download),
                onPressed: pickImage,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0))),
                label: Text('Upload',
                    style: TextStyle(color: Colors.black, fontSize: 17)),
                padding: const EdgeInsets.all(13.0),
                splashColor: Colors.lightBlue[100],
                color: const Color(0xFf66D5C1)),
          ),
        ],
      ),
    );
  }
}

// Developers of petcare acknowledging credit to firebase ml vision documentation
