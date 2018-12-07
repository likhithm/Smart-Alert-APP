import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kissaan_flutter/cattle/model_classes/Animal.dart';
import 'package:kissaan_flutter/locale/locales.dart';

class ImportantDates extends StatelessWidget {
  final Animal animal;

  const ImportantDates(this.animal);

  @override
  Widget build(BuildContext context) {
   AppLocalizations localization = AppLocalizations.of(context);
    final format = DateFormat('dd-MM-yyyy');

    Widget _buildDatesDisplay(DateTime date, String label) {
      return Container(
        width: MediaQuery.of(context).size.width/2.7,
        child: ListTile(
          title: Text(
            label,
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w600
            )),
          subtitle: Text(
            date != null
              ? format.format(date)
              : "",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w300
            )
          )
        ),
      );
    }

    return Row(
      children: <Widget>[
        _buildDatesDisplay(
          animal.dateOfBirth,
          localization.dateOfBirth
        ),
        _buildDatesDisplay(
          animal.dateOfPurchase,
          localization.dateOfPurchase
        ),
      ],
    );
  }
}