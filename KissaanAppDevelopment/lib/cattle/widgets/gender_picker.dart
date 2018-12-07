import 'package:flutter/material.dart';
import 'package:kissaan_flutter/cattle/utils/gender_state.dart';
import 'package:kissaan_flutter/locale/locales.dart';


class GenderPicker extends StatelessWidget {  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Text(
            AppLocalizations.of(context).gender,
            style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
            textAlign: TextAlign.left,
          ),
        ),
        Row(
          children: <Widget>[
            GenderRadioListTile(AppLocalizations.of(context).male, "Male"),
            GenderRadioListTile(AppLocalizations.of(context).female, "Female")
            ],
        ),
      ],
    );
  }
}

class GenderRadioListTile extends StatelessWidget {
  const GenderRadioListTile(this.text, this.value);
  final String text;
  final String value;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    GenderState state = GenderState.of(context);

    return Container(
      constraints: BoxConstraints(maxWidth: size.width/2.0, maxHeight: 50.0),
      child: RadioListTile<String>(
        activeColor: Theme.of(context).accentColor,
        title: Text(text),
        value: value,
        groupValue: state.gender,
        onChanged: (String gender) { state.onTap(gender); },
      ),
    );
  }
}

