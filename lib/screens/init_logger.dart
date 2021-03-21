import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dvhacks/screens/dashboard.dart';
import 'package:dvhacks/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(InitLogger());
}

class InitLogger extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Information',
      debugShowCheckedModeBanner: false,
      home: initLogger(),
    );
  }
}

class initLogger extends StatefulWidget {
  initLogger({Key key, this.title}) : super(key: key);
  final String title;
  @override
  initLoggerScreen createState() => initLoggerScreen();
}

class MyCustomRoute<T> extends MaterialPageRoute<T> {
  MyCustomRoute({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // Fades between routes. (If you don't want any animation,
    // just return child.)
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.0, 0.0),
        end: Offset.zero,
      ).animate(animation),
      child: child,
    );
  }
}

class initLoggerScreen extends State<initLogger> {
  @override
  void initState() {
    super.initState();
  }

  noSuchMethod(Invocation i) => super.noSuchMethod(i);
  int length;
  CollectionReference firebaseUser = Firestore.instance.collection("users");
  final FirebaseAuth auth = FirebaseAuth.instance;
  Future<void> upload(String protein, String fat, String fiber) async {
    final FirebaseUser user = await auth.currentUser();
    final uid = user.uid;
    return firebaseUser
        .document(uid.toString())
        .setData({
          'protein': double.parse(protein).toString(),
          'fat': double.parse(fat).toString(),
          'fiber': double.parse(fiber).toString()
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add info: $error"));
  }

  CollectionReference firebaseProtein =
      Firestore.instance.collection("protein");
  Future<void> getData() async {
    final FirebaseUser user = await auth.currentUser();
    final uid = user.uid;
    return firebaseProtein
        .document(uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      Map<String, dynamic> temp_list = documentSnapshot.data;
      print("goes through here");
      setState(() {
        length = temp_list.length + 1;
      });
      print(temp_list);
    });
  }

  Future<void> uploadProtein(String protein) async {
    final FirebaseUser user = await auth.currentUser();
    final uid = user.uid;
    return firebaseProtein
        .document(uid.toString())
        .setData({
          'protein1': double.parse(protein).toString(),
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add protein info: $error"));
  }

  TextEditingController proteinController = TextEditingController();
  TextEditingController fatController = TextEditingController();
  TextEditingController fiberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double sizeheight(BuildContext context) =>
        MediaQuery.of(context).size.height;
    double sizewidth(BuildContext context) => MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: Container(),
        backgroundColor: const Color(0xFf66D5C1),
        title: Text(
          'Information',
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
                            MaterialPageRoute(builder: (context) => login())));
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
            color: const Color(0xFF235866),
            image: DecorationImage(
              image: AssetImage('lib/assets/initLoggerBG.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        new Container(
            decoration: BoxDecoration(),
            child: SingleChildScrollView(
                child: new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: new Column(
                    children: [
                      new Container(
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.27,
                            bottom: 0,
                            left: 55,
                            right: 55),
                        child: TextFormField(
                          cursorColor: Colors.white,
                          style: TextStyle(color: Colors.white),
                          controller: proteinController,
                          decoration: new InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1, color: Colors.white),
                            ),
                            border: const OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 2.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            hintText: 'Enter protein percent ',
                            hintStyle: TextStyle(color: Colors.white),
                            labelStyle: TextStyle(color: Colors.white),
                            prefixIcon: Icon(
                              Icons.assignment_rounded,
                              color: Colors.white,
                            ),
                            contentPadding: new EdgeInsets.fromLTRB(
                              20.0,
                              10.0,
                              20.0,
                              10.0,
                            ),
                          ),
                          validator: (input) => input.isEmpty
                              ? 'You must fill out all fields'
                              : null,
                        ),
                      ),
                      new Container(
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.02,
                            bottom: 0,
                            left: 55,
                            right: 55),
                        child: TextFormField(
                          cursorColor: Colors.white,
                          style: TextStyle(color: Colors.white),
                          controller: fiberController,
                          decoration: new InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1, color: Colors.white),
                            ),
                            border: const OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 2.0),
                            ),
                            hintText: 'Enter fiber percent',
                            hintStyle: TextStyle(color: Colors.white),
                            labelStyle: TextStyle(color: Colors.white),
                            prefixIcon: Icon(
                              Icons.assignment_rounded,
                              color: Colors.white,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            contentPadding: new EdgeInsets.fromLTRB(
                              20.0,
                              10.0,
                              20.0,
                              10.0,
                            ),
                          ),
                          validator: (input) => input.isEmpty
                              ? 'You must fill out all fields'
                              : null,
                        ),
                      ),
                      new Container(
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.02,
                            bottom: 0,
                            left: 55,
                            right: 55),
                        child: TextFormField(
                          cursorColor: Colors.white,
                          style: TextStyle(color: Colors.white),
                          controller: fatController,
                          decoration: new InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1, color: Colors.white),
                            ),
                            border: const OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 2.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            hintText: 'Enter fat percent',
                            hintStyle: TextStyle(color: Colors.white),
                            labelStyle: TextStyle(color: Colors.white),
                            prefixIcon: Icon(
                              Icons.assignment_rounded,
                              color: Colors.white,
                            ),
                            contentPadding: new EdgeInsets.fromLTRB(
                              20.0,
                              10.0,
                              20.0,
                              10.0,
                            ),
                          ),
                          validator: (input) => input.isEmpty
                              ? 'You must fill out all fields'
                              : null,
                        ),
                      ),
                      new Container(
                        width: sizewidth(context) * 0.7,
                        margin: EdgeInsets.only(top: 40),
                        child: RaisedButton(
                            onPressed: () {
                              this
                                  .upload(
                                      proteinController.text.trim(),
                                      fatController.text.trim(),
                                      fiberController.text.trim())
                                  .then((value) => {
                                        uploadProtein(
                                                proteinController.text.trim())
                                            .then((value) => {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              dashboard()))
                                                })
                                      });
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30.0))),
                            child: Text('Update',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 17)),
                            padding: const EdgeInsets.all(13.0),
                            splashColor: Colors.lightBlue[200],
                            color: const Color(0xFF66D5C1)),
                      ),
                    ],
                  ),
                )
              ],
            ))),
      ]),
    );
  }
}
