import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kissaan_flutter/locale/locales.dart';

import 'package:kissaan_flutter/utils/image_process.dart';
import 'package:kissaan_flutter/tasks/utils/task_card_state.dart';
import 'package:kissaan_flutter/tasks/model_classes/task.dart';
import 'package:kissaan_flutter/utils/string_formatter.dart';
class TaskCard extends StatelessWidget {
  final StringFormatter formatter =  const StringFormatter();

  const TaskCard();

  Widget _buildTaskDetailSection(Task task, double width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Text(
                task.taskCategory + (task.taskType==""?"":"\n"+task.taskType),
                style: TextStyle(
                    fontWeight: FontWeight.w900
                ),
              ),
              constraints: BoxConstraints(maxWidth: width/4, minWidth: width/4),
            ),
            Divider(
              indent: 15.0,
            ),
            Container(
              child: Text(DateFormat.yMd().format(task.taskDate)),
              constraints: BoxConstraints(maxWidth: width/4, minWidth: width/4),
            ),
          ],
        ),
        Divider(),
        Container(
          width: 200.0,
          height: 100.0,
          child: Text(
            task.taskDescription,
            softWrap: true,
          )
        ),
      ],
    );
  }

  Widget _buildAnimalDetailSection(Task task, Color color) {
    return Column(
      children: <Widget>[
        CircleAvatar(
            child: binaryToImage(task.encodedImage, false),//Text(cattle.name),//
            minRadius: 30.0,
            maxRadius: 30.0,
            backgroundColor: color
        ),
        //binaryToImage(task.encodedImage, false),
        Text(formatter.nameFormatter(task.animalName))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    TaskCardState state = TaskCardState.of(context);
    Task task = state.task;
    bool value = state.isChecked;
    double width = MediaQuery.of(context).size.width;
    Color color;

    if(task.taskCategory == AppLocalizations.of(context).breeding)
      color = Color.fromRGBO(0, 121, 191, 1.0);
    else if(task.taskCategory == AppLocalizations.of(context).medication)
      color = Color.fromRGBO(228, 150, 175, 1.0);
    else if(task.taskCategory == AppLocalizations.of(context).delivery)
      color = Color.fromRGBO(100, 100, 100, 1.0);
    
    ThemeData theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 10.0, top: 5.0),
                constraints: BoxConstraints(
                  maxWidth: width/5.2, 
                  minWidth: width/5.2
                  ),
                child: _buildAnimalDetailSection(task, color)
              ),
              Divider(
                indent: 15.0,
              ),
              _buildTaskDetailSection(task, width),
              Divider(
                indent: 15.0,
              ),
              task.taskActionableYN?
              Container(
                constraints: BoxConstraints(maxWidth: width/6),
                child: Ink(
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.accentColor, width: 4.0),
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: InkWell(
                    //This keeps the splash effect within the circle
                    borderRadius: BorderRadius.circular(1000.0), //Something large to ensure a circle
                    onTap: () {
                      state.onCheck(value, state.task, state.seq);
                    },
                    child: Container(
                      constraints: BoxConstraints(maxHeight: 18.0, maxWidth: 18.0),
                      padding:EdgeInsets.all(5.0),
                      child: value
                      ? Icon(
                      Icons.check,
                      size: 5.0,
                      color: theme.accentColor,
                      )
                          : Container(),
                    ),

//                    Padding(
//                      padding:EdgeInsets.all(5.0),
//                      child: value
//                        ? Icon(
//                          Icons.check,
//                          size: 60.0,
//                          color: theme.accentColor,
//                        )
//                        : Container()
//                    ),
                  ),
                )
              )
              : Container(),
            ],
          ),
          Divider()
        ],
      ),
    );
  }

  Widget _buildTaskCheck(Color color, bool value, TaskCardState state) { 
    return Ink(
      decoration: BoxDecoration(
        border: Border.all(color: color, width: 4.0),
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: InkWell(
        //This keeps the splash effect within the circle
        borderRadius: BorderRadius.circular(1000.0), //Something large to ensure a circle
        onTap: () {
          state.onCheck(value, state.task, state.seq);
        },
        child: Padding(
          padding:EdgeInsets.all(5.0),
          child: value 
            ? Icon(
              Icons.check,
              size: 30.0,
              color: color,
            )
            : Container()
        ),
      ),
    );
  }
}