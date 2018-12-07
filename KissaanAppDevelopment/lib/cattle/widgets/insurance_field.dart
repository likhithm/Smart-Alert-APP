import 'package:flutter/material.dart';
import 'package:kissaan_flutter/cattle/utils/insurance_state.dart';
import 'package:kissaan_flutter/locale/locales.dart';


class InsuranceField extends StatefulWidget {
  final String code;
  InsuranceField({String this.code});

  @override
  _InsuranceFieldState createState() => _InsuranceFieldState();
}

class _InsuranceFieldState extends State<InsuranceField> {
  @override
  Widget build(BuildContext context) {
    InsuranceState state = InsuranceState.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
      child: TextFormField(
        controller: state.controller,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(bottom: 10.0),
            hintText: AppLocalizations.of(context).enterInsuranceNum,
            labelText: AppLocalizations.of(context).insurance,
            labelStyle: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500)
        ),
//        validator: (value) {
//          if (value.isEmpty) {
//            return 'Please enter some text';
//          }
//        },
      ),
    );
  }
}