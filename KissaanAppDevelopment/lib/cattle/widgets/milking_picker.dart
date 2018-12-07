import 'package:flutter/material.dart';
import 'package:kissaan_flutter/cattle/utils/milking_state.dart';
import 'package:kissaan_flutter/locale/locales.dart';

class MilkingPicker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MilkingState state = MilkingState.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: state.enabled 
            ? Text(
            AppLocalizations.of(context).milking,
              style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
              textAlign: TextAlign.left,
            )
            : Container()
        ),
        Row(
          children: <Widget>[
            GenderRadioListTile(AppLocalizations.of(context).yes,"Yes"),
            GenderRadioListTile(AppLocalizations.of(context).no,"No")
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
    MilkingState state = MilkingState.of(context);

    if (state.enabled) { 
      return Container(
        constraints: BoxConstraints(maxWidth: size.width/2.1, maxHeight: 50.0),
        child: RadioListTile<String>(
          activeColor: Theme.of(context).accentColor,
          title: Text(text),
          value: value,
          groupValue: state.milking,
          onChanged: (String milking) { state.onTap(milking); },
        ),
      );
    } else {
      return Container();
    }
  }
}

