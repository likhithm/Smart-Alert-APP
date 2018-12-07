import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:kissaan_flutter/locale/locales.dart';
import 'package:kissaan_flutter/utils/image_process.dart';
import 'package:kissaan_flutter/yield/utils/cattle_yield_state.dart';

class YieldEntryCard extends StatefulWidget {
  @override
  _YieldEntryCardState createState() => _YieldEntryCardState();
}

class _YieldEntryCardState extends State<YieldEntryCard> {
  String avgYield;
  double maxYield;
  double minYield;

  double _value = 0.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CattleYieldState state = CattleYieldState.of(context);
    avgYield = state.avgYield;
    maxYield = state.maxYield;
    minYield = state.minYield;

    bool isNormal = _value <= maxYield && _value >= minYield;
    Size size = MediaQuery.of(context).size;

    Color activeColor;

    if (_value >= 0 && _value < minYield) {
      activeColor = Colors.yellow;
    } else if (_value > maxYield && _value <= 40) {
      activeColor = Colors.red;
    } else {
      activeColor = Colors.green;
    }
    
    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxHeight: size.height * 0.55, 
          maxWidth: size.width * 0.85
        ),
        child: Card(
          margin: EdgeInsets.all(20.0),
          elevation: 10.0,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0, 
              vertical:10.0
            ),
            child: Column(
              children: <Widget>[
                _yieldUpperSection(state, avgYield),
                Row(children: <Widget>[
                  Expanded(child: Container(), flex: 3,),
                  Expanded(
                    child: _yieldEditTxtSection(state), flex: 5,
                  ),
                  Expanded(child: Container(), flex: 1,)
                ],),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    AppLocalizations.of(context).perDay,
                  style: const TextStyle(
                    fontSize: 12.0
                  ),
              ),
                ),
                _yieldSlider(state, minYield, maxYield),
                _yieldSliderLabel(),
                isNormal 
                  ? Text("") 
                  : Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Text(
                        "Yield is outside of the normal," + 
                        " \nplease make sure it is right",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: activeColor
                        ),
                      )
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onChange(
    CattleYieldState state,
     double value, 
     bool test
   ) {
         MaskedTextController c = state.controller;
      setState(() {
        int decimals = 1;
        int fac = pow(10, decimals);
        value = (double.parse(c.text) * fac).round() / fac;
        if (value > 40) {
          value = 40.0;
        }
        _value = value;

        if (value == 0) {
          value = 0.0;
        }
        state.onSliderChange(value);
        state.controller.text = value.toString();
    });
  }

  void _onSliderChange(
    CattleYieldState state,
     double value, 
     bool test
   ) {
      setState(() {
        int decimals = 1;
        int fac = pow(10, decimals);
        value = (value * fac).round() / fac;
        if (value > 40) {
          value = 40.0;
        }
        _value = value;

        if (value == 0) {
          value = 0.0;
        }
        state.onSliderChange(value);
        state.controller.text = value.toString();
    });
  }


  Widget _yieldUpperSection(CattleYieldState state, String avgYield) {
    String name  =  state.animal.animalName.length > 20
      ? (state.animal.animalName.substring(0, 17) + "...") 
      : state.animal.animalName;

    return Row(
      children: <Widget>[
        Flexible(
          child: cattleImage(state.animal.encodedImage, state.animal.animalType), flex: 6,
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
            subtitle: Text(avgYield != ""
              ? "${AppLocalizations.of(context).avgYield} $avgYield"
              : AppLocalizations.of(context).avgYieldNoRecord)
            ),
          flex: 18,
        ),
        
      ]
    );
  }

  Widget _yieldEditTxtSection(CattleYieldState state) {
    return Row(
      children: <Widget>[
        Flexible(
          child: TextField(
            keyboardType: TextInputType.number,
            controller: state.controller,
            onChanged: (text) {
            },
            style: const TextStyle(
              fontSize: 32.0, 
              color: Colors.black
            ),
            onSubmitted: (val) {
              _onChange(state, double.parse(val),  true);
            },
            decoration: const InputDecoration(
              hintText: "0.00",
              border:  OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  const Radius.circular(16.0),
                ),
              ),
            ),           
          ), flex: 4,
        ),
        Flexible(child: Container(), flex: 1,),
        Flexible(
          child: const Text(
            'Ltr',
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 16.0
              )
          ), flex: 1,
        ),
      ],
    );
  }

   Widget _yieldSlider(CattleYieldState state, double minYield, double maxYield) {	  
      Color activeColor;	  

      if (_value >= 0 && _value < minYield) {	      
        activeColor = Colors.yellow;	            
      } else if (_value > maxYield && _value <= 40) {	           
        activeColor = Colors.red;	            
      } else {	            
        activeColor = Colors.green;	            
      }	        
      
      return Slider(	            
        activeColor: activeColor,	
        inactiveColor: Colors.black12,	
        min: 0.0,	
        max: 40.0,	
        value: _value,	
        onChanged: (double value){ 	
          _onSliderChange(state, value, false);	
        }	
      );	
    }

  Widget _yieldSliderLabel() {	
    return Padding(	
      padding: const EdgeInsets.symmetric(horizontal: 15.0),	
      child: Row(	
        mainAxisAlignment: MainAxisAlignment.spaceBetween,	
        children: [	
          const Text('0'),	
          const Text('40'),	
        ],	
      ),	
    );	   
  }
}
