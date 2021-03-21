import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
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

  Future uploadImage() async {
    var tempStore = await ImagePicker().getImage(source: ImageSource.gallery);

    setState(() {
      pickedImage = File(tempStore.path);
      imageUploaded = true;
    });
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
                onPressed: () {},
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
                onPressed: uploadImage,
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
