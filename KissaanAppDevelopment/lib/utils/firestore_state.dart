import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreState extends InheritedWidget {
  const FirestoreState({
    Key key,
    @required this.firestore,
    @required Widget child,
  }) : assert(firestore != null),
       assert(child != null),
       super(key: key, child: child);

  final Firestore firestore;

  static FirestoreState of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(FirestoreState);
  }

  @override
  bool updateShouldNotify(FirestoreState old) => firestore != old.firestore;
}