import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kissaan_flutter/Settings/screen/number_page.dart';
import 'package:kissaan_flutter/locale/Application.dart';
import 'package:kissaan_flutter/main.dart';
import 'package:kissaan_flutter/utils/image_process.dart';
import 'package:kissaan_flutter/dashboard/widgets/dashboard.dart';
import 'package:kissaan_flutter/locale/locales.dart';

class DrawerBuilder extends StatefulWidget {
  final FirebaseUser currentUser;
  final String docKey;
  DrawerBuilder(this.currentUser, this.docKey);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _DrawerBuilderState();
  }

}

class _DrawerBuilderState extends State<DrawerBuilder> {
  int _key;
  @override
  void initState() {
    application.onLocaleChanged = onLocaleChange;
  }

  void onLocaleChange(Locale locale) {
    Firestore.instance
        .collection("users")
        .document(widget.docKey).updateData({"languageCode": locale.languageCode});
    setState(() {
      application.delegate = new AppLocalizationsDelegate(newLocale: locale);
      _collapse();
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: _buildDrawerChildren()
      )
    );
  }

  List<Widget> _buildDrawerChildren(){
    return [
      DrawerHeader(
        child: _buildDrawerPic(),
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
        ),
      ),
      _buildDrawerTile(
          AppLocalizations.of(context).userProfileTitle,
          _tapUserProfile
      ),
      _buildDrawerTile(
          AppLocalizations.of(context).changeNumberText,
          _tapChangeNumber
      ),
      _buildChangeLanguageList(),
      _buildDrawerTile(
          AppLocalizations.of(context).logout,
          _tapSignOut
      )
    ];
  }

  Widget _buildDrawerTile(String text, VoidCallback func) {
    return ListTile(
      title: Text(text),
      onTap: () {
        func();
      },
    );
  }

  Widget _buildDrawerPic() {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection("users")
            .where(
            "phoneNumber",
            isEqualTo: widget.currentUser.phoneNumber
        )
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return  Container();

          DocumentSnapshot document = snapshot.data.documents[0];

          return Container(
            child: _buildProfilePicture(
                document.data["encodedImage"],
                context
            ),
          );
        }
    );
  }

  Widget _buildProfilePicture(String imageFile, BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (imageFile == "") {
      imageFile = null;
    }
    return Container(
      padding: EdgeInsets.only(
          left: width * 0.175,
          right:  width * 0.175
      ),
      child: binaryToDrawerImage(imageFile),
    );
  }

  void _tapUserProfile() {
    //QuerySnapshot snapshot = await getUserFromPhoneNumber();

    //docKey = snapshot.documents[0].documentID;
    Navigator.of(context).push(MaterialPageRoute<Map<String,String>>(
        builder: (context) {
          return Dashboard(widget.currentUser, widget.docKey);
        },
        fullscreenDialog: true
    ));
  }

  void _tapChangeNumber() {
    //QuerySnapshot snapshot = await getUserFromPhoneNumber();
    //docKey = snapshot.documents[0].documentID;

    Navigator.of(context)
        .push(MaterialPageRoute<Map<String,String>>(
        builder: (context) {
          return NumberPage(widget.currentUser, widget.docKey);
        },
        fullscreenDialog: true
    ));
  }

  void _tapSignOut() async{
    await FirebaseAuth.instance
        .signOut();
    Navigator.of(context)
        .pushNamedAndRemoveUntil(
        '/auth',
            (Route<dynamic> route) => false
    );
  }

  Widget _buildChangeLanguageList() {
    return ExpansionTile(
      key: new Key(_key.toString()),
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

  _collapse() {
    int newKey;
    do {
      _key = new Random().nextInt(10000);
    } while (newKey == _key);
  }

}