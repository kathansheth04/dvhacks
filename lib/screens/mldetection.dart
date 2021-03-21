import 'package:dvhacks/screens/logger.dart';
import 'package:dvhacks/screens/splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DetectionPortal extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => DetectionPortalState();
}

class DetectionPortalState extends State<DetectionPortal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFf66D5C1),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.black,
            onPressed: () {}),
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
      body: Stack(children: <Widget>[
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('lib/assets/portalBG.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SingleChildScrollView(
          child: Column(
            children: <Widget>[
              new Container(
                alignment: Alignment.center,
                height: 250,
                width: 400,
                margin: EdgeInsets.only(left: 10),
                child: Card(
                    margin: EdgeInsets.only(
                        top: 50, left: 10, right: 10, bottom: 10),
                    clipBehavior: Clip.antiAlias,
                    color: Colors.white,
                    shadowColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                    child: new InkWell(
                        onTap: () {},
                        child: Column(children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                            child: ListTile(
                              title: new Container(
                                padding: EdgeInsets.only(top: 20),
                                child: Text(
                                  "Upload an Image",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18),
                                ),
                              ),
                              subtitle: new Container(
                                padding: EdgeInsets.only(top: 10),
                                child: Text(
                                  "These are pre-existing images that you can upload to the app to be logged into your pet's diet or to receive consideration on. Please ensure that the picture is clear so the values can be read properly. ",
                                  style: TextStyle(
                                    color: const Color(0xFF242525),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ]))),
              ),
              new Container(
                alignment: Alignment.center,
                height: 250,
                width: 400,
                margin: EdgeInsets.only(left: 13.25),
                child: Card(
                    margin: EdgeInsets.only(
                        top: 50, left: 10, right: 10, bottom: 10),
                    clipBehavior: Clip.antiAlias,
                    color: Colors.white,
                    shadowColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                    child: new InkWell(
                        onTap: () {},
                        child: Column(children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                            child: ListTile(
                              title: new Container(
                                padding: EdgeInsets.only(top: 20),
                                child: Text(
                                  "Take a picture",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18),
                                ),
                              ),
                              subtitle: new Container(
                                padding: EdgeInsets.only(top: 10),
                                child: Text(
                                  "If you prefer to take a picture of the nutrition label within the application, never having to leave, we have an embedded camera that you can use to scan and log the food which you are planning to buy! ",
                                  style: TextStyle(
                                    color: const Color(0xFF242525),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ]))),
              ),
              new Container(
                alignment: Alignment.center,
                height: 250,
                width: 400,
                margin: EdgeInsets.only(left: 13.25),
                child: Card(
                    margin: EdgeInsets.only(
                        top: 50, left: 10, right: 10, bottom: 10),
                    clipBehavior: Clip.antiAlias,
                    color: Colors.white,
                    shadowColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                    child: new InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => logger()));
                        },
                        child: Column(children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                            child: ListTile(
                              title: new Container(
                                padding: EdgeInsets.only(top: 20),
                                child: Text(
                                  "Update Log Information",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18),
                                ),
                              ),
                              subtitle: new Container(
                                padding: EdgeInsets.only(top: 10),
                                child: Text(
                                  "If you want to go back and change up your pets current eating conditions for us to better gauge your pet's health, click here to do so!",
                                  style: TextStyle(
                                    color: const Color(0xFF242525),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ]))),
              ),
            ],
          ),
        )
      ]),
    );
  }
}
