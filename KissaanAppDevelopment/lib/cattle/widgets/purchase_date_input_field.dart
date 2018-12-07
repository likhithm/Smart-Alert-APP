import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kissaan_flutter/cattle/utils/cattle_enums.dart';
import 'package:kissaan_flutter/cattle/utils/date_validation.dart';
import 'package:kissaan_flutter/cattle/utils/purchase_date_state.dart';
import 'package:kissaan_flutter/locale/locales.dart';

class PurchaseDateInputField extends StatelessWidget {
  PurchaseDateInputField();
  final TextEditingController _controller =  TextEditingController();

  @override
  Widget build(BuildContext context) {
    final format = new DateFormat('dd-MM-yyyy');

    PurchaseDateState state = PurchaseDateState.of(context);
    _controller.text = state.purchaseDate != null ? format.format(state.purchaseDate):"";

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
      child: TextFormField(
        controller: _controller,
        decoration: _buildInputDecoration(context),
        validator: (value) {
          if (!isValidDob(value)) {
            if (!value.isNotEmpty) {
              return AppLocalizations.of(context).notValidDate;
            }
          }
        },
      ),
    );
  }

  InputDecoration _buildInputDecoration(BuildContext context) {
    PurchaseDateState state = PurchaseDateState.of(context);
    ThemeData theme = Theme.of(context);

    return InputDecoration(
      suffixIcon: IconButton(
        color: theme.accentColor,
        icon: Icon(
          Icons.calendar_today
        ),
        onPressed: () {state.onPress(context, DateCase.purchase);}
      ),
      contentPadding: EdgeInsets.only(bottom: 10.0),
      hintText: AppLocalizations.of(context).enterPurchaseDate,
      labelText: AppLocalizations.of(context).dateOfPurchase,
      labelStyle: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500)
    );
  }
}