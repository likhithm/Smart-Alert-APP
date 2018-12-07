import 'package:flutter/material.dart';
import 'package:kissaan_flutter/locale/locales.dart';
import 'package:kissaan_flutter/utils/image_process.dart';
import 'package:kissaan_flutter/yield/utils/cattle_yield_state.dart';


class CattleDisplayCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   CattleYieldState state = CattleYieldState.of(context);

    String name = state.animal.animalName.length > 20
      ? (state.animal.animalName.substring(0, 17) + "...") 
      : state.animal.animalName;
    Size size = MediaQuery.of(context).size;

    return Container(
      constraints: BoxConstraints(
        maxHeight: size.height * 0.28
      ),
      child: Card(
        elevation: 10.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _buildStatistics(state, context, name)
        ),
      ),
    );
  }

  Widget _buildStatistics(CattleYieldState state, BuildContext context, String name) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          ListTile(
            leading:  Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: cattleImage(
                state.animal.encodedImage, 
                state.animal.animalType, 
                isBig: true
              ),
            ),
            title: Text(
              name,
              style: const TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.w600
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  state.avgYield != ""
                    ? "${AppLocalizations.of(context).avgYield} ${state.avgYield}"
                    : AppLocalizations.of(context).avgYieldNoRecord,
                ),
                Row( 
                  children: <Widget>[
                    Text(
                      "Max: ${state.maxYield}",
                      style: TextStyle(
                        fontWeight: FontWeight.w500
                      ),
                    ),
                    SizedBox(width: 15.0,),
                    Text(
                      "Min: ${state.minYield}",
                      style: TextStyle(
                        fontWeight: FontWeight.w500
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    state.value == 0 
                      ? "Last Entry Date: ${state.lastDate}"
                      : "Current Yield Entry: ${state.value}"
                  ),
                ),

                FlatButton(
                  onPressed: () {
                    state.onPress(
                      context, 
                      state.avgYield, 
                      state.maxYield, 
                      state.minYield
                    );
                  }, 
                  child: Text(
                    "Enter Yield",
                    style: TextStyle(
                      color: Colors.green
                    ),
                  ),
                )
              ]
            ),
          ),
        ],
      );
    }
  
}