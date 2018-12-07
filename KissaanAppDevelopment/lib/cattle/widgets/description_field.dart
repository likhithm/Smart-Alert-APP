import 'package:flutter/material.dart';
import 'package:kissaan_flutter/cattle/utils/description_state.dart';
import 'package:kissaan_flutter/locale/locales.dart';

class DescriptionField extends StatefulWidget {
  final String description;

  DescriptionField({String this.description});

  @override
  _DescriptionFieldState createState() => _DescriptionFieldState();
}

class _DescriptionFieldState extends State<DescriptionField> {


  @override
  Widget build(BuildContext context) {
    DescriptionState state = DescriptionState.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
      child: TextFormField(
        controller: state.controller,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(bottom: 10.0),
            hintText: AppLocalizations.of(context).enterDescription,
            labelText: AppLocalizations.of(context).description,
            labelStyle: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500)
        ),
      ),
    );
  }
}