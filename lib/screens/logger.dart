import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dvhacks/screens/dashboard.dart';
import 'package:dvhacks/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(Logger());
}

class Logger extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weekly Logger',
      debugShowCheckedModeBanner: false,
      home: logger(),
    );
  }
}

class logger extends StatefulWidget {
  logger({Key key, this.title}) : super(key: key);
  final String title;
  @override
  loggerScreen createState() => loggerScreen();
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

class loggerScreen extends State<logger> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  noSuchMethod(Invocation i) => super.noSuchMethod(i);
  int _selectedIndex = 1;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Dashboard',
      style: optionStyle,
    ),
    Text(
      'Index 1: Logger',
      style: optionStyle,
    ),
  ];
  void _onItemTapped(int index) {
    setState(() {
      if (index == 0) {
        _selectedIndex = 0;
        Navigator.push(
            context, MyCustomRoute(builder: (context) => dashboard()));
      } else {
        _selectedIndex = 1;
        Navigator.push(context, MyCustomRoute(builder: (context) => logger()));
      }
    });
  }

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
        .catchError((error) => print("Failed to add user: $error"));
  }

  CollectionReference firebaseProtein =
      Firestore.instance.collection("protein");
  int length = 0;
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
        .updateData({
          'protein${length}': double.parse(protein).toString(),
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add fat info: $error"));
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
          'Information Center',
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
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Color(0xFF424359),
        unselectedItemColor: Colors.black26,
        backgroundColor: const Color(0xFf66D5C1),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(
                Icons.apps,
              ),
              label: "Dashboard"),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            label: "Information Center",
          )
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
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
                            top: MediaQuery.of(context).size.height * 0.21,
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
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            hintText: 'Enter fiber percent',
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
                        child: RaisedButton.icon(
                            onPressed: () {
                              this
                                  .upload(
                                      proteinController.text.trim(),
                                      fatController.text.trim(),
                                      fiberController.text.trim())
                                  .then((value) => {
                                        uploadProtein(
                                            proteinController.text.trim())
                                      });
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30.0))),
                            label: Text('Update',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 17)),
                            icon: Icon(Icons.supervised_user_circle,
                                color: Colors.black),
                            padding: const EdgeInsets.all(13.0),
                            splashColor: Colors.lightBlue[200],
                            color: const Color(0xFFABF6D4)),
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
