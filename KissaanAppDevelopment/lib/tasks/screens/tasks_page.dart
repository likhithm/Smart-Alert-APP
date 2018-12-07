import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kissaan_flutter/locale/locales.dart';

import 'package:kissaan_flutter/tasks/model_classes/task.dart';
import 'package:kissaan_flutter/tasks/utils/task_card_state.dart';
import 'package:kissaan_flutter/tasks/widgets/task_card.dart';
import 'package:kissaan_flutter/tasks/widgets/task_dialog.dart';

class TasksPage extends StatefulWidget {
  final FirebaseUser currentUser;
  final String userID;
  TasksPage(this.currentUser, this.userID);
  @override
  State<StatefulWidget> createState() {
    return _TasksPageState();
  }
}

class _TasksPageState extends State<TasksPage> {
  List<Task> taskList = [];
  List<bool> checkedList = [];
  String docKey = "";

  @override
  void initState() {
    super.initState();
  }

  Widget _buildTasks() {
     return StreamBuilder<QuerySnapshot> (
      stream: Firestore.instance
        .collection("tasks")
        .where(
          'userID',
          isEqualTo:
          widget.userID
        )
        .snapshots(),
      builder: (_, AsyncSnapshot<QuerySnapshot> snap) {
        if (!snap.hasData) 
          return Text(AppLocalizations.of(context).loading);
        taskList.clear();

        for(DocumentSnapshot document in snap.data.documents) {
          Task task = Task.fromData(document);
          taskList.add(task);
          checkedList.add(false);
        }

        return _taskListViewSection();
      }
    );
  }

  Widget _taskListViewSection() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: taskList.length,
      padding: const EdgeInsets.only(top: 8.0),
      itemBuilder: (context, index) {
        return TaskCardState(
          child: const TaskCard(),
          task: taskList[index],
          onCheck: _onCheck,
          seq: index,
          isChecked: checkedList[index],
        );
      }
    );
  }

  void _onCheck (bool value, Task task, int seq) async {
    bool result;
    if (!value) {
      result = await _openEventDialog(task);
    }

    if (result != false) {
      value = !value;
      setState(() {
        checkedList[seq] = value;
      });
    }
  }


  Future _openEventDialog(Task task) async {
    Map<String, String> fields;
    fields = await Navigator.of(context)
        .push(MaterialPageRoute<Map<String,String>>(
          builder: (BuildContext context) {
            return TaskDialog(task);
          },
          fullscreenDialog: false
        )
    );
    if(fields != null && fields.containsKey('animalName')) {
      String id = task.userID +
          DateTime.now()
              .millisecondsSinceEpoch
              .toString();
      Firestore.instance
          .collection("animals")
          .document(id)
          .setData(fields);
      return true;
    }
    return false;
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    ThemeData theme = Theme.of(context);

    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return <Widget>[
          SliverOverlapAbsorber(
            handle: NestedScrollView
              .sliverOverlapAbsorberHandleFor(context),
            child: SliverAppBar(
              backgroundColor: theme.accentColor,
              pinned: true,
              title: Text(AppLocalizations.of(context).thingsToDo),
            )
          )
        ];
      },
      body: Container(
        constraints: BoxConstraints(maxHeight: size.height * 0.90),
        padding: const EdgeInsets.only(top: 100.0),
        child: _buildTasks() //_buildTaskView()
      ),
    );
  }
}