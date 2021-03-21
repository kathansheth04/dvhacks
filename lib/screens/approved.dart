import 'package:dvhacks/screens/dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(Approved());
}

class Approved extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Approved!',
      debugShowCheckedModeBanner: false,
      home: approved(),
    );
  }
}

class approved extends StatefulWidget {
  approved({Key key, this.title}) : super(key: key);
  final String title;
  @override
  approvedScreen createState() => approvedScreen();
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

class approvedScreen extends State<approved> {
  @override
  void initState() {
    super.initState();
  }

  noSuchMethod(Invocation i) => super.noSuchMethod(i);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double sizeheight(BuildContext context) =>
        MediaQuery.of(context).size.height;
    double sizewidth(BuildContext context) => MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(children: <Widget>[
        new Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('lib/assets/approve.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        new Container(
            decoration: BoxDecoration(),
            child: Container(
              alignment: Alignment.center,
              child: Card(
                clipBehavior: Clip.antiAlias,
                color: const Color(0xFF424359),
                margin: EdgeInsets.only(
                    left: sizewidth(context) * 0.15,
                    right: sizewidth(context) * 0.15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
                child: Container(
                  padding:
                      EdgeInsets.only(top: 30, left: 30, right: 30, bottom: 30),
                  child: Text(
                    "The food item scanned has the right amount of nutrients needed for your pet to maintain its health. As a you head back, make sure to record the information so your data is up to date.",
                    style: TextStyle(fontSize: 15, color: Colors.teal[200]),
                  ),
                ),
              ),
            )),
        Container(
            width: sizewidth(context) * 0.6,
            margin: EdgeInsets.only(
                top: sizeheight(context) * 0.7,
                right: sizewidth(context) * 0.15,
                left: sizewidth(context) * 0.2),
            child: RaisedButton.icon(
                icon: Icon(Icons.arrow_forward_ios_rounded),
                onPressed: (() => {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => dashboard()))
                    }),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0))),
                label: Text('Proceed',
                    style: TextStyle(color: Colors.black, fontSize: 17)),
                padding: const EdgeInsets.all(13.0),
                splashColor: Colors.lightBlue[100],
                color: const Color(0xFf66D5C1)))
      ]),
    );
  }
}
