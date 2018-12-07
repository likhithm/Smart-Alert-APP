import 'package:flutter/material.dart';
import 'package:kissaan_flutter/tasks/model_classes/task.dart';

class TaskCardState extends InheritedWidget {
  const TaskCardState({
    Key key,
    @required this.task,
    @required this.onCheck,
    @required this.isChecked,
    @required Widget child,
    @required this.seq,
  }) : assert(onCheck != null),
        assert(task != null),
        assert(child != null),
        assert(seq != null),
        super(key: key, child: child);

  final Task task;
  final bool isChecked;
  final Function onCheck;
  final int seq;

  static TaskCardState of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(TaskCardState);
  }

  @override
  bool updateShouldNotify(TaskCardState old) => task != old.task || isChecked != old.isChecked;
}