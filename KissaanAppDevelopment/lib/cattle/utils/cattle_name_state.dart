import 'package:flutter/material.dart';

class CattleNameState extends InheritedWidget {
  const CattleNameState({
    Key key,
    @required this.controller,
    @required Widget child,
  }) : assert(child != null),
       super(key: key, child: child);

  final TextEditingController controller;

  static CattleNameState of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(CattleNameState);
  }

  @override
  bool updateShouldNotify(CattleNameState old) => controller != old.controller;
}