import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kissaan_flutter/cattle/model_classes/Animal.dart';
import 'package:kissaan_flutter/cattle/screens/new_cattle_dialog.dart';
import 'package:kissaan_flutter/cattle/utils/cattle_state.dart';
import 'package:kissaan_flutter/cattle/widgets/cattle_display_icon_button.dart';
import 'package:kissaan_flutter/locale/locales.dart';

class CattleDisplayListView extends StatelessWidget {
  final String userId;
  final String nameFilter;
  CattleDisplayListView(this.userId, this.nameFilter);

  @override
  Widget build(BuildContext context) {
    Function onTap = CattleState.of(context).onTapAdd;

    Future _openAddEntryDialog() async {
      Map<String, String> fields;
      fields = await Navigator.of(context)
        .push(MaterialPageRoute<Map<String,String>>(
        builder: (BuildContext context) {
          return AddCattleDialog();
        },
        fullscreenDialog: true
      ));

      if (fields != null) {
        String id = userId +
          DateTime.now()
            .millisecondsSinceEpoch
            .toString();
        Firestore.instance
          .collection("animals")
          .document(id)
          .setData(fields);

        Firestore.instance
          .collection("yieldsAvg")
          .document(id)
          .setData({
            "userID" : userId,
            "animalID" : id,
            "avgYield" : "0",
            "animalName" : fields["animalName"],
            "maxYield": "0",
            "minYield": "0",
          });
      }
    }
    
    List<Widget> _getCattleButtons(List<DocumentSnapshot> documents) {
      return documents
        .map(
          (DocumentSnapshot document) {
            Animal animal = Animal.fromData(document);
            if(animal.animalStatus == "Dead" || animal.animalStatus == "Sold")
              return Container();
            return CattleDisplayIconButton(animal, document.documentID, onTap);
      }).toList();
    }

    Widget _buildButton(String text, String imgPath) {
      CattleState state = CattleState.of(context);
      Map<String, Function> functionOfLabel = {
        AppLocalizations.of(context).addAnimal : _openAddEntryDialog,
        AppLocalizations.of(context).allCattle : state.onTapAll,
        AppLocalizations.of(context).archived : state.onTapArchived
      };

      return Container(
        padding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
        constraints: BoxConstraints(
          maxWidth: 90.0,
          maxHeight: 105.0
        ),
        child: Column(
          children: <Widget>[
            IconButton(
              padding: EdgeInsets.all(0.0),
              iconSize: 55.0,
              icon: Image.asset(imgPath),
              onPressed: () { 
                functionOfLabel[text]();
              }
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 5.0, 
                top: 8.0
              ),
              child: ButtonLabel(text),
            ),
          ],
        ),
      );
    }

    Widget _buildAddCattleButton() {
      return _buildButton(AppLocalizations.of(context).addAnimal, "assets/icons/add_cattle.png");
    }

    Widget _buildAllCattleButton() {
      return _buildButton(AppLocalizations.of(context).allCattle, "assets/icons/all_cattle.png");
    }

    Widget _buildArchiveCattleButton() {
      return _buildButton(AppLocalizations.of(context).archived, "assets/icons/archived.png");
    }
    
    List<Widget> _buildCattleList(AsyncSnapshot<QuerySnapshot> snapshot) {
      List<Widget> widgets = [
        _buildAddCattleButton(),
        _buildAllCattleButton(),
      ];

      List<Widget> newWidgets = List.from(widgets);
      List<DocumentSnapshot> documents = snapshot.data.documents;

      if (nameFilter != "") {
        List<DocumentSnapshot> tempList = List();

        for (DocumentSnapshot snap in documents) {
          Animal curr = Animal.fromData(snap);
          if(curr.animalName.toLowerCase().contains(nameFilter))
            tempList.add(snap);
        }
        documents.clear();
        documents.addAll(tempList);
      }

      newWidgets.add(_buildArchiveCattleButton());
      newWidgets.addAll(_getCattleButtons(documents));

      return newWidgets;
    }

    Widget _buildEmptyDisplay() {
      return Container(
        padding: EdgeInsets.all(0.0),
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 1.0),
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          children: [_buildAddCattleButton(), _buildAllCattleButton()],
        ),
        decoration: BoxDecoration(
          border: BorderDirectional(
            bottom: BorderSide(
              color: const Color.fromRGBO(224,224,224,1.0),
            )
          )
        ),
        constraints: BoxConstraints(
          maxHeight: 109.0, 
          minWidth: 360.0,
          maxWidth: 360.0
        ),
      );
    }
    
    Size size = MediaQuery.of(context).size;

    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
        .collection("animals")
        .where("userID", isEqualTo: userId)
        .snapshots(),
        
      builder: (context, snapshot) {
        if (!snapshot.hasData) return  _buildEmptyDisplay();
        return Container(
          child:  ListView(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            children: _buildCattleList(snapshot)
          ),
          decoration: BoxDecoration(
            border: BorderDirectional(
              bottom: BorderSide(
                color: const Color.fromRGBO(224,224,224,1.0),
              )
            )
          ),
          constraints: BoxConstraints(
            maxHeight: size.height/6.3,
            minWidth: size.width,
            maxWidth: size.width
          ),
        );
      },
    );
  }
}

class ButtonLabel extends StatelessWidget {
  final String text;

  ButtonLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 12.0, 
        fontWeight: FontWeight.w500
      ),
    );
  }
}
