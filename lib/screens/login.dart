import 'package:dvhacks/screens/dashboard.dart';
import 'package:dvhacks/screens/register.dart';
import 'package:dvhacks/screens/splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(loginScreen());
}

class loginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          brightness: Brightness.light,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          scaffoldBackgroundColor: const Color(0xFF235866)),
      home: login(title: 'Flutter Demo Home Page'),
    );
  }
}

class login extends StatefulWidget {
  login({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  LoginScreen createState() => LoginScreen();
}

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
final FirebaseAuth _auth = FirebaseAuth.instance;

class LoginScreen extends State<login> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  Future<FirebaseUser> _handleSigninWithEmail(
      String email, String password) async {
    AuthResult authResult = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    final FirebaseUser user = authResult.user;

    //assert(user != null);
    //assert(await user.getIdToken() != null);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => dashboard()));
    print("Signed in user:");
    return user;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('lib/assets/loginbg.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        new Stack(
          alignment: Alignment.topLeft,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.07, left: 15),
              child: IconButton(
                icon: Icon(Icons.arrow_left, size: 50),
                color: Colors.white,
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => splash()));
                },
              ),
            )
          ],
        ),
        Form(
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              new Container(
                // Pad it such that the keyboard won't block the inputs
                padding: MediaQuery.of(context).viewInsets,
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.43,
                    bottom: 0,
                    left: 55,
                    right: 55),
                child: TextFormField(
                  controller: _emailController,
                  style: TextStyle(color: Colors.black),
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    labelStyle: TextStyle(color: Colors.black),
                    labelText: 'Email',
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                  validator: (input) =>
                      input.isEmpty ? 'You must enter a password' : null,
                ),
              ),
              new Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.02,
                    bottom: 0,
                    left: 55,
                    right: 55),
                child: TextFormField(
                  controller: _passwordController,
                  style: TextStyle(color: Colors.black),
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    labelStyle: TextStyle(color: Colors.black),
                    labelText: 'Confirm Password',
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                  obscureText: true,
                  validator: (input) =>
                      input.isEmpty ? 'You must enter a password' : null,
                ),
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Container(
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.05,
                            right: 30),
                        padding: EdgeInsets.only(
                          bottom: 20,
                        ),
                        child: ClipOval(
                          child: Material(
                            // Add color of the button (Keep white --> blends with bg)
                            color: Colors.white,
                            child: InkWell(
                              // inkwell color
                              child: SizedBox(
                                width: 70,
                                height: 70,
                                child: new Image.asset(
                                  'lib/assets/icon.png',
                                  width: 5,
                                  height: 5,
                                ),
                              ),
                              onTap: () {},
                            ),
                          ),
                        )),
                    new Container(
                        padding: EdgeInsets.only(
                          bottom: 20,
                        ),
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.05),
                        child: ClipOval(
                          child: Material(
                            color: Color(0xFF424359), // button color
                            child: InkWell(
                              child: SizedBox(
                                width: 70,
                                height: 70,
                                child: Icon(Icons.arrow_forward,
                                    color: Colors.white),
                              ),
                              onTap: () {
                                _handleSigninWithEmail(
                                    _emailController.text.trim(),
                                    _passwordController.text);
                              },
                            ),
                          ),
                        )),
                    SizedBox(width: 5),
                  ],
                ),
              ),
              new Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.05),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => registerScreen()));
                  },
                  child: Text(
                    'Create an account!',
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        )
      ]),
    );
  }
}
