import 'dart:async';
import 'package:dvhacks/screens/authChooser.dart';
import 'package:dvhacks/screens/dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dvhacks/screens/login.dart';

void main() {
  runApp(Splash());
}

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Splash',
      debugShowCheckedModeBanner: false,
      home: splash(),
    );
  }
}

class splash extends StatefulWidget {
  splash({Key key, this.title}) : super(key: key);
  final String title;
  @override
  Body createState() => Body();
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

class Body extends State<splash> {
  @override
  void initState() {
    super.initState();
    startTime();
    authchecker();
  }

  startTime() async {
    var duration = new Duration(seconds: 3);
    return new Timer(duration, route);
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  bool loggedin;
  Future<void> authchecker() async {
    final FirebaseUser user = await auth.currentUser();
    if (user != null) {
      print(user.uid);
      setState(() {
        loggedin = true;
      });
    } else {
      setState(() {
        loggedin = false;
      });
    }
  }

  route() {
    if (loggedin == true) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => dashboard()));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => AuthChooser()));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // This size provide us total height and width of our screen
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/assets/welcomebg.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: size.height * 0.4),
                new Container(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(const Color(0xFf66D5C1)),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
