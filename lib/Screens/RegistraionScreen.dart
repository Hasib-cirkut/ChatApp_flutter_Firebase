import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String email;
  String password;
  bool showSpinner = false;

  final _auth = FirebaseAuth.instance;

  void registerUser() async {
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }

    setState(() {
      showSpinner = true;
    });

    try {
      final newUser = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      if (newUser != null) {
        showSpinner = false;
        Navigator.pushNamed(context, '/chat');
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Container(
                margin: EdgeInsets.only(top: 30),
                child: Stack(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 3, top: 2),
                      child: Text(
                        'Flash Chat',
                        style: TextStyle(
                            color: Colors.black26,
                            fontSize: 50,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      'Flash Chat',
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 50,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 50),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            hintText: 'Email address', filled: true),
                        onChanged: (value) {
                          email = value;
                        },
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        textAlign: TextAlign.center,
                        obscureText: true,
                        keyboardType: TextInputType.visiblePassword,
                        decoration:
                            InputDecoration(hintText: 'Password', filled: true),
                        onChanged: (value) {
                          password = value;
                        },
                      ),
                    ),
                    Expanded(
                      child: RaisedButton(
                        elevation: 10,
                        onPressed: () {
                          registerUser();
                        },
                        child: Text('REGISTER'),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Already have an account?',
                            style: TextStyle(color: Colors.black38),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            child: Text(
                              'Login',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700),
                            ),
                            onTap: () {
                              Navigator.pushNamed(context, '/');
                            },
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }
}
