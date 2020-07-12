import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

final Firestore userReference = Firestore.instance;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool userSigned = false;

  @override
  void initState() {
    super.initState();
    googleSignIn.onCurrentUserChanged.listen((accountInfo) {
      print(accountInfo);
      handleSign(accountInfo);
    }, onError: (err) {
      print('error : $err');
    });

    googleSignIn.signInSilently(suppressErrors: false).then((account) {
      // print(account);
      handleSign(account);
    }).catchError((err) {
      print('error $err');
    });
  }

  handleSign(account) {
    if (account != null) {
      setState(() {
        userSigned = true;
        manageFirebaseAccount();
      });
    } else {
      setState(() {
        userSigned = false;
      });
    }
  }

  manageFirebaseAccount() async {
    final CollectionReference users_db = userReference.collection('users');
    GoogleSignInAccount currentUser = googleSignIn.currentUser;
    print('${currentUser.id} is the data you are looking for');
    // final QuerySnapshot snapshot = await users_db
    //     .where('googleSignInId', isEqualTo: currentUser.id)
    //     .getDocuments();
    final DocumentSnapshot snapshot =
        await users_db.document(currentUser.id).get();
    if (snapshot.exists) {
      await addUserToFireBase(currentUser);
    }
  }

  addUserToFireBase(currentUser) async {
    final CollectionReference users_db = userReference.collection('users');
    await users_db.document('${currentUser.id}').setData({
      'displayName': currentUser.displayName,
      'email': currentUser.email,
      'photoUrl': currentUser.photoUrl,
    });
  }

  @override
  Widget build(BuildContext context) {
    // precacheImage(AssetImage("images/vector.jpg"), context);
    double margin = MediaQuery.of(context).size.height;

    Container userAuthScreen() {
      return Container(
        margin: EdgeInsets.only(top: 30.0),
        child: RaisedButton(
          onPressed: () => googleSignIn.signOut(),
          child: Text('sign out'),
        ),
      );
    }

    return userSigned
        ? userAuthScreen()
        : Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/login.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(
                    top: margin * 0.1,
                  ),
                  child: Image.asset(
                    'assets/images/vector.jpg',
                    height: 400,
                    width: 400,
                  ),
                ),
                Container(
                  child: RaisedButton(
                    padding: EdgeInsets.symmetric(
                      vertical: 30.0,
                    ),
                    color: Colors.deepOrangeAccent[700],
                    onPressed: () {
                      googleSignIn.signIn();
                    },
                    child: Text(
                      'Google sign in',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}

// Container(
//   child: Image.asset('assets/images/login.jpg'),
// ),
// RaisedButton(
//   onPressed: () {
//     googleSignIn.signIn();
//   },
//   child: Text('Sign in with google'),
// ),
// RaisedButton(
//   onPressed: () => googleSignIn.signOut(),
//   child: Text('sign out'),
// ),
