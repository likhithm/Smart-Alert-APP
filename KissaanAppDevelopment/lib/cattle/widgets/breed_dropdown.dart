import 'package:flutter/material.dart';
import 'package:kissaan_flutter/cattle/utils/breed_state.dart';

class BreedDropdown extends StatelessWidget {
  const BreedDropdown();
  
  @override
  Widget build(BuildContext context) {
    BreedState state = BreedState.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:25.0),
      child: DropdownButton(
        value: state.breed,
        onChanged: state.onChanged,
        items: state.breeds
          .map( 
            (String breed) {
              return DropdownMenuItem(
                value: breed,
                child: Text(state.breedsMap[breed]),
              );
            }).toList()
      ),
    );
  }


}