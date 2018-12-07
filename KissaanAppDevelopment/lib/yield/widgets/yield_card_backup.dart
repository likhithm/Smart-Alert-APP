import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:intl/intl.dart';
import 'package:kissaan_flutter/cattle/model_classes/Animal.dart';
import 'package:kissaan_flutter/yield/model_classes/Yield.dart';
import 'package:kissaan_flutter/yield/utils/cattle_yield_state.dart';
import 'package:kissaan_flutter/yield/widgets/cattle_display_card.dart';
import 'package:kissaan_flutter/yield/widgets/yield_entry_card.dart';

class YieldCard extends StatefulWidget {
  final Animal animal;
  final Yield yield;
  final MaskedTextController controller;

  YieldCard(this.animal, this.controller, this.yield);

  @override
  State<StatefulWidget> createState() {
    return YieldCardState(animal, controller, yield);
  }
}

class YieldCardState extends State<YieldCard> {
  Animal animal;
  Yield yield;
  MaskedTextController _controller;
  
  YieldCardState(this.animal, this._controller, this.yield);
  double _value = 0.0;
  Color green = const Color.fromRGBO(91,190,133,1.0);

  @override
  void initState() {
    super.initState();
    _controller.updateMask("00.0");
  }

  void _onChange(double value) {
    setState(
      () {
      _value = value;
      }
    );
  }

  void _handleSubmission(String val) {
    double value = double.parse(val);
    if(value > 40) {
      value = 40.0;
      _controller.updateText(value.toString());
    }
    _value = value;;
    List<String> splitStr = value.toString().split('.');

    // _controller.text = splitStr[0] + '.' + 
    // (
    //   splitStr.length == 2
    //   ? splitStr[1][0]
    //   : '0'
    // );

  }
 
  void onTap(BuildContext context, String avgYield, double maxYield, double minYield) {
    showDialog(
      context: context,
      builder: (context) => CattleYieldState(
        value: _value,
        avgYield: avgYield,
        minYield: minYield,
        maxYield: maxYield,
        animal: animal,
        onPress: onTap,
        lastDate: "",
        onSliderChange: _onChange,
        onSubmit: _handleSubmission,
        controller: _controller,
        child: YieldEntryCard(),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
        .collection("yieldsAvg")
        .where("userID", isEqualTo: animal.userID)
        .where("animalName", isEqualTo: animal.animalName)
        .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data.documents.length == 0) {
          return Container();
         // return Text(AppLocalizations.of(context).avgYieldNoRecord);
        } else {
          String avgYield = snapshot
            .data
            .documents[0]
            .data["avgYield"];

          double minYield = double.parse(snapshot
            .data
            .documents[0]
            .data["minYield"]);

          double maxYield = double.parse(snapshot
            .data
            .documents[0]
            .data["maxYield"]);

          String lastDate;
          if (snapshot.data.documents[0].data.containsKey("lastYieldEntryDate")) {
            int ms = int.parse(snapshot.data.documents[0].data["lastYieldEntryDate"]);
            DateTime date = DateTime.fromMillisecondsSinceEpoch(ms);
            lastDate = DateFormat.yMd().format(date);
          } else {
            lastDate = "No Past Entries";
          }
          
          //return _buildCattleCard(avgYield, maxYield, minYield);
          return CattleYieldState(
            value: _value,
            avgYield: avgYield,
            minYield: minYield,
            maxYield: maxYield,
            lastDate: lastDate,
            animal: animal,
            onPress: onTap,
            onSliderChange: _onChange,
            onSubmit: _handleSubmission,
            controller: _controller,
            child: CattleDisplayCard(),
          );
        }
      },
    );
    
  }
}

