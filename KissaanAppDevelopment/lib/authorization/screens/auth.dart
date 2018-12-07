import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kissaan_flutter/authorization/utils/phone_auth_state.dart';
import 'package:kissaan_flutter/authorization/utils/phone_states.dart';
import 'package:kissaan_flutter/authorization/utils/sms_code_input_state.dart';
import 'package:kissaan_flutter/authorization/widgets/phone_auth_body.dart';
import 'package:kissaan_flutter/authorization/widgets/sms_code_input.dart';
import 'package:kissaan_flutter/dashboard/screens/main_screen.dart';
import 'package:kissaan_flutter/locale/Application.dart';
import 'package:kissaan_flutter/locale/locales.dart';
import 'package:kissaan_flutter/main.dart';
import '../widgets/reactive_refresh_indicator.dart';


class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  static const String TAG = "AUTH";
  AuthStatus status = AuthStatus.PHONE_AUTH;
  String _currentCode;
  String docKey = "", userName = "";
  // Keys
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Controllers
  TextEditingController smsCodeController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  // Variables
  String _errorMessage;
  String _verificationId;
  Timer _codeTimer;

  bool _isRefreshing = false;
  bool _codeTimedOut = false;
  bool _codeVerified = false;
  Duration _timeOut = const Duration(minutes: 1);
  FirebaseAuth _auth;

    @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
    _currentCode = "+91";
    _logInCurrentUser();
    application.onLocaleChanged = onLocaleChange;
  }

  void onLocaleChange(Locale locale) {
    setState(() {
      application.delegate = new AppLocalizationsDelegate(newLocale: locale);
    });
  }
  //-------------------Phone Input  related Code---------------------------

  String _phoneInputValidator() {
    if (phoneNumberController.text.isEmpty) {
      return AppLocalizations.of(context).phoneNumCantEmpty;
    } else if (phoneNumberController.text.length < 10) {
      return AppLocalizations.of(context).phoneNumInvalid;
    }
    return null;
  }

  Future<Null> _submitPhoneNumber() async {
    final error = _phoneInputValidator();
    _updateRefreshing(false);

    setState(() {
      _errorMessage = error;
    });

    final result = error != null 
      ? null
      : await _verifyPhoneNumber();
    return result;
  }

  Future<Null> _verifyPhoneNumber() async {
    await _auth.verifyPhoneNumber(
        phoneNumber: this.phoneNumber,
        timeout: _timeOut,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
        verificationCompleted: phoneVerificationCompleted,
        verificationFailed: phoneVerificationFailed);
    return null;
  }

  String get phoneNumber {
    return _currentCode + phoneNumberController.text;
  }

  void codeSent(String verificationId, [int forceResendingToken]) async {
    _codeTimer = Timer(_timeOut, () {
      setState(() {
        _codeTimedOut = true;
      });
    });
    _updateRefreshing(false);
    setState(() {
      this._verificationId = verificationId;
      this.status = AuthStatus.SMS_AUTH;
    });
  }

  codeAutoRetrievalTimeout(String verificationId) {
    _updateRefreshing(false);
    setState(() {
      this._verificationId = verificationId;
      this._codeTimedOut = true;
    });
  }

  phoneVerificationCompleted(FirebaseUser user) async {
    if (await _onCodeVerified(user)) {
      await _finishSignIn(user);
    } else {
      setState(() {
        this.status = AuthStatus.SMS_AUTH;
      });
    }
  }

  phoneVerificationFailed(AuthException authException) {
    _showErrorSnackbar(AppLocalizations.of(context).couldntVerifyCode);
    print(authException.message.toString());
  }

  void _changeCountryCode(String value) {
    setState(() {
      _currentCode = value;   
    });
  }

  void _submitandRefresh(String string) {
    _updateRefreshing(true);
  }


  //--------------SMS Code ---------------------------------------------------------------
  String _smsInputValidator() {
    if (smsCodeController.text.isEmpty) {
      return AppLocalizations.of(context).verificationCodeEmpty;
    } else if (smsCodeController.text.length < 6) {
      return AppLocalizations.of(context).invalidVerificationCode;
    }

    return null;
  }

  void _logInCurrentUser() async {
    FirebaseAuth.instance.currentUser().then(
      (FirebaseUser user) async {
        if (user != null) {
          Firestore.instance
            .collection('users')
            .where('authUID', isEqualTo: user.uid)
            .limit(1)
            .getDocuments().then(
              (value) {
                if (value.documents[0].data != null) {
                  _finishSignIn(user);
                }
              }
            );
        }
      }
    );
  }

  // Styling
  final decorationStyle = TextStyle(color: Colors.grey[50], fontSize: 16.0);
  final hintStyle = TextStyle(color: Colors.white24);
  //
  @override
  void dispose() {
    _codeTimer?.cancel();
    super.dispose();
  }


  
  // async
  Future<Null> _updateRefreshing(bool isRefreshing) async {
    if (_isRefreshing) {
      setState(() {
        this._isRefreshing = false;
      });
    }
    setState(() {
      this._isRefreshing = isRefreshing;
    });
  }

  void _showErrorSnackbar(String message) {
    _updateRefreshing(false);
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<Null> _onRefresh() async {
    switch (this.status) {
      case AuthStatus.PHONE_AUTH:
        return await _submitPhoneNumber();
        break;
      case AuthStatus.SMS_AUTH:
        return await _submitSmsCode();
        break;
      case AuthStatus.PROFILE_AUTH:
        break;
    }
  }
  
  Future<Null> _submitSmsCode() async {
    final error = _smsInputValidator();
    
    if (error != null) {
      _updateRefreshing(false);
      _showErrorSnackbar(error);
      return null;
    } else {
      if (this._codeVerified) {
        await _finishSignIn(await _auth.currentUser());
      } else {
        await _signInWithPhoneNumber();
      }
      return null;
    }
  }

  Future<void> _signInWithPhoneNumber() async {
    final errorMessage = AppLocalizations.of(context).couldntVerifyCodeRetry;
    await _auth
      .signInWithPhoneNumber(
        verificationId: _verificationId, 
        smsCode: smsCodeController.text
      )
      .then((user) async {
        await _onCodeVerified(user)
        .then((codeVerified) async {
            this._codeVerified = codeVerified;
            if (this._codeVerified) {
              await _finishSignIn(user);
           } else {
              _showErrorSnackbar(errorMessage);
            }
        });
      }, onError: (error) {
        smsCodeController.clear();
      _showErrorSnackbar(errorMessage);
    });
  }

  Future<bool> _onCodeVerified(FirebaseUser user) async {
    final isUserValid = (user != null &&
        (user.phoneNumber != null && user.phoneNumber.isNotEmpty));
    if (isUserValid) {
      setState(() {
        this.status = AuthStatus.PROFILE_AUTH;
      });
    } else {
      smsCodeController.clear();
      _showErrorSnackbar(AppLocalizations.of(context).couldntVerifyCodeRetry);
    }
    return isUserValid;
  }

  _finishSignIn(FirebaseUser user) async {
    await _onCodeVerified(user).then((result) async {
      if (result) {
        //TODO Do routing with named routes
        final QuerySnapshot results = await Firestore.instance.collection("users")
          .where("authUID", isEqualTo: user.uid)
          .limit(1)
          .getDocuments();

        if (results.documents.length == 0) {
          _askForUserData(user).then(
            (value) {
              Navigator.of(context)
              .pushReplacement(
                MaterialPageRoute(
                  builder: (context) =>
                      MainScreen(
                        firebaseUser: user,
                        docKey: docKey,
                        userName: userName,
                      ),
                )
              );
            }
          );
        }
        else if (results.documents[0].data["userName"] != null) {
          docKey = results.documents[0].documentID;
          Navigator.of(context)
              .pushReplacement(
                MaterialPageRoute(
                  builder: (context) =>
                      MainScreen(
                        firebaseUser: user,
                        docKey: docKey,
                        userName:  results.documents[0].data['userName'].toString()
                      ),
                )
              );
        }
      } else {
        setState(() {
          this.status = AuthStatus.SMS_AUTH;
        });
        _showErrorSnackbar(
            AppLocalizations.of(context).couldntCreatProfile);
      }
    });
  }

  Future<Null> _askForUserData(FirebaseUser user) async {
    TextEditingController controller = TextEditingController();

    return showDialog<Null>(
      context: context,
      barrierDismissible: false, 
      builder: (BuildContext context) {
        return  AlertDialog(
          title:  Text(AppLocalizations.of(context).enterName),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: controller,
                  maxLength: 15,
                )
              ],
            ),
          ),
          actions: <Widget>[
          FlatButton(
              child: Text(AppLocalizations.of(context).accept),
              onPressed: () {
                if (controller.text.length != 0) {
                  DocumentReference document = Firestore.instance.collection("users").document();
                  document.setData(
                    {
                      "userName" : controller.text,
                      "authUID" : user.uid,
                      "phoneNumber" : user.phoneNumber,
                      "dateRegistered" : DateTime.now().millisecondsSinceEpoch.toString()
                    }
                  );
                  docKey = document.documentID;
                  userName = controller.text;
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  // ----------------------------------- Widgets

  Widget _buildResendSmsWidget() {
    return InkWell(
      onTap: () async {
        if (_codeTimedOut) {
          await _verifyPhoneNumber();
        } else {
          _showErrorSnackbar(AppLocalizations.of(context).cantRetryYet);
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: AppLocalizations.of(context).codeNotThereInOneMin,
            style: decorationStyle,
            children: <TextSpan>[
              TextSpan(
                text: AppLocalizations.of(context).here,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSmsAuthBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(24.0, 64.0, 24.0, 0.0),
          child: Text(
            AppLocalizations.of(context).verificationCode,
            style: decorationStyle,
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 60.0, right: 60.0),
          child: SMSCodeInputState(
            child: SMSCodeInput(),
            onFieldSubmitted: _updateRefreshing,
            authStatus: status,
            smsController: smsCodeController,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: _buildResendSmsWidget(),
        )
      ],
    );
  }

  Widget _buildBody() {
    Widget body;
    switch (this.status) {
      case AuthStatus.PHONE_AUTH:
        Size size = MediaQuery.of(context).size;
        TextStyle textStyle = new TextStyle(
            color: Colors.grey[50],
            fontSize: size.width/25
        );

        body = PhoneAuthState(
          child: PhoneAuthBody(size, textStyle),
          onCodeChanged: _changeCountryCode,
          onConfirmedPressed: _submitandRefresh,
          onFieldSubmitted: _submitandRefresh, 
          authStatus: status, 
          currentCode: _currentCode, 
          errorMessage: _errorMessage, 
          phoneNumberController: phoneNumberController,
        );
        break;
      case AuthStatus.SMS_AUTH:
      case AuthStatus.PROFILE_AUTH:
        body = _buildSmsAuthBody();
        break;
    }
    return body;
  }

  Widget _buildChangeLanguageList() {
    return ExpansionTile(
      initiallyExpanded: false,
      title: Text(AppLocalizations.of(context).language),
      children: <Widget>[
        _buildLanguageItem("English","en"),
        _buildLanguageItem("हिंदी", "hi"),
        _buildLanguageItem("తెలుగు", "en_AU"),
      ],
    );
  }

  Widget _buildLanguageItem(String language, String code) {
    return InkWell(
      onTap: () {
        application.onLocaleChanged(Locale(code));
        MyApp.setLocale(context, new Locale(code));
      },
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Text(
            language,
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0.0, 
        backgroundColor: Color.fromRGBO(91,190,134,1.0),
        title: Text(
          AppLocalizations.of(context).authentication,
          style: TextStyle(
            fontSize: 24.0
          ),
        ),
        centerTitle: true,
      ),

      backgroundColor: Theme.of(context).accentColor,
      body: ListView(
        //mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          _buildChangeLanguageList(),
          Container(
            child: ReactiveRefreshIndicator(
              onRefresh: _onRefresh,
              isRefreshing: _isRefreshing,
              child: Container(child: _buildBody()),
            ),
          ),
        ],
      ),
    );
  }
}