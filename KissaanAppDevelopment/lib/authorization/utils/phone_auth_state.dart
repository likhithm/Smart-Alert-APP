import 'package:flutter/material.dart';
import 'package:kissaan_flutter/authorization/utils/phone_states.dart';

class PhoneAuthState extends InheritedWidget {
  const PhoneAuthState({
    Key key,
    @required this.errorMessage,
    @required this.phoneNumberController,
    @required this.currentCode,
    @required this.authStatus,
    @required this.onFieldSubmitted,
    @required this.onCodeChanged,
    @required this.onConfirmedPressed,
    @required Widget child,
  }) : assert(child != null),
       super(key: key, child: child);

  final String currentCode;
  final String errorMessage;
  final AuthStatus authStatus;
  final TextEditingController phoneNumberController;

  final Function onFieldSubmitted;
  final Function onCodeChanged;
  final Function onConfirmedPressed;

  static PhoneAuthState of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(PhoneAuthState);
  }

  @override
  bool updateShouldNotify(PhoneAuthState old) => currentCode != old.currentCode ||
    errorMessage != old.errorMessage ||
    authStatus != old.authStatus;
}