import 'package:flutter/material.dart';
import 'package:kissaan_flutter/authorization/utils/phone_states.dart';
import 'package:kissaan_flutter/authorization/utils/sms_code_input_state.dart';

class SMSCodeInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SMSCodeInputState state = SMSCodeInputState.of(context);
    ThemeData theme = Theme.of(context);
    final hintStyle = TextStyle(color: Colors.white24);
    final enabled = state.authStatus == AuthStatus.SMS_AUTH;
    
    return TextField(
      keyboardType: TextInputType.number,
      enabled: enabled,
      textAlign: TextAlign.center,
      controller: state.smsController,
      maxLength: 6,
      onChanged: (String input) { 
        if (input.length == 6) {          
          state.onFieldSubmitted(true);
        }
      },
      onSubmitted: (text) => state.onFieldSubmitted,
      style: theme.textTheme.subhead.copyWith(
        fontSize: 32.0,
        color: enabled ? Colors.white : Colors.red
      ),
      decoration: InputDecoration(
        counterText: "",
        enabled: enabled,
        hintText: "--- ---",
        hintStyle: hintStyle.copyWith(fontSize: 42.0),
      ),
    );
  }
}