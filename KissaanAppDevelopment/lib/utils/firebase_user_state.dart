import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseUserState extends InheritedWidget {
  const FirebaseUserState({
    Key key,
    @required this.currentUser,
    @required Widget child,
  }) : assert(currentUser != null),
       assert(child != null),
       super(key: key, child: child);

  final FirebaseUser currentUser;

  static FirebaseUserState of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(FirebaseUserState);
  }

  @override
  bool updateShouldNotify(FirebaseUserState old) => currentUser != old.currentUser;
}