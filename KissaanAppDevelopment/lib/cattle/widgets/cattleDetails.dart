import 'package:flutter/material.dart';
import 'package:kissaan_flutter/cattle/model_classes/Animal.dart';
import 'package:kissaan_flutter/locale/locales.dart';


class CattleDetails extends StatelessWidget {
  final String animalID;
  final Animal animal;
  final Size size;

  CattleDetails(this.animal, this.animalID, this.size);

  @override
  Widget build(BuildContext context) {
    Map<String, String> cowMap = {
      "Ongole": AppLocalizations.of(context).ongole,
      "Punganoor": AppLocalizations.of(context).punganoor,
      "Holstein": AppLocalizations.of(context).holstein,
      "Jersey": AppLocalizations.of(context).jersey,
      "Gir": AppLocalizations.of(context).gir,
      "Shahiwal": AppLocalizations.of(context).shahiwal,
      "Deoni": AppLocalizations.of(context).deoni,
      "Ratti": AppLocalizations.of(context).ratti,
      "Other": AppLocalizations.of(context).other,
    };

    Map<String, String> buffaloMap = {
      "Murrah": AppLocalizations.of(context).murrah,
      "Mehsana": AppLocalizations.of(context).mehsana,
      "Jaffarbadi": AppLocalizations.of(context).jaffarbadi,
      "Banni": AppLocalizations.of(context).banni,
      "Other": AppLocalizations.of(context).other
    };
    Map<String, String> genderMap = {
      'Male': AppLocalizations.of(context).male,
      'Female': AppLocalizations.of(context).female
    };
    Map<String, String> typeMap = {
      'Cow': AppLocalizations.of(context).cow,
      'Buffalo': AppLocalizations.of(context).buffalo
    };

    Widget _buildIdentifyingInfoDisplay(Animal animal) {
      String type = animal.animalType == "Cow"? cowMap[animal.animalBreed]:buffaloMap[animal.animalBreed];
      String breed = typeMap[animal.animalType];
      String gender = genderMap[animal.gender];
      return Text(
        type + " - " + breed + " - " + gender,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w300,
          fontSize: 16.0
        ),
      );
    }


    Widget _buildNameDisplay() {
      return Text(
        animal.animalName.length > 17
          ? animal.animalName.substring(0, 15) + "..."
          : animal.animalName,
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w600
        )
      );
    }
    
    return ListTile(
      // This is for overwriting the default padding.
      // Removing makes the default padding kick in
      // and that makes it look different to what we want.
      contentPadding: const EdgeInsets.only(right: 0.0),
      title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          _buildNameDisplay(),
        ]
      ),
      subtitle: _buildIdentifyingInfoDisplay(animal)
    );
  }
}