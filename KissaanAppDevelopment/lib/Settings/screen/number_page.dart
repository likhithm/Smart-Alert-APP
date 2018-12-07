import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kissaan_flutter/authorization/screens/auth.dart';
import 'package:kissaan_flutter/locale/locales.dart';

class NumberPage extends StatefulWidget {
  final FirebaseUser currentUser;
  final String docKey;

  NumberPage(this.currentUser, this.docKey);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return NumberPageState();
  }

}

class NumberPageState extends State<NumberPage> {
  final formKey = GlobalKey<FormState>();
  final decorationStyle = TextStyle(color: Colors.grey[50], fontSize: 16.0);
  final hintStyle = TextStyle(color: Colors.white70);
  final List<String> codes = ["+1", "+91"];

  String smsCode;
  String verificationId;
  String currentCode = "+1", currentCodeNew = "+1", originNumber = "", newNumber = "", oldNumber = "";

  TextEditingController phoneNumberController = new TextEditingController();
  TextEditingController phoneNumberControllerNew = new TextEditingController();

  @override
  void initState() {
    super.initState();
    originNumber = widget.currentUser.phoneNumber.toString();
  }


  Future<void> verifyPhone() async {
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
      this.verificationId = verId;
    };

    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
      smsCodeDialog(context).then((value) {
        //print('Signed in');
      });
    };

    final PhoneVerificationCompleted verifiedSuccess = (FirebaseUser user) {
      //print('verified');
    };

    final PhoneVerificationFailed veriFailed = (AuthException exception) {
      //print('${exception.message}');
    };
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: currentCodeNew + newNumber,
        codeAutoRetrievalTimeout: autoRetrieve,
        codeSent: smsCodeSent,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verifiedSuccess,
        verificationFailed: veriFailed);
  }

  Future<bool> smsCodeDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text(AppLocalizations.of(context).enterSMS),
            content: TextField(
              onChanged: (value) {
                this.smsCode = value;
              },
            ),
            contentPadding: EdgeInsets.all(10.0),
            actions: <Widget>[
              new FlatButton(
                child: Text(AppLocalizations.of(context).done),
                onPressed: () {
                  FirebaseAuth.instance.currentUser().then((user) {
                    signIn();
                  });
                },
              )
            ],
          );
        });
  }

  signIn() {
    FirebaseAuth.instance
        .signInWithPhoneNumber(verificationId: verificationId, smsCode: smsCode)
        .then((user) {
      updateData(user.uid);
    }).catchError((e) {
      print(e);
    });
  }

  void updateData(String uid) async {
    await Firestore.instance.collection("users").document(widget.docKey).updateData({"phoneNumber": currentCodeNew + newNumber , "authUID": uid});
    FirebaseAuth.instance.signOut().then((result) {
      Navigator.of(context).pushNamedAndRemoveUntil('/auth', (Route<dynamic> route) => false);
    });
  }

  void _changeOldCountryCode(String value) {
    setState(() {
      currentCode = value;
    });
  }
  void _changeNewCountryCode(String value) {
    setState(() {
      currentCodeNew = value;
    });
  }

  void onPress() async{
    if(formKey.currentState.validate()) {
      formKey.currentState.save();
      QuerySnapshot snapshot = await Firestore.
      instance.
      collection("users").
      where("phoneNumber", isEqualTo: currentCodeNew + newNumber).
      limit(1).
      getDocuments();

      if(snapshot.documents.length != 1) {
        verifyPhone();
      }
      else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(AppLocalizations.of(context).numTransferFail),
              content:
              Text(AppLocalizations.of(context).numAlreadyUsed),
              actions: <Widget>[
                FlatButton(
                    child: Text(AppLocalizations.of(context).confirm),
                    onPressed: ()
                    {
                      Navigator.of(context).pop();
                    }
                )
              ],
            );
          }
        );
      }
    }
  }

  Widget rowSection() {
    return Container(
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  24.0,25.0,24.0,15.0
              ),
              child: Text(AppLocalizations.of(context).oldPhoneNum,
                style: decorationStyle,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  24.0,5.0,24.0,15.0
              ),
              child:_buildCountryCodeSelector(context, true),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  24.0,15.0,24.0,15.0
              ),
              child: Text(AppLocalizations.of(context).newPhoneNum,
                style: decorationStyle,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(
                    24.0,5.0,24.0,15.0
                ),
                child:_buildCountryCodeSelector(context, false)
            ),
          ],
        )
      )
    );
  }

  Widget _buildCountryCodeSelector(BuildContext context, bool isOld) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: DropdownButton(
              value: isOld?currentCode:currentCodeNew,
              onChanged: isOld?_changeOldCountryCode:_changeNewCountryCode,
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
              maxHeight: 100.0,
              maxWidth: 200.0
          ),
          child: _buildPhoneNumberInput(context, isOld),
        )
      ],
    );
  }

  Widget _buildPhoneNumberInput(BuildContext context, bool isOld) {
    return TextFormField(
      keyboardType: TextInputType.number,
      controller: isOld?phoneNumberController:phoneNumberControllerNew,
      maxLength: 10,
      //onFieldSubmitted: onFieldSubmitted,
      onSaved: isOld ? (input) => oldNumber = input : (input) => newNumber = input,
      validator: (input){
        if(!isOld) {
          return input.length != 10 ? AppLocalizations.of(context).invalidPhoneNum : null;
        }
        else {
          return currentCode + input != originNumber
            ? AppLocalizations.of(context).phoneNumNoMatch : null;
        }
      },
      style: Theme
          .of(context)
          .textTheme
          .subhead
          .copyWith(fontSize: 18.0, color: Colors.white),
      decoration: InputDecoration(
        isDense: false,
        counterText: "",
        icon: const Icon(
          Icons.phone,
          color: Colors.white,
        ),
        labelText: AppLocalizations.of(context).phone,
        labelStyle: decorationStyle,
        hintText: AppLocalizations.of(context).yourPhoneNum,
        hintStyle: hintStyle,
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Color.fromRGBO(91,190,134,1.0),
        title: Text(
          AppLocalizations.of(context).changeNum,
          style: TextStyle(
              fontSize: 24.0
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Theme.of(context).accentColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
              child: Container(child: rowSection()),
          ),
          RaisedButton(
            child: Text(AppLocalizations.of(context).submit),
            color: Colors.greenAccent ,
            onPressed: () {
              onPress();
            },
          ),

        ],
      ),
    );
  }
}