import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kissaan_flutter/cattle/model_classes/Animal.dart';
import 'package:kissaan_flutter/cattle/screens/new_cattle_dialog.dart';
import 'package:kissaan_flutter/cattle/widgets/event_entry.dart';
import 'package:kissaan_flutter/events/model_classes/event.dart';
import 'package:kissaan_flutter/events/screens/add_event_dialog.dart';
import 'package:kissaan_flutter/locale/locales.dart';

class NewEventSection extends StatelessWidget {
  final format = new DateFormat('dd-MM-yyyy');

  final Animal animal;
  final String animalID;
  final String docKey;

  NewEventSection(this.docKey, this.animal, this.animalID);

  @override
  Widget build(BuildContext context) {
    Future<void> _insertNewCattle() async {
      Map<String, String> fields;
      fields = await Navigator.of(context)
          .push(MaterialPageRoute<Map<String,String>>(
          builder: (BuildContext context) {
            return AddCattleDialog();
          },
          fullscreenDialog: true
      ));

      if (fields != null) {
        String id = docKey +
          DateTime
            .now()
            .millisecondsSinceEpoch
            .toString();
        Firestore.instance
          .collection("animals")
          .document(id)
          .setData(fields);
      }
    }
    Future _openAddEventDialog() async {
      List<String> events = await Navigator.of(context)
        .push(
          MaterialPageRoute<List<String>>(
            builder: (context) {
              return AddEventDialog(animal.gender);
            },
            fullscreenDialog: true
          )
        );

      if (events != null && events.isNotEmpty) {
        for (int i = 0; i < events.length - 1; i++) {
          String description = "";
          if (events.length == 2) {
            description = events[1];
          }

          String newEventDocumentID = animalID + DateTime.now()
            .millisecondsSinceEpoch
            .toString();

          //0: category, 1: type
          List<String> eventFields = events[i].split("+");
          Map<String, dynamic> fields = getFields(eventFields, i, description);

          Firestore.instance
            .collection("events")
            .document(newEventDocumentID)
            .setData(fields);

          if(eventFields[1] == "pregnancy") {
            final DocumentReference postRef = Firestore.instance
                .collection('animals')
                .document(animalID);
            Firestore.instance.runTransaction((Transaction tx) async {
              DocumentSnapshot postSnapshot = await tx.get(postRef);
              if (postSnapshot.exists) {
                await tx.update(postRef, <String, dynamic>{'isPregnant': true});
              }
            });
          }
          if(eventFields[0] == "Delivered") {
            final DocumentReference postRef = Firestore.instance
                .collection('animals')
                .document(animalID);
            Firestore.instance.runTransaction((Transaction tx) async {
              DocumentSnapshot postSnapshot = await tx.get(postRef);
              if (postSnapshot.exists) {
                await tx.update(postRef, <String, dynamic>{'isPregnant': false});
              }
            });
            if(eventFields[1].contains("Male") || eventFields[1].contains("Female"))
              await _insertNewCattle();
          }
          if(eventFields[1] == "Dead" || eventFields[1] == "Sold") {
            String status = eventFields[1];// == AppLocalizations.of(context).dead ? 'Dead' : "Sold";
            await _removeCattle(status);
          }
        }
      }
    }
    
    Widget _buildAddEventButton() {
      return IconButton(
        color: Theme.of(context).accentColor,
        icon: Image.asset("assets/icons/add.png"),
        iconSize: 37.0,
        onPressed: (){
          _openAddEventDialog();
        },
      );
    }
    Size size = MediaQuery.of(context).size;

    return Row(
      children: <Widget>[
        Container(
          constraints: BoxConstraints(maxWidth: size.width* 0.75),
          child: ExpansionTile(
            title: Text(AppLocalizations.of(context).event,
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600
              )
            ),
            children: <Widget>[
              _buildEventList(),
            ],
          ),
        ),
        _buildAddEventButton()
      ],
    );
  }


  Widget _buildEventListview(List<DocumentSnapshot> documents){
    return Container(
      constraints: BoxConstraints(
          maxHeight: documents.length < 3 ? 120.0 * documents.length : 360.0
      ),
      child: ListView.builder(
        padding: EdgeInsets.all(0.0),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: documents.length,
        itemBuilder: (BuildContext context, int index) {
          Event event = Event.fromData(documents[index]);
          return EventEntry(event);
        },
      ),
    );
  }

  Widget _buildEventList() {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
        .collection("events")
        .where("animalID", isEqualTo: animalID)
        .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return  Container();

        return _buildEventListview(snapshot.data.documents);
      },
    );
  }

  Map<String, dynamic> getFields(List<String> eventFields, int i, String description) {
    return { 
      "userID" : docKey,
      "animalID" : animalID,
      "eventDate" : eventFields[2] != "" 
        ? eventFields[2]
        : format.format(DateTime.now()),
      "eventType" : eventFields[1],
      "eventCategory" : eventFields[0],
      "eventDescription" : description
    };
  }

  Future<void> _removeCattle(String status) async {
    Firestore.instance
      .collection('animals')
      .document(animalID)
      .updateData({ 'animalStatus': status });
  } 
}