import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dvhacks/screens/authChooser.dart';
import 'package:dvhacks/screens/dashboard.dart';
import 'package:dvhacks/screens/init_logger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dvhacks/screens/login.dart';
import 'package:toggle_switch/toggle_switch.dart';

void main() {
  runApp(registerScreen());
}

class registerScreen extends StatelessWidget {
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
      home: register(title: 'Flutter Demo Home Page'),
    );
  }
}

class register extends StatefulWidget {
  register({Key key, this.title}) : super(key: key);

  final String title;

  @override
  RegisterScreen createState() => RegisterScreen();
}

final FirebaseAuth _auth = FirebaseAuth.instance;
TextEditingController _emailController = TextEditingController();
TextEditingController _passwordController = TextEditingController();

class RegisterScreen extends State<register> {
  String pet_type = "dog";
  Future<FirebaseUser> _handleSignUp(String email, String password) async {
    final FirebaseUser user = (await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    ))
        .user;
    print('Signed user up: ');
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => initLogger()));
  }

  CollectionReference firebaseUser = Firestore.instance.collection("pets");
  final FirebaseAuth auth = FirebaseAuth.instance;
  Future<void> upload(String pet) async {
    final FirebaseUser user = await auth.currentUser();
    final uid = user.uid;
    return firebaseUser
        .document(uid.toString())
        .setData({
          'pet': pet,
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  List<String> pets = new List<String>();
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double sizeheight(BuildContext context) =>
        MediaQuery.of(context).size.height;
    double sizewidth(BuildContext context) => MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(children: [
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF235866),
            image: DecorationImage(
              image: AssetImage('lib/assets/registerbg.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Form(
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              new Stack(
                alignment: Alignment.topLeft,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.05,
                        left: 30),
                    child: IconButton(
                      icon: Icon(Icons.arrow_left, size: 50),
                      color: Colors.white,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => authchooser()));
                      },
                    ),
                  )
                ],
              ),
              new Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.32,
                    bottom: 0,
                    left: 55,
                    right: 55),
                child: TextFormField(
                  controller: _emailController,
                  style: TextStyle(color: Colors.black),
                  cursorColor: Colors.black,
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
                margin:
                    EdgeInsets.only(top: 20, bottom: 0, left: 55, right: 55),
                child: TextFormField(
                  style: TextStyle(color: Colors.black),
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    labelStyle: TextStyle(color: Colors.black),
                    labelText: 'Password',
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
              new Container(
                margin:
                    EdgeInsets.only(top: 20, bottom: 0, left: 55, right: 55),
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
                        borderSide: BorderSide(color: Colors.black)),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                  obscureText: true,
                  validator: (input) =>
                      input.isEmpty ? 'You must enter a password' : null,
                ),
              ),
              new Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: 30.0, bottom: 20),
                child: ToggleSwitch(
                  minWidth: sizewidth(context) * 0.365,
                  initialLabelIndex: 0,
                  activeFgColor: Colors.white,
                  activeBgColor: Color(0xFF424359),
                  labels: ['Dog', 'Cat'],
                  onToggle: (index) {
                    setState(() {
                      pet_type = pets[index];
                    });
                    print('switched to: $index');
                  },
                ),
              ),
              Container(
                alignment: Alignment.bottomRight,
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.03, right: 50),
                child: FloatingActionButton(
                  onPressed: () {
                    this
                        ._handleSignUp(_emailController.text.trim(),
                            _passwordController.text.trim())
                        .then((value) => {upload(pet_type)});
                  },
                  child: Icon(Icons.arrow_right),
                  backgroundColor: Color(0xFF424359),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.05),
                child: InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => login()));
                    },
                    child: Text(
                      'Sign in with existing account!',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 20),
                    )),
              )
            ],
          ),
        )
      ]),
    );
  }
}
