import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  String userID;
  String animalID;
  String eventType;
  DateTime eventDate;
  String eventCategory;
  String eventDescription;

  Event(
      this.userID,
      this.animalID,
      this.eventType,
      this.eventDate,
      this.eventCategory,
      this.eventDescription,
      );

  Event.fromData(DocumentSnapshot document) {
    userID = document['userID'];
    animalID = document['animalID'];
    eventType = document['eventType'];
    eventDate = DateTime.fromMillisecondsSinceEpoch(int.parse(document['eventDate']));
    eventDescription = document['eventDescription'];
    eventCategory = document['eventCategory'];
  }
}