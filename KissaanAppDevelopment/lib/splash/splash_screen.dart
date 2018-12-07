import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kissaan_flutter/dashboard/screens/main_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  String docKey;

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new Image.asset('assets/icons/launch.png'),
      ),
    );
  }

  startTime() async {
    var _duration = new Duration(seconds: 1);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() async{
    //String path = '/auth';
    //FirebaseUser currUser = await FirebaseAuth.instance.currentUser();
    //if(currUser != null)
    //  path = '/dashboard';
    //Navigator.of(context).pushReplacementNamed(path);

    FirebaseAuth.instance.currentUser().then(
            (FirebaseUser user) async {
          if (user != null) {
            Firestore.instance
                .collection('users')
                .where('authUID', isEqualTo: user.uid)
                .limit(1)
                .getDocuments().then(
                    (value) {
                  if (value.documents[0].data != null) {
                    _finishSignIn(user);
                  }
                }
            );
          }
          else {
            Navigator.of(context)
                .pushNamedAndRemoveUntil(
                '/auth',
                    (Route<dynamic> route) => false
            );
          }
        }
    );
  }

  Future<bool> _onCodeVerified(FirebaseUser user) async {
    final isUserValid = (user != null &&
        (user.phoneNumber != null && user.phoneNumber.isNotEmpty));
    return isUserValid;
  }

  _finishSignIn(FirebaseUser user) async {
    await _onCodeVerified(user).then((result) async {
      if (result) {
        //TODO Do routing with named routes
        final QuerySnapshot results = await Firestore.instance.collection("users")
            .where("authUID", isEqualTo: user.uid)
            .limit(1)
            .getDocuments();

        if (results.documents.length == 0) {
          Navigator.of(context)
              .pushNamedAndRemoveUntil(
              '/auth',
                  (Route<dynamic> route) => false
          );
        }
        else if (results.documents[0].data["userName"] != null) {
          docKey = results.documents[0].documentID;
          Navigator.of(context)
              .pushReplacement(
              MaterialPageRoute(
                builder: (context) =>
                    MainScreen(
                        firebaseUser: user,
                        docKey: docKey,
                        userName:  results.documents[0].data['userName'].toString()
                    ),
              )
          );
        }
      }
      else {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(
            '/auth',
                (Route<dynamic> route) => false
        );
      }
    });
  }
}
