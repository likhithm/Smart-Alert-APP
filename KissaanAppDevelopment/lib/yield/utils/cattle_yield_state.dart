import 'package:flutter/material.dart';
import 'package:kissaan_flutter/cattle/model_classes/Animal.dart';

class CattleYieldState extends InheritedWidget {
  const CattleYieldState({
    Key key,
    @required this.animal,
    @required this.value,
    @required this.maxYield,
    @required this.minYield,
    @required this.avgYield,
    @required this.onPress,
    @required this.onSliderChange,
    @required this.controller,
    @required this.onSubmit,
    @required this.lastDate,
    @required Widget child,
  }) : assert(child != null),
       super(key: key, child: child);

  final Animal animal;
  final Function onPress;
  final Function onSubmit;
  final Function onSliderChange;
  final double maxYield;
  final double minYield;
  final String avgYield;
  final String lastDate;
  final TextEditingController controller;
  final double value;

  static CattleYieldState of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(CattleYieldState);
  }

  @override
  bool updateShouldNotify(CattleYieldState old) => animal != old.animal ||
    maxYield != old.maxYield ||
    minYield != old.minYield ||
    value != old.value ||
    avgYield != old.avgYield;
}