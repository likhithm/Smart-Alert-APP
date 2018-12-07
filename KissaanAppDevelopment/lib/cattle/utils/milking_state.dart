import 'package:flutter/material.dart';

class MilkingState extends InheritedWidget {
  const MilkingState({
      Key key,
      @required this.onTap,
      @required this.milking,
      @required this.enabled,
      @required Widget child
    }): assert(onTap != null),
        assert(child != null),
        super(child: child, key: key);

  final String milking;
  final Function onTap;
  final bool enabled;

  static MilkingState of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(MilkingState);
  }

  @override
  bool updateShouldNotify(MilkingState old) {
    return milking != old.milking || enabled != old.enabled;
  }}