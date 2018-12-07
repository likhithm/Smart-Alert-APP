import 'package:flutter/material.dart';
import 'package:kissaan_flutter/cattle/model_classes/Animal.dart';

class CattleState extends InheritedWidget {
  const CattleState({
    Key key,
    @required this.onTapAdd,
    @required this.onTapAll,
    @required this.onTapArchived,
    @required Widget child,
  }) : assert(onTapAdd != null),
       assert(child != null),
       super(key: key, child: child);

  final Function onTapAdd;
  final Function onTapAll;
  final Function onTapArchived;

  static CattleState of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(CattleState);
  }

  @override
  bool updateShouldNotify(CattleState old) => onTapAdd != old.onTapAdd;
}