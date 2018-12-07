import 'package:flutter/material.dart';

class AnimalTypeState extends InheritedWidget {
  const AnimalTypeState({
    Key key,
    @required this.animalType,
    @required this.onChanged,
    @required Widget child,
  }) : assert(child != null),
       super(key: key, child: child);

  final String animalType;
  final Function onChanged;

  static AnimalTypeState of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(AnimalTypeState);
  }

  @override
  bool updateShouldNotify(AnimalTypeState old) => animalType != old.animalType;
}