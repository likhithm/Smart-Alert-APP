import 'package:flutter/material.dart';

class TaskDateState extends InheritedWidget {
  const TaskDateState({
    Key key,
    @required this.taskDate,
    @required this.onPress,
    @required Widget child,
  }) : assert(onPress != null),
        assert(child != null),
        super(key: key, child: child);

  final DateTime taskDate;
  final Function onPress;

  static TaskDateState of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(TaskDateState);
  }

  @override
  bool updateShouldNotify(TaskDateState old) => taskDate != old.taskDate;
}