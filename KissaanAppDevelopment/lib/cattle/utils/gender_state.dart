import 'package:flutter/material.dart';

class GenderState extends InheritedWidget {
  const GenderState({
    Key key,
    @required this.onTap,
    @required this.gender,
    @required Widget child,
  }) : assert(onTap != null),
       assert(child != null),
       super(key: key, child: child);

  final String gender;
  final Function onTap;

  static GenderState of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(GenderState);
  }

  @override
  bool updateShouldNotify(GenderState old) => gender != old.gender;
}