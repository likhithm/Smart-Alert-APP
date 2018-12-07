import 'dart:async';
import 'dart:math';
import 'package:flutter/scheduler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kissaan_flutter/cattle/model_classes/Animal.dart';
import 'package:kissaan_flutter/cattle/screens/new_cattle_dialog.dart';
import 'package:kissaan_flutter/cattle/utils/cattle_page_body_state.dart';
import 'package:kissaan_flutter/cattle/widgets/cattleDetails.dart';
import 'package:kissaan_flutter/cattle/widgets/cattle_important_dates.dart';
import 'package:kissaan_flutter/cattle/widgets/eventSection.dart';
import 'package:kissaan_flutter/locale/locales.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CattleDisplay extends StatelessWidget {

  final Animal animal;
  final String animalID;
  final String docKey;
  final format = DateFormat('dd-MM-yyyy');


  CattleDisplay(this.animal, this.animalID, this.docKey);

  List<String> dataSet = new List();

  @override
  Widget build(BuildContext context) {
    Map strMap = {
      'Yes': AppLocalizations.of(context).yes,
      'No': AppLocalizations.of(context).no
    };
    Size size = MediaQuery.of(context).size;
    Widget _buildExpandedDataListTile() {
      return ListTile(
        title: Text(
          AppLocalizations.of(context).milking +
          ": " +
          (animal.isMilking != null ? strMap[animal.isMilking] : strMap["No"]),
          textAlign: TextAlign.left,
        ),
        subtitle: Text(AppLocalizations.of(context).description + ": " + animal.animalDescription),
      );
    }

    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width
      ),
      padding: const EdgeInsets.fromLTRB(10.0,20.0,10.0,0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.75
                  ),
                child: ExpansionTile(
                  title: CattleDetails(animal, animalID, size),
                  children: [
                    ImportantDates(animal),
                  _buildExpandedDataListTile(),
                  ],
                ),
              ),
             _buildEditButton(context)
            ],
          ),
          NewEventSection(docKey, animal, animalID),
          Divider(height: 20.0,),
        ]
      ),
    );
  }


  void updateSelectedAnimal(String animalID, Map<String, String> fields, BuildContext context) {
    CattlePageBodyState state = CattlePageBodyState.of(context);

    Firestore.instance
      .collection("animals")
      .document(animalID)
      .updateData(fields).then(
        (value) async {
          DocumentSnapshot updatedCattle = await Firestore.instance
            .collection("animals")
            .document(animalID)
            .get();
          state.onAnimalAdded(Animal.fromData(updatedCattle), animalID);
        }
      );
  }

  Future<Map<String, String>> getNewFieldValues(Animal animal, BuildContext context) {
    return Navigator.of(context)
      .push(
        MaterialPageRoute<Map<String,String>>(
          builder: (context) {
            return AddCattleDialog(animal: animal);
          },
        fullscreenDialog: true
      )
    );
  }

  Future<void> _openAddEntryDialog(Animal animal, String animalID, BuildContext context) async {
    Map<String, String> newFieldValues;
    newFieldValues = await getNewFieldValues(animal, context);

    if (newFieldValues != null) {
      updateSelectedAnimal(animalID, newFieldValues, context);
    }
  }

  void getSharedPreferences() async {
    dataSet.clear();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    DateTime dateTime = DateTime.now();
    String currDate = dateTime.day.toString() + "/"
        + dateTime.month.toString() + "/"
        + dateTime.year.toString().substring(2,4);
    List<String> allData = preferences.getStringList("animalYield");
    if(allData == null)
      return;
    for(int i = 0; i < allData.length; i++) {
      String data = allData[i];
      var splitData = data.split(" && ");
      if(splitData[0] == animalID && splitData[1] == currDate) {
        //setState(() {
          dataSet.addAll(splitData);
        //});
        break;
      }
    }
  }

  Widget _buildEditButton(BuildContext context) {
    return IconButton(
      color: Theme.of(context).accentColor,
      icon: Image.asset("assets/icons/edit_button.png"),
      iconSize: 37.0,
      onPressed: (){_openAddEntryDialog(animal, animalID, context);},
    );
  }
}