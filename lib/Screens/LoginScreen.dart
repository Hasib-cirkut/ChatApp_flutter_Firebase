import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;

  String email;
  String password;
  bool showSpinner = false;

  void login() async {
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }

    setState(() {
      showSpinner = true;
    });

    try {
      final user = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      if (user != null) {
        showSpinner = false;
        Navigator.pushNamed(context, '/chat');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
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
                flex: 4,
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
                          decoration: InputDecoration(
                              hintText: 'Password', filled: true),
                          onChanged: (value) {
                            password = value;
                          },
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 20),
                          child: RaisedButton(
                            onPressed: () {
                              login();
                            },
                            child: Text('LOGIN'),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Don\'t have an account?',
                              style: TextStyle(color: Colors.black38),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              child: Text(
                                'Register',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700),
                              ),
                              onTap: () {
                                Navigator.pushNamed(context, '/registration');
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
                flex: 1,
                child: Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
