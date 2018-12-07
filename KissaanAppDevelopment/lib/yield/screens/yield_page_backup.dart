import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kissaan_flutter/cattle/model_classes/Animal.dart';
import 'package:kissaan_flutter/locale/locales.dart';
import 'package:kissaan_flutter/yield/model_classes/Yield.dart';
import 'package:kissaan_flutter/yield/widgets/yield_card.dart';
import 'package:kissaan_flutter/utils/NavBarState.dart';
import 'package:shared_preferences/shared_preferences.dart';

class YieldPage extends StatefulWidget {
    final FirebaseUser currentUser;
    final String docKey;
    final GlobalKey val;
    YieldPage(this.currentUser, this.docKey, this.val);

    @override
    _YieldPageState createState() => _YieldPageState();
}

class _YieldPageState extends State<YieldPage> {

  DateTime dateTime;
  final format = DateFormat('dd-MM-yyyy');

  CollectionReference dbReplies = Firestore.instance
    .collection('yields')
    .reference();

  String animalID;
  String yieldQty;
  String time;
  String date;
  int animalSize = 0, counter = 0;
  String today;
  SharedPreferences preferences;

  List<String> yieldDataList = new List();
  List<Yield> yieldList =  [];
  List<Animal> animalList =  [];
  List<TextEditingController> txtControlList =  [];
  List<Widget> infoList = new List();

  @override
  void initState() {
    super.initState();
    animalID = yieldQty;
    DateTime currTime = DateTime.now();
    DateTime currDate = DateTime(currTime.year, currTime.month, currTime.day);
    dateTime = currDate;
    date = format.format(currDate);
    today = date;
  }

  @override
  void dispose() {
    for(TextEditingController controller in txtControlList){ 
      controller.dispose();
    }
    super.dispose();
  }

  Widget dialogContent() {
    return SizedBox(
      width: 100.0,
      height: 250.0,
      child: ListView(
        children: infoList,
      ),
    );
  }

  void _onPress(BuildContext ctxt) async{
    preferences = await SharedPreferences.getInstance();
    yieldDataList = preferences.getStringList("animalYield");

    try { 
      for(int i = 0; i < txtControlList.length; i++) {
        Yield y = yieldList[i];
        Animal animal = animalList[i];
        animalID = y.animalID;
        yieldQty = txtControlList[i].text;

        if(yieldQty == '')
          continue;

        double res = double.parse(yieldQty);

        if(res == 0)
          continue;
        counter++;
        infoList.add(Text(animal.animalName + ": " + txtControlList[i].text.toString()));
        await _insertYieldFields();
      }
    } on RangeError {
      
    }

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context).submissionConfirm),
            content: counter == 0?
              Text(AppLocalizations.of(context).noDataSaved):
              dialogContent(),
            //Text(AppLocalizations.of(context).dataSavedSuccessfully),
            actions: <Widget>[
              FlatButton(
                  child: Text(AppLocalizations.of(context).confirm),
                  onPressed: ()
                  async {
                    //Scaffold.of(ctxt).showSnackBar(SnackBar(content: Text("Yield entered"),));
                    Navigator.of(context).pop();
                    NavBarState bar = widget.val.currentWidget;
                    bar.onTapped(0);
                  }
              )
            ],
          );
        }
    );
  }

  Future<void> _insertYieldFields() async {
    if(dateTime == null) {
      return;
    }

    double qty = double.parse(yieldQty);

    if(qty == 0)
      return;

    Map<String, String> fields =  {
      "animalID" : animalID,
      "yieldQty" : yieldQty,
    };  

    int diffInDays = DateTime.now()
      .difference(dateTime)
      .inDays;

    String dateInMS = dateTime
      .millisecondsSinceEpoch
      .toString();

    fields["yieldDate"] = dateInMS;



    bool isExist = await checkYieldExistance(dateInMS, time, diffInDays);

    if((isExist && diffInDays < 5) || !isExist)
      dbReplies.add(fields);
  }

  Future<bool> checkYieldExistance(String dateTimeStr, String time, int diff) async {
    bool isExist = false;
    final QuerySnapshot result = await Firestore.instance
        .collection('yields')
        .where('yieldDate', isEqualTo: dateTimeStr)
        .where('animalID', isEqualTo: animalID)
        .where('yieldTime', isEqualTo: time)
        .limit(1)
        .getDocuments();

    final List<DocumentSnapshot> documents = result.documents;
    if(documents.length >= 1)
      isExist = true;
    if(isExist && diff < 5) {
      for (int i = 0; i < result.documents.length; i++)
        Firestore.instance
            .collection('yields')
            .document(result.documents[i].documentID)
            .delete();
    }
    return isExist;
  }

  void _setDate() async{
    final DateTime picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now().subtract(Duration(days: 5)),
      lastDate: DateTime.now(),
      initialDate: DateTime.now().subtract(Duration(seconds: 5))
    );

    if (picked != null) {
      setState(() {
        date = format.format(picked);
        dateTime = picked;
      });
    }
  }

  Widget _dateTimeSection() {
    Size size = MediaQuery.of(context).size;
    String icon;

    icon = DateTime.now().hour < 12 
      ? "assets/icons/day.png"
      : "assets/icons/night.png";

    return Row(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            _setDate();
          },
          behavior: HitTestBehavior.opaque,
          child: Container(
            constraints: BoxConstraints(
              maxHeight: size.height*0.3, 
              maxWidth: size.width*0.9
            ),
            child: _buildDateListTile(icon),
          ),
        ),
      ],
    );
  }

  Widget _buildDateListTile(String icon) {
    return ListTile(
      leading: ImageIcon(
        AssetImage(icon), 
        color: const Color.fromRGBO(91,190,133,1.0),
      ),
      title: Text(
        date == today 
          ? '${AppLocalizations.of(context).today} $date'
          : '$date',
        style: const TextStyle(
          color: const Color.fromRGBO(91,190,133,1.0),
          fontSize: 16.0,
          fontWeight: FontWeight.w500
        ),
      ),
    );
  }

  Widget _listViewSection(double height) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: height, 
        minHeight: height
      ),
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: ListView.builder(
        itemCount: animalList.length,
        padding: const EdgeInsets.symmetric(
          vertical: 5.0,
        ),
        itemBuilder: (context, index) {
//          TextEditingController controller = TextEditingController();
//          txtControlList.add(controller);
          return YieldCard(
            animalList[index], 
            txtControlList[index],
            yieldList[index]
          );
        }
      ),
    );
  }

  Widget _lowerButtonSection(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Size size = MediaQuery.of(context).size;

      return Container(
        constraints: BoxConstraints(
          maxHeight: size.height * 0.0905
        ),
        child: ButtonBar(
          alignment: MainAxisAlignment.center,
          children: <Widget>[
            Ink(
              decoration: BoxDecoration(
                border: Border.all(
                  color: theme.accentColor, 
                  width: 1.0
                ),
                color: theme.accentColor,
                shape: BoxShape.circle,
              ),
              child: InkWell(
                //This keeps the splash effect within the circle
                borderRadius: BorderRadius.circular(1000.0), //Something large to ensure a circle
                onTap: () {
                   _onPress(context);
                },
                child: Padding(
                  padding:EdgeInsets.all(0.0),
                  child:Icon(
                    Icons.check, 
                    color: Colors.white,
                  )
                ),
              ),
            ),
            Ink(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.red, 
                  width: 1.0
                ),
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: InkWell(
                //This keeps the splash effect within the circle
                borderRadius: BorderRadius.circular(1000.0), //Something large to ensure a circle
                onTap: () {
                  NavBarState bar = widget.val.currentWidget;
                  bar.onTapped(0);
                },
                child: Padding(
                  padding:EdgeInsets.all(0.0),
                  child:Icon(
                    Icons.cancel, 
                    color: Colors.red,
                  )
                ),
              ),
            ),
          ],
        ),
      );
    }

  Widget _yieldPageSection(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    
    return Column(
      children: <Widget>[
        _dateTimeSection(),
        _listViewSection(size.height * 0.60),
        _lowerButtonSection(context),
      ],
    );
  }

  Widget _loadYields(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    animalList.clear();
    yieldList.clear();

    snapshot.data.documents.map(
      (DocumentSnapshot document) {
        Animal animal =  Animal.fromData(document);
        animalList.add(animal);
        yieldList.add(
          Yield(document.documentID, '', '', null)
        );

        MaskedTextController controller = MaskedTextController(mask: "00.0");

        txtControlList.add(controller);
      }
    ).toList();
    return _yieldPageSection(context);
  } 

  @override
  Widget build(BuildContext context) {
    return Column(
      children : [
        AppBar(
          title: Text(
            AppLocalizations.of(context).yields
          ),
          backgroundColor: Theme.of(context).accentColor,
        ),
        StreamBuilder<QuerySnapshot> (
          stream: Firestore.instance
            .collection("animals")
            .where("userID", isEqualTo: widget.docKey)
            .where("isMilking", isEqualTo: "Yes")
            .where("gender", isEqualTo: "Female")
            .where("animalStatus", isEqualTo: "")
            .snapshots(),
          builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData)
              return Text(
                AppLocalizations.of(context).loading
              );
            animalSize = snapshot.data.documents.length;
            return _loadYields(context, snapshot);
          }
        ),
      ]
    );
  }
}
