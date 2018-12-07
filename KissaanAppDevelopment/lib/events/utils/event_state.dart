import 'package:flutter/material.dart';

class EventState extends InheritedWidget {
  const EventState({
    Key key,
    @required this.onTap,
    @required Widget child,
  }) : assert(onTap != null),
       assert(child != null),
       super(key: key, child: child);

  final Function onTap;

  static EventState of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(EventState);
  }

  @override
  bool updateShouldNotify(EventState old) => onTap != old.onTap;
}