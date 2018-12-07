import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kissaan_flutter/cattle/screens/cattle_page.dart';
import 'package:kissaan_flutter/locale/locales.dart';
import 'package:kissaan_flutter/newsfeed/screens/newsfeed_page.dart';
import 'package:kissaan_flutter/utils/image_process.dart';
import 'package:kissaan_flutter/widgets/drawer_builder.dart';
import 'package:kissaan_flutter/yield/screens/yield_page.dart';
import 'package:kissaan_flutter/dashboard/widgets/dashboard.dart';
import 'package:kissaan_flutter/tasks/screens/tasks_page.dart';
import 'package:kissaan_flutter/utils/NavBarState.dart';
import 'package:kissaan_flutter/widgets/NavBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kissaan_flutter/Settings/screen/number_page.dart';

class MainScreen extends StatefulWidget {
  final FirebaseUser firebaseUser;
  final String docKey;
  final String userName;
  GlobalKey _myTabbedPageKey = new GlobalKey();

  MainScreen(
      {Key key,
        @required this.firebaseUser,
        @required this.docKey,
        @required this.userName
      })
      : assert(firebaseUser != null),
        super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState(_myTabbedPageKey);
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  String uid = '', phoneNumber = '';
  Widget body;
  PageController _pageController;

  final GlobalKey key;

  _MainScreenState(this.key);


  @override
  void initState() {
    super.initState();

    _pageController = new PageController();
    body = NewsfeedPage(widget.firebaseUser, widget.docKey, widget.userName);
    FirebaseAuth.instance
      .currentUser()
        .then((val) {
          setState(() {
            this.uid = val.uid;
            this.phoneNumber = val.phoneNumber;
          });
        });

  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      _currentIndex = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
      drawer: DrawerBuilder(widget.firebaseUser, widget.docKey),
//      Drawer(
//        child: ListView(
//          padding: EdgeInsets.zero,
//          children: _buildDrawerChildren()
//        ),
//      ),
      body: PageView(
        children: [
          NewsfeedPage(widget.firebaseUser, widget.docKey, widget.userName),
          CattlePage(widget.firebaseUser, widget.docKey),
          YieldPage(widget.firebaseUser, widget.docKey, key),
          TasksPage(widget.firebaseUser, widget.docKey),
        ],
        controller: _pageController,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
    /*Center(
        child: Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: body
        ),
      ),*/
      bottomNavigationBar: NavBarState(
        key: key,
        onTapped: _onTabTapped,
        currentIndex: _currentIndex,
        child: NavBar(),
      ),
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
      _buildDrawerTile(
        AppLocalizations.of(context).logout, 
        _tapSignOut
      )
    ];
  }

  Widget _buildDrawerPic() {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
        .collection("users")
        .where(
          "phoneNumber",
          isEqualTo: widget.firebaseUser.phoneNumber
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

  Widget _buildDrawerTile(String text, VoidCallback func) {
    return ListTile(
      title: Text(text),
      onTap: () {
        func();
      },
    );
  }
  
  Future<QuerySnapshot> getUserFromPhoneNumber() {
    return Firestore.instance.
      collection("users").
      where("phoneNumber", isEqualTo: phoneNumber).
      limit(1).
      getDocuments();
  }

  void _onTabTapped(int index) {
    //QuerySnapshot snapshot = await getUserFromPhoneNumber();
    setState(() {
      //docKey = snapshot.documents[0].documentID;
      _currentIndex = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease);
    });
  }

  void _tapUserProfile() {
    //QuerySnapshot snapshot = await getUserFromPhoneNumber();

    //docKey = snapshot.documents[0].documentID;
    Navigator.of(context).push(MaterialPageRoute<Map<String,String>>(
        builder: (context) {
          return Dashboard(widget.firebaseUser, widget.docKey);
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
          return NumberPage(widget.firebaseUser, widget.docKey);
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

}
