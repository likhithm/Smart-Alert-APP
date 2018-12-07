import 'package:flutter/material.dart';
import 'package:kissaan_flutter/events/model_classes/event.dart';
import 'package:kissaan_flutter/cattle/widgets/event_entry.dart';
class EventList extends StatelessWidget {
  final List<Event> eventList;

  EventList(this.eventList);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: eventList.length,
      itemBuilder: (BuildContext context, int index) {
        return EventEntry(eventList[index]);
      },
    );
    // TODO: implement build
  }

}