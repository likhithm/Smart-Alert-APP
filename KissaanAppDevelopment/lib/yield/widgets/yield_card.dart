import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kissaan_flutter/cattle/model_classes/Animal.dart';
import 'package:kissaan_flutter/locale/locales.dart';
import 'package:kissaan_flutter/yield/model_classes/Yield.dart';
import 'package:kissaan_flutter/utils/image_process.dart';

class YieldCard extends StatefulWidget {
  final Animal animal;
  final Yield yield;
  final TextEditingController controller;

  YieldCard(this.animal, this.controller, this.yield);

  @override
  State<StatefulWidget> createState() {
    return YieldCardState(animal, controller, yield);
  }
}

class YieldCardState extends State<YieldCard> {
  Animal animal;
  Yield yield;
  String lastDateStr;
  TextEditingController _controller;
  final format = DateFormat('dd-MM-yyyy');

  YieldCardState(this.animal, this._controller, this.yield);
  double _value = 0.0;
  Color green = const Color.fromRGBO(91,190,133,1.0);

  @override
  void initState() {
    super.initState();
    setState(() {
      try {
        _value = double.parse(_controller.text.toString());
      }
      catch (e) {

      }
    });
  }

  void _onChange(double value, TextEditingController _textController, bool test) {
    setState(() {
      int decimals = 1;
      int fac = pow(10, decimals);
      value = (value * fac).round() / fac;
      if(value == 0) {

      }
      if(value > 30) {
        value = 30.0;
        if(!test)
          _controller.text = value.toString();

      }
      _value = value;
      if(!test) {
        _controller.text = value.toString();
      }
      //yield.yieldQty = value.toString();
    });
  }


  void _handleSubmission(String val) {
    double value = double.parse(val);
    if(value > 30) {
      value = 30.0;
      _controller.text = value.toString();
    }
    _value = value;
    _controller.text = value.toString();
    List<String> splitStr = value.toString().split('.');

    _controller.text = splitStr[0] + '.' + 
    (
      splitStr.length == 2
      ? splitStr[1][0]
      : '0'
    );

  }

  Widget _yieldSlider(double minYield, double maxYield) {
    Color activeColor;

    if (_value >= 0 && _value < minYield) {
      activeColor = Colors.yellow;
    } else if (_value > maxYield && _value <= 30) {
      activeColor = Colors.red;
    } else {
      activeColor = green;
    }

    return Slider(
      activeColor: activeColor,
      inactiveColor: Colors.black12,
      min: 0.0,
      max: 30.0,
      value: _value,
      onChanged: (double value){
        _onChange(value, _controller, false);
      }
    );
  }

  Widget _yieldUpperSection(String avgYield) {
    String name  =  animal.animalName.length > 20
      ? (animal.animalName.substring(0, 17) + "...") 
      : animal.animalName;

    return Row(
      children: <Widget>[
        Flexible(
          child: cattleImage(animal.encodedImage, animal.animalType), flex: 6,
        ),
        Expanded(
          child: ListTile(
            title: Text(
              name,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600
              ),
            ),
            subtitle: Text(
              avgYield != ""
                ? "${AppLocalizations.of(context).avgYield} $avgYield"
                : AppLocalizations.of(context).avgYieldNoRecord
              )
          ), flex: 18,
        ),
        Expanded(
          child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey)
              ),
              child: _yieldEditTxtSection()
          ), flex: 7,
        ),
      ]
    );
  }

  Widget _yieldEditTxtSection() {
    return Row(
      children: <Widget>[
        Flexible(child: Container(), flex: 1,),
        Flexible(
          child: TextField(
            keyboardType: TextInputType.number,
            controller: _controller,
            onChanged: (text) {
              _onChange(double.parse(text), _controller, true);
            },
            onSubmitted: _handleSubmission,
            decoration: const InputDecoration(
              hintText: "0.00",
              border: InputBorder.none,
            ),
          ), flex: 3,
        ),
        Flexible(
          child: const Text(
            'Ltr',
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 10.0
              )
          ), flex: 2,
        ),
      ],
    );
  }

  Widget _yieldSliderLabel() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('0'),
          const Text('30'),
        ],
      ),
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

          DateTime lastDate;

          try {
            int lastDateInMilliSecond = int.parse(snapshot
                .data
                .documents[0]
                .data['lastYieldEntryDate']);

            lastDate = DateTime.fromMillisecondsSinceEpoch(
                lastDateInMilliSecond);
          }
          catch(e) {
            lastDate = null;
          }

          try {
            lastDateStr = format.format(lastDate);
          }
          catch (e) {
            lastDateStr = AppLocalizations.of(context).avgYieldNoRecord;
          }

          double minYield = double.parse(snapshot
            .data
            .documents[0]
            .data["minYield"]);

          double maxYield = double.parse(snapshot
            .data
            .documents[0]
            .data["maxYield"]);
          
          bool isNormal = _value < maxYield && _value > minYield;

          return Card(
            elevation: 10.0,
            margin: const EdgeInsets.symmetric(
                horizontal: 15.0, 
                vertical:10.0
              ),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15.0, 
                vertical:10.0
              ),
              child: Column(
                children: <Widget>[
                  _yieldUpperSection(avgYield),
                  Row(
                    children: <Widget>[
                      Expanded(child: Container(),flex: 7),
                      Expanded(flex: 2, 
                        child: Text(
                          AppLocalizations.of(context).perDay,
                        style: const TextStyle(
                          fontSize: 12.0
                        ),
                      ),)
                  ],),
                  _yieldSlider(minYield, maxYield),
                  _yieldSliderLabel(),
                  isNormal ?
                    Text(
                      _value==0?
                        (AppLocalizations.of(context).lastDate+lastDateStr)
                        : ""
                    )
                    : Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          _value==0?
                            (AppLocalizations.of(context).lastDate+lastDateStr)
                            :AppLocalizations.of(context).yieldNotNormal
                        )
                      )

                ],
              ),
            ),
          );
        }
      },
    );
    
  }
}