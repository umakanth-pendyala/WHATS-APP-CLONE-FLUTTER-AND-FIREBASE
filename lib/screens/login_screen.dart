import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
    googleSignIn.onCurrentUserChanged.listen((accountInfo) {
      print(accountInfo);
    }, onError: (err) {
      print('error : $err');
    });

    googleSignIn.signInSilently(suppressErrors: false).then((account) {
      print(account);
    }).catchError((err) {
      print('error $err');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        RaisedButton(
          onPressed: () {
            googleSignIn.signIn();
          },
          child: Text('Sign in with google'),
        ),
      ],
    );
  }
}
