import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kissaan_flutter/dashboard/screens/user_edit_dialog.dart';
import 'package:kissaan_flutter/locale/locales.dart';
import 'package:kissaan_flutter/utils/image_process.dart';

class Dashboard extends StatefulWidget {
  const Dashboard(this.currentUser, this.docKey);
  final FirebaseUser currentUser;
  final String docKey;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return DashboardState();
  }

}

class DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    double width =  MediaQuery.of(context).size.width;
    AppLocalizations localizations = AppLocalizations.of(context);
    Color appBarColor = Theme.of(context).accentColor;
    
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar:_buildAppBar(localizations.userProfileTitle, appBarColor),
      body: Row(
        children: [
          SizedBox(width: width/7),
          Column(
            children: <Widget>[
              const SizedBox(height: 15.0),
              const SizedBox(width: 2.5),
              UsernameDisplay(widget.currentUser, widget.docKey),
              Divider(),
              //_buildConfirmButton(context, canEdit),
            ],
          ),
          _buildEditButton(width, context)
        ]
      ),
    );
  }

  Widget _buildAppBar(String title, Color color) {
    return AppBar(
      backgroundColor: color,
      elevation: 0.0,
      title: Text(
        title,
        style: TextStyle(
            fontSize: 24.0,
            color: Colors.white,
        ),
      ),
      centerTitle: true,
    );
  }

  Future _openAddEntryDialog(BuildContext context) async {
    Map<String, String> fields;

    Firestore.instance
      .collection("users")
      .where("authUID", isEqualTo: widget.currentUser.uid)
      .limit(1)
      .getDocuments()
      .then((userSnapshot) async {
        fields = await Navigator.of(context)
          .push(MaterialPageRoute<Map<String,String>>(
            builder: (context) {
              return EditUserDialog(userSnapshot.documents[0]);
            },
            fullscreenDialog: true
          ));
        _handleUserDetailsEdit(fields);
      }
      );
  }

  void _handleUserDetailsEdit(Map<String, String> fields) {
    if (fields != null) {
      fields["authUID"] = widget.currentUser.uid;
      Firestore.instance.
        collection("users").
        document(widget.docKey).
        updateData(fields);
    }
  }

  Widget _buildEditButton(double width, BuildContext context) {
    return Container(
      width: width/7,
      padding: EdgeInsets.only(top: 8.0),
      alignment: Alignment.topRight,
      child: IconButton(
        color: Theme.of(context).accentColor,
        icon: Image.asset("assets/icons/edit_button.png"),
        iconSize: 37.0,
        onPressed: (){_openAddEntryDialog(context);},
      ),
    );
  }
}

class UsernameDisplay extends StatelessWidget {
  final FirebaseUser currentUser;
  final String userID;
  const UsernameDisplay(this.currentUser, this.userID);

  Widget _buildProfilePicture(String imageFile, BuildContext context) {
    if (imageFile == ""){
      imageFile = null;
    }
    final width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.only(
        left: 4 * width/27, 
        right:  4 * width/27
      ),
      height: width/3,
      child: binaryToDrawerImage(imageFile),
    );
  }

  Widget _fetchUserAndBuildDisplay() { 
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
        .collection("users")
        .where(
          "phoneNumber",
          isEqualTo: currentUser.phoneNumber
        )
        .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Text(AppLocalizations.of(context).loading);
        DocumentSnapshot document = snapshot.data.documents[0];
        Size size = MediaQuery.of(context).size;

        return Container(
          constraints: BoxConstraints(
            maxWidth: 5 * size.width/7, 
            maxHeight: 3 * size.height/4
          ),
          child: _buildUserDisplayTile(context, document),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0,10.0,0.0,10.0),
      child: currentUser != null
        ? _fetchUserAndBuildDisplay()
        : Container()
    );
  }

  Widget _buildUserDisplayTile(BuildContext context, DocumentSnapshot document) {
    String name = document.data["userName"];
    String location = document.data["location"];
    String aadhaar = document.data["aadhaar"];
    String encodedImage = document.data["encodedImage"];

    return ListTile(
      isThreeLine: true,
      title: _buildHeader(context, AppLocalizations.of(context).welcome),
      subtitle: ListView(
        children: <Widget>[
          _buildProfilePicture(encodedImage, context),
          _buildHeader(context, name),
          _buildUserSubdetails(AppLocalizations.of(context).location, context, location),
          _buildUserSubdetails(AppLocalizations.of(context).aadhar, context, aadhaar),
          Divider(
            color: Colors.transparent,
            height: 120.0,
          ),
          //_buildGraphSection(),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String text){ 
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
          color: Theme.of(context).accentColor,
          fontSize: 32.0,
          fontWeight: FontWeight.w500
      )
    );
  }

  Widget _buildUserSubdetails(String field, BuildContext context, String text) {
    return text != null
      ? Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
            field + " " + text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize: 20.0,
              fontWeight: FontWeight.w400
            )),
      ) 
      : Container();

  }
}