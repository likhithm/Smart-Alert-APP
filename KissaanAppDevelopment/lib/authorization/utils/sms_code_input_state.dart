import 'package:flutter/material.dart';
import 'package:kissaan_flutter/authorization/utils/phone_states.dart';

class SMSCodeInputState extends InheritedWidget {
  const SMSCodeInputState({
    Key key,
    @required this.authStatus,
    @required this.smsController,
    @required this.onFieldSubmitted,
    @required Widget child,
  }) : assert(child != null),
       super(key: key, child: child);

  final AuthStatus authStatus;
  final TextEditingController smsController;

  final Function onFieldSubmitted;

  

  static SMSCodeInputState of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(SMSCodeInputState);
  }

  @override
  bool updateShouldNotify(SMSCodeInputState old) => authStatus != old.authStatus;
}