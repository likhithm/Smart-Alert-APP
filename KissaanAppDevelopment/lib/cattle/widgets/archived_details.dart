import 'package:flutter/material.dart';
import 'package:kissaan_flutter/cattle/model_classes/Animal.dart';
import 'package:kissaan_flutter/locale/locales.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ArchivedCattleDetails extends StatefulWidget {
  final String animalID;
  final Animal animal;
  final Size size;

  ArchivedCattleDetails(this.animal, this.animalID, this.size);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ArchivedCattleDetailsState(animal, animalID, size);
  }

}

class ArchivedCattleDetailsState extends State<ArchivedCattleDetails> {
  final String animalID;
  final Animal animal;
  final Size size;

  ArchivedCattleDetailsState(this.animal, this.animalID, this.size);
  
  String btnTxt;

  bool isLoaded = false;
  
  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    if(!isLoaded) {
      btnTxt = AppLocalizations
          .of(context)
          .undo;
      isLoaded = true;
    }
    Widget _buildIdentifyingInfoDisplay(Animal animal) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            animal.animalType + " - " + animal.animalBreed + " - " + animal.gender,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w300,
              fontSize: 16.0
            ),
          ),
          Text(AppLocalizations.of(context).status + ": " + animal.animalStatus)
        ]
      );
    }

    Widget _buildNameDisplay() {
      Size size = MediaQuery.of(context).size;

      return Container(
        constraints: BoxConstraints(
          maxWidth: size.width/1.8, 
          minWidth: size.width/1.8
        ),
        child: Text(
          animal.animalName.length > 17
            ? animal.animalName.substring(0, 15) + "..."
            : animal.animalName,
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w600
          )
        ),
      );
    }
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          constraints: BoxConstraints(
            maxWidth: size.width/2,
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
            title: _buildNameDisplay(),
            subtitle: _buildIdentifyingInfoDisplay(animal)
          )
        ),
        FlatButton(
          child: Text(btnTxt),
          onPressed: () {
            setState(() {
              btnTxt = AppLocalizations.of(context).restored;
            });
            DocumentReference reference = Firestore.instance
                .collection('animals')
                .document(animalID);
            Firestore.instance.runTransaction((tx) async {
              DocumentSnapshot snapshot = await tx.get(reference);
              if(snapshot.exists) {
                await tx.update(reference, {"animalStatus": ""});
              }
            });
          },
        )
      ],
    );
      
      
  }
}