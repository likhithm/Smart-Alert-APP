import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kissaan_flutter/events/model_classes/event.dart';
import 'package:kissaan_flutter/locale/locales.dart';
class EventEntry extends StatelessWidget {
  final Event event;
  final format = new DateFormat('dd-MM-yyyy');

  EventEntry(this.event);

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.only(left: 20.0, top: 5.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    event.eventCategory + " - " + event.eventType,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Divider(
                    color: Colors.white,
                  ),
                  Text(
                    format.format(event.eventDate),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Divider(),
                  Text(
                    AppLocalizations.of(context).description,
                    style: TextStyle(fontWeight: FontWeight.bold),

                  ),
                  Text(
                    event.eventDescription
                  )
                ],
              ),
            ],
          ),
          Divider()
        ],
      )


    );
  }

}