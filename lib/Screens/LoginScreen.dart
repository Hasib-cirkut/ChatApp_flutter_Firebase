import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        textAlign: TextAlign.center,
                        obscureText: true,
                        decoration:
                            InputDecoration(hintText: 'Password', filled: true),
                      ),
                    ),
                    Expanded(
                      child: RaisedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/chat');
                        },
                        child: Text('LOGIN'),
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
              flex: 4,
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }
}
