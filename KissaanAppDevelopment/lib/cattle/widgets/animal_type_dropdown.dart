import 'package:flutter/material.dart';
import 'package:kissaan_flutter/cattle/utils/animal_type_state.dart';
import 'package:kissaan_flutter/locale/locales.dart';

class AnimalTypeDropdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AnimalTypeState state = AnimalTypeState.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: DropdownButton(
        value: state.animalType,
        onChanged: state.onChanged,
        items: [
          DropdownMenuItem(
            value: "Cow",
            child: Text(AppLocalizations.of(context).cow),
          ),
          DropdownMenuItem(
            value: "Buffalo",
            child: Text(AppLocalizations.of(context).buffalo),
          )
        ],
      ),
    );
  }
}