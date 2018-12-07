import 'package:flutter/material.dart';

class InsuranceState extends InheritedWidget {
  const InsuranceState({
    Key key,
    @required this.controller,
    @required Widget child,
  }) : assert(child != null),
        super(key: key, child: child);

  final TextEditingController controller;

  static InsuranceState of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(InsuranceState);
  }

  @override
  bool updateShouldNotify(InsuranceState old) => controller != old.controller;
}