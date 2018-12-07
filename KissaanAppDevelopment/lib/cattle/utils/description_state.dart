import 'package:flutter/material.dart';

class DescriptionState extends InheritedWidget {

  const DescriptionState( {
    Key key,
    @required this.controller,
    @required Widget child
  }) : assert(child != null),
       super(key: key, child: child);

  final TextEditingController controller;

  static DescriptionState of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(DescriptionState);
  }

  @override
  bool updateShouldNotify(DescriptionState old) {
    return controller != old.controller;
  }

}