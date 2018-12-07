import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kissaan_flutter/locale/locales.dart';
import 'package:kissaan_flutter/utils/picture_select.dart';

class EditUserDialog extends StatefulWidget {
  final DocumentSnapshot userSnapshot;

  EditUserDialog(this.userSnapshot);

  _EditUserDialogState createState() => _EditUserDialogState();
}

class _EditUserDialogState extends State<EditUserDialog> {
  final _formKey = GlobalKey<FormState>();
  DocumentSnapshot _userSnapshot;
  TextEditingController _nameFieldController = TextEditingController();
  TextEditingController _aadhaarFieldController = TextEditingController();
  TextEditingController _locationFieldController = TextEditingController();
  TextEditingController _referralController = TextEditingController();

  List<String> srcList = new List();
  @override
  void initState() {
    super.initState();
    _userSnapshot = widget.userSnapshot;
    _nameFieldController.text = _userSnapshot.data["userName"];
    _aadhaarFieldController.text = _userSnapshot.data["aadhaar"] != null
      ? _userSnapshot.data["aadhaar"]
      : "";
    _locationFieldController.text = _userSnapshot.data["location"] != null
      ? _userSnapshot.data["location"]
      : "";
    _referralController.text = _userSnapshot.data['agentCode'] != null
      ? _userSnapshot.data['agentCode']
      : "";
    srcList.add(_userSnapshot.data['encodedImage'] != null? _userSnapshot.data['encodedImage']: "");
  }

  @override
  void dispose() {
    super.dispose();
    _nameFieldController.dispose();
    _aadhaarFieldController.dispose();
    _locationFieldController.dispose();
    _referralController.dispose();
  }

  Map<String, String> _getFields() {
    return {
      "userName" : _nameFieldController.text,
      "location" : _locationFieldController.text,
      "aadhaar" : _aadhaarFieldController.text,
      "agentCode" : _referralController.text,
      "encodedImage" : srcList[0]
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(91,190,133,1.0),
        title: Text(AppLocalizations.of(context).editUser),
        actions: [
          FlatButton(
            onPressed: () async {
              Map<String, String> fields = _getFields();

              if (_formKey.currentState.validate()) {
                 Navigator
                    .of(context)
                    .pop(fields);
              }
            },
            child: Text(AppLocalizations.of(context).save,
              style: Theme
                  .of(context)
                  .textTheme
                  .subhead
                  .copyWith(color: Colors.white))),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 25.0, 
            vertical: 15.0
          ),
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: 15.0),
            children: <Widget>[
              picture_select(srcList, true),
              TextFormField(
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(bottom: 10.0),
                  hintText: AppLocalizations.of(context).name,
                  labelText: AppLocalizations.of(context).name,
                  labelStyle: TextStyle(
                    fontSize: 20.0, 
                    fontWeight: FontWeight.w500
                  )
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return AppLocalizations.of(context).pleaseEnterText;
                  }
                },
                controller: _nameFieldController,
              ),
              TextFormField(
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(bottom: 10.0),
                  hintText: AppLocalizations.of(context).enterLocation,
                  labelText: AppLocalizations.of(context).locationOPT,
                  labelStyle: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500)
                ),
                controller: _locationFieldController,
              ),
              TextFormField(
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(bottom: 10.0),
                  hintText: AppLocalizations.of(context).enterAadhar,
                  labelText: AppLocalizations.of(context).aadharOPT,
                  labelStyle: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500)
                ),
                keyboardType: TextInputType.number,
                maxLength: 12,
                maxLengthEnforced: true,
                controller: _aadhaarFieldController,
                validator: (value) {
                  if (value.length < 12) {
                    return "Please enter a 12 digit AADHAAR.";
                  }
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: 10.0),
                    hintText: AppLocalizations.of(context).enterAgentCode,
                    labelText: AppLocalizations.of(context).referral,
                    labelStyle: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500)
                ),
                keyboardType: TextInputType.number,
                maxLength: 10,
                controller: _referralController,
              ),

            ],
          ),
        ),
      )
    );
  }
}

