import 'package:flutter/material.dart';
import 'package:kissaan_flutter/events/utils/event_state.dart';

class EventIcon extends StatefulWidget {

  EventIcon(this.name, this.category, this.localName);
  final String category;
  final String name;
  final String localName;

  @override
  _EventIconState createState() => _EventIconState();
}

class _EventIconState extends State<EventIcon> {
  bool selected;
  String iconPath;

  @override
  void initState() {
    super.initState();
    iconPath = "assets/icons/" + widget.name + ".png";
    selected = false;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    EventState state = EventState.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
      child: Column(children: <Widget>[
        Stack(
          alignment: Alignment.bottomRight,
          children: <Widget>[
            IconButton(
              padding: EdgeInsets.all(0.0),
              iconSize: 56.0,
              icon: Image.asset(iconPath),
              onPressed: () {
                setState(() {
                  selected = !selected;
                  state.onTap(selected, widget.name, widget.category);
                });
              }
            ),
            selected 
            ? Icon(
                IconData(
                  0xe86c, 
                  fontFamily: 
                  'MaterialIcons'
                ),
                color: theme.accentColor,
              ) 
          : Container()
        ],),
        
        Container(
          constraints: BoxConstraints(maxWidth: 93.0, minWidth: 93.0),
          child: Text(
            widget.localName,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: selected ? FontWeight.w500 : FontWeight.w300,
              fontSize: 12.0
            ),
          )
        )
      ],)
    );
  }
}