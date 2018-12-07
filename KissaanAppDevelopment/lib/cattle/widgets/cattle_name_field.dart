import 'package:flutter/material.dart';
import 'package:kissaan_flutter/cattle/utils/cattle_name_state.dart';
import 'package:kissaan_flutter/locale/locales.dart';


class CattleNameField extends StatefulWidget {
  final String name;
  CattleNameField({String this.name});

  @override
  _CattleNameFieldState createState() => _CattleNameFieldState();
}

class _CattleNameFieldState extends State<CattleNameField> {
   @override
  Widget build(BuildContext context) {
    CattleNameState state = CattleNameState.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
      child: TextFormField(
        controller: state.controller,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(bottom: 10.0),
          hintText: AppLocalizations.of(context).cattleName,
          labelText: AppLocalizations.of(context).name,
          labelStyle: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500)
        ),
        validator: (value) {
          if (value.isEmpty) {
            return AppLocalizations.of(context).pleaseEnterText;
          }
        },
      ),
    );
  }
}