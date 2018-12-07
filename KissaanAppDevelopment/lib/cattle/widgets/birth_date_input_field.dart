import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kissaan_flutter/cattle/utils/birth_date_state.dart';
import 'package:kissaan_flutter/cattle/utils/cattle_enums.dart';
import 'package:kissaan_flutter/cattle/utils/date_validation.dart';
import 'package:kissaan_flutter/locale/locales.dart';

class BirthDateInputField extends StatelessWidget {
  BirthDateInputField();
  final TextEditingController _controller =  TextEditingController();

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final format = new DateFormat('dd-MM-yyyy');

    BirthDateState state = BirthDateState.of(context);
    _controller.text = state.birthDate != null ? format.format(state.birthDate) : "";

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 25.0),
      child: TextFormField(
        controller: _controller,
        decoration: InputDecoration(
          suffixIcon: IconButton(
            color: theme.accentColor,
            icon: Icon(
              Icons.calendar_today
            ),
            onPressed: () {state.onTap(context, DateCase.birth);}
          ),
          hintText: AppLocalizations.of(context).enterBirthDate,
          labelText: AppLocalizations.of(context).dateOfBirth,
          labelStyle: const TextStyle(
            fontSize: 20.0, 
            fontWeight: FontWeight.w500
          ),
        ),
        validator: (value) {
          //if (!isValidDob(value)) {
          //  if (value.isNotEmpty) {
          if(false)
              return 'Not a valid date.';
          //  }
          //}
        },
      ),
    );
  }


}