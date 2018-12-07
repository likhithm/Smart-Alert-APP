import 'package:flutter/material.dart';

class PurchaseDateState extends InheritedWidget {
  const PurchaseDateState({
    Key key,
    @required this.purchaseDate,
    @required this.onPress,
    @required Widget child,
  }) : assert(onPress != null),
       assert(child != null),
       super(key: key, child: child);

  final DateTime purchaseDate;
  final Function onPress;

  static PurchaseDateState of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(PurchaseDateState);
  }

  @override
  bool updateShouldNotify(PurchaseDateState old) => purchaseDate != old.purchaseDate;
}