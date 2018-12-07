import 'package:flutter/material.dart';
import 'package:kissaan_flutter/cattle/model_classes/Animal.dart';
import 'package:kissaan_flutter/utils/image_process.dart';
import 'package:kissaan_flutter/utils/string_formatter.dart';

class CattleDisplayIconButton extends StatelessWidget {
  final Function onTap;
  final Animal animal;
  final String animalID;

  CattleDisplayIconButton(this.animal, this.animalID, this.onTap);

  final StringFormatter formatter = StringFormatter();

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 110.0),
      padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
      child: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              _buildButton(onTap, animalID, animal)
            ],
          ),
          _buildLabel(animal)
        ],
      ),
    );
  }

  Widget _buildButton(Function onTap, String cattleID, Animal animal) {
    if (animal.encodedImage == "") {
      animal.encodedImage = null;
    }
    return GestureDetector(
      onTap: () {
        onTap(animal, cattleID); },
      child: CircleAvatar(
        child: cattleImage(animal.encodedImage, animal.animalType),//Text(cattle.name),//
        minRadius: 28.0,
        maxRadius: 28.0,
        backgroundColor: animal.gender == "Male"
          ? Color.fromRGBO(0, 121, 191, 1.0) 
          : Color.fromRGBO(228, 150, 175, 1.0)
      ),
    );
  }

  Widget _buildLabel(Animal animal) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0, top: 6.0),
      child: Text(
        animal.animalName.length > 12 
          ? animal.animalName.substring(0, 10) + "..." 
          : animal.animalName ,
        style: TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.w500
        ),
      ),
    );
  }
}