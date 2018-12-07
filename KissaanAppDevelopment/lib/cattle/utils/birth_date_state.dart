import 'package:flutter/material.dart';

class BirthDateState extends InheritedWidget {
  const BirthDateState({
    Key key,
    @required this.birthDate,
    @required this.onTap,
    @required Widget child,
  }) : assert(onTap != null),
       assert(child != null),
       super(key: key, child: child);

  final DateTime birthDate;
  final Function onTap;

  static BirthDateState of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(BirthDateState);
  }

  @override
  bool updateShouldNotify(BirthDateState old) => birthDate != old.birthDate;
}