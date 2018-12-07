import 'package:flutter/material.dart';

class BreedState extends InheritedWidget {
  const BreedState({
    Key key,
    @required this.breed,
    @required this.breedsMap,
    @required this.breeds,
    @required this.onChanged,
    @required Widget child,
  }) : assert(onChanged != null),
       assert(breedsMap != null),
       assert(breed != null),
       assert(breeds != null),
       assert(child != null),
       super(key: key, child: child);

  final String breed;
  final List<String> breeds;
  final Map<String, String> breedsMap;
  final Function onChanged;

  static BreedState of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(BreedState);
  }

  @override
  bool updateShouldNotify(BreedState old) => breed != old.breed;
}