import 'package:flutter/material.dart';
import 'package:kissaan_flutter/authorization/utils/phone_auth_state.dart';
import 'package:kissaan_flutter/authorization/utils/phone_states.dart';
import 'package:kissaan_flutter/locale/locales.dart';

class PhoneAuthBody extends StatelessWidget {
  final Size size;
  final TextStyle decorationStyle;
  PhoneAuthBody(this.size, this.decorationStyle);
  final hintStyle = TextStyle(color: Colors.white70);
  final List<String> codes = ["+1", "+91"];
  double width, height;
  @override
  Widget build(BuildContext context) {
    width = size.width;
    height = size.height;
    PhoneAuthState state = PhoneAuthState.of(context);
    ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(
            24.0, 75.0,24.0,25.0
          ),
          child: Text(
            AppLocalizations.of(context).enterNumberBelow
                + AppLocalizations.of(context).willSendSMS,
            style: decorationStyle,
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
          child: Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _buildCountryCodeSelector(state, context),
              _buildConfirmPhoneButton(theme, state)
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmPhoneButton(ThemeData theme, PhoneAuthState state) {
    double width = size.width;
    double height = size.height;
    return Container(
      constraints:BoxConstraints(
        maxHeight: height/3.6,
        maxWidth: height/3.6
      ),
      child: IconButton(
        icon: Icon(Icons.check),
        color: theme.accentColor,
        disabledColor: theme.buttonColor,
        onPressed: (state.authStatus == AuthStatus.PROFILE_AUTH)
          ? null
          : () => state.onConfirmedPressed,
      )
    );
  }

  Widget _buildCountryCodeSelector(PhoneAuthState state, BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: DropdownButton(
            value: state.currentCode,
            onChanged: state.onCodeChanged,
            items: codes.map((String value){
              return DropdownMenuItem(
                child: Row(
                  children: <Widget>[
                    Text(value)
                  ],
                ),
                value: value,
              );
            }).toList()
          ),
        ),
        Container(
          constraints: BoxConstraints(
            maxHeight: height/6.5,
            maxWidth: 1.6 * width / 3
          ),
          child: _buildPhoneNumberInput(context),
        )
      ],
    );
  }

  Widget _buildPhoneNumberInput(BuildContext context) {
    PhoneAuthState state = PhoneAuthState.of(context);

    return TextFormField(
      keyboardType: TextInputType.number,
      controller: state.phoneNumberController,
      maxLength: 10,
      onFieldSubmitted: state.onFieldSubmitted,
      style: Theme
          .of(context)
          .textTheme
          .subhead
          .copyWith(fontSize: width/25, color: Colors.white),
      decoration: InputDecoration(
        isDense: false,
        enabled: state.authStatus == AuthStatus.PHONE_AUTH,
        counterText: "",
        icon: const Icon(
          Icons.phone,
          color: Colors.white,
        ),
        labelText: AppLocalizations.of(context).phone,
        labelStyle: decorationStyle,
        hintText: AppLocalizations.of(context).yourPhoneNum,
        hintStyle: hintStyle,
        errorText: state.errorMessage,
      ),
    );
  }
}