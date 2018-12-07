import 'package:flutter/material.dart';

class CattlePageBodyState extends InheritedWidget {
  const CattlePageBodyState({
    Key key,
    @required this.onAnimalAdded,
    @required Widget child,
  }) : assert(onAnimalAdded != null),
       assert(child != null),
       super(key: key, child: child);

  final Function onAnimalAdded;

  static CattlePageBodyState of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(CattlePageBodyState);
  }

  @override
  bool updateShouldNotify(CattlePageBodyState old) => onAnimalAdded != old.onAnimalAdded;
}