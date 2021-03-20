import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dvhacks/screens/login.dart';
import 'package:dvhacks/screens/register.dart';

void main() {
  runApp(AuthChooser());
}

class AuthChooser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Splash',
      debugShowCheckedModeBanner: false,
      home: authchooser(),
    );
  }
}

class authchooser extends StatefulWidget {
  authchooser({Key key, this.title}) : super(key: key);
  final String title;
  @override
  authchooser_screen createState() => authchooser_screen();
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

class authchooser_screen extends State<authchooser> {
  @override
  void initState() {
    super.initState();
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
                  width: size.width * 0.75,
                  height: MediaQuery.of(context).size.height * 0.07,
                  child: RaisedButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => login()));
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(15.0))),
                      child: Text('Log in',
                          style: TextStyle(color: Colors.black, fontSize: 20)),
                      padding: const EdgeInsets.all(13.0),
                      splashColor: Color(0xFF7FDFB4),
                      color: Color(0xFf66D5C1)),
                ),
                new Container(
                  margin: EdgeInsets.only(top: 30),
                  width: size.width * 0.75,
                  height: MediaQuery.of(context).size.height * 0.07,
                  child: RaisedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => register()));
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(15.0))),
                      child: Text('Register',
                          style: TextStyle(color: Colors.black, fontSize: 20)),
                      padding: const EdgeInsets.all(13.0),
                      splashColor: Color(0xFf66D5C1),
                      color: Color(0xFF7FDFB4)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
