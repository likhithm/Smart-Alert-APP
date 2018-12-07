import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:kissaan_flutter/locale/locales.dart';
import 'package:kissaan_flutter/tasks/model_classes/task.dart';
import 'package:kissaan_flutter/tasks/utils/task_date_state.dart';
import 'package:kissaan_flutter/tasks/widgets/task_date_input_field.dart';
import 'package:kissaan_flutter/cattle/screens/new_cattle_dialog.dart';
class TaskDialog extends StatefulWidget {
  final Task task;
  TaskDialog(this.task);
  
  @override
  State<StatefulWidget> createState() {
    return TaskDialogState(task);
  }
}

class TaskDialogState extends State<TaskDialog> {
  final Task task;
  TaskDialogState(this.task);

  final format = new DateFormat('dd-MM-yyyy');
  DateTime taskDate = DateTime.now();
  TextEditingController desController = new TextEditingController();
  int _radioValue = 0, _radioValueT;
  bool checkPass = true;

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;
    });
  }
  void _handleRadioValueChangeT(int value) {
    setState(() {
      _radioValueT = value;
      switch(_radioValue) {
        case 0:
          checkPass = true;
          break;
        case 1:
          checkPass = false;
          break;
      }
    });
  }

  Widget _buildDelivery() {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Radio(
              value: 0,
              groupValue: _radioValue,
              onChanged: _handleRadioValueChange,
            ),
            Text(AppLocalizations.of(context).male)
          ],
        ),
        Row(
          children: <Widget>[
            Radio(
              value: 1,
              groupValue: _radioValue,
              onChanged: _handleRadioValueChange,
            ),
            Text(AppLocalizations.of(context).female)
          ],
        ),
        Row(
          children: <Widget>[
            Radio(
              value: 2,
              groupValue: _radioValue,
              onChanged: _handleRadioValueChange,
            ),
            Text(AppLocalizations.of(context).dead)
          ],
        ),
      ],
    );
  }

  Widget _buildPregTest() {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Radio(
              value: 0,
              groupValue: _radioValueT,
              onChanged: _handleRadioValueChangeT,
            ),
            Text(AppLocalizations.of(context).positive)
          ],
        ),
        Row(
          children: <Widget>[
            Radio(
              value: 1,
              groupValue: _radioValueT,
              onChanged: _handleRadioValueChangeT,
            ),
            Text(AppLocalizations.of(context).negative)
          ],
        ),
      ],
    );
  }

  Widget _buildContent() {
    switch (task.taskTypeCode) {
      case '0201':
        return _buildDelivery();
      case '0102':
        return _buildPregTest();
    }
    return Container();
  }

  Widget _buildDialogBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          task.taskCategory + ": " + task.taskType,
          style: TextStyle(
            fontWeight: FontWeight.w900
          ),
        ),
        TaskDateState(
          child: TaskDateInputField(),
          taskDate: taskDate,
          onPress: _selectDate,
        ),
        Container(
          child: _buildContent(),
        ),
        TextField(
          maxLength: 50,
          maxLines: 2,
          controller: desController,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(
                bottom: 10.0
            ),
            hintText: AppLocalizations.of(context).enterEventDesc,
            labelText: AppLocalizations.of(context).description,
            labelStyle: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w500
            )
          )
        )
      ],
    );
  }
  
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        firstDate: DateTime(1990),
        lastDate: DateTime(2025),
        initialDate: DateTime.now()
    );
    setState(() {
      taskDate = picked;
    });
  }

  void _onPressed() async{
    Map<String, String> fields;
    if(task.taskTypeCode == "0201" && _radioValue != 2) {
      fields = await _openAddEntryDialog();
      Firestore.instance.collection('animals')
          .document(task.animalID)
          .updateData({'isPregnant': false});
    }
    else if(task.taskTypeCode == '0102') {
      Firestore.instance.collection('animals')
          .document(task.animalID)
          .updateData({'isPregnant': checkPass});
    }
    _registerEvent();
    await Firestore.instance.collection("tasks")
        .document(task.taskID)
        .delete();
    Navigator.of(context).pop(fields);
  }

  void _registerEvent() {
    Map<String, dynamic> fields = new Map();
    fields['userID'] = task.userID;
    fields['animalID'] = task.animalID;
    fields['eventDate'] = taskDate.millisecondsSinceEpoch.toString();
    fields['eventType'] = _fetchEventType();
    fields['eventCategory'] = task.taskCategory;
    fields['eventDescription'] = desController.text.toString();
    fields['eventTypeCode'] = task.taskTypeCode;

    String newEventDocumentID = task.animalID + DateTime.now()
        .millisecondsSinceEpoch
        .toString();
    Firestore.instance
        .collection("events")
        .document(newEventDocumentID)
        .setData(fields);
  }

  String _fetchEventType() {
    String retStr = "";
    if(task.taskTypeCode == '0102') {
        if(checkPass)
          retStr =  AppLocalizations.of(context).pregnancyCheckPass;
        else
          retStr = AppLocalizations.of(context).pregnancyCheckFail;
    }
    else if (task.taskTypeCode == '0201') {
      if (_radioValue == 0)
        retStr = AppLocalizations.of(context).maleCalf;
      else if (_radioValue == 1)
        retStr = AppLocalizations.of(context).femaleCalf;
      else
        retStr = AppLocalizations.of(context).deadCalf;
    }
    else
      retStr = task.taskType;
    return retStr;
  }

  Future<Map<String, String>> _openAddEntryDialog() async {
    Map<String, String> fields;
    fields = await Navigator.of(context)
        .push(MaterialPageRoute<Map<String,String>>(
        builder: (BuildContext context) {
          return AddCattleDialog();
        },
        fullscreenDialog: true
    ));
    return fields;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context).eventRegister),
      content: _buildDialogBody(),
      actions: <Widget>[
        FlatButton(
          child: Text(AppLocalizations.of(context).confirm),
          onPressed: _onPressed,
        ),
        FlatButton(
          child: Text(AppLocalizations.of(context).cancel),
          onPressed: () {
            Map<String, String> fields = new Map();
            Navigator.of(context).pop(fields);
          },
        )
      ],
    );
  }
}