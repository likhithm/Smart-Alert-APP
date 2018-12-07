import 'package:charts_flutter/flutter.dart' as charts;
import 'package:kissaan_flutter/cattle/utils/cattle_page_body_state.dart';
import 'package:kissaan_flutter/cattle/widgets/archived_details.dart';
import 'package:kissaan_flutter/cattle/widgets/cattle_display.dart';
import 'package:kissaan_flutter/locale/locales.dart';
import 'package:kissaan_flutter/utils/YieldPoint.dart';
import 'package:kissaan_flutter/utils/YieldSet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kissaan_flutter/utils/YieldSet.dart';
import 'package:kissaan_flutter/cattle/model_classes/Animal.dart';
import 'package:kissaan_flutter/cattle/utils/cattle_state.dart';
import 'package:kissaan_flutter/cattle/widgets/cattle_display_list.dart';
import 'package:shared_preferences/shared_preferences.dart';


class CattlePage extends StatefulWidget {
  final FirebaseUser currentUser;
  final String docKey;
  CattlePage(this.currentUser, this.docKey);

  @override
  _CattlePageState createState() => _CattlePageState();
}


//Page State
class _CattlePageState extends State<CattlePage> {
  Widget body;
  String docKey = "";
  String _time;
  String animalID;
  String nameFilter ="";
  bool visible = true, isAnimal = false;
  Map<String, double> _measures;
  List<String> dataSet = new List();
  List<Widget> children = new List();
  List<DocumentSnapshot> documents = [];

  final format = DateFormat('dd-MM-yyyy');
  ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    docKey = widget.docKey;
    body = _buildAllCattleDisplayBody();
  }

  @override 
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return NestedScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return <Widget>[
          SliverOverlapAbsorber(
            handle: NestedScrollView
              .sliverOverlapAbsorberHandleFor(context),
            child: PreferredSize(
              child: SliverAppBar(
                backgroundColor: theme.accentColor,
                title: _buildSearchBar(),
              ),
              preferredSize: Size.fromHeight(10.0)
            )
          )
        ];
      },
      body: ListView(
        shrinkWrap: true,
        physics: AlwaysScrollableScrollPhysics(),
        children: <Widget>[
          CattleState(
            onTapAll: _setBodyAll,
            onTapAdd: _setBody,
            onTapArchived: _setBodyArchived,
            child: CattleDisplayListView(docKey, nameFilter)
          ),
          visible?_buildGraphSection():Container(),
          body,
          visible?Container():(isAnimal?_buildGraphSectionSingle(context):Container())
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w400,
        fontSize: 20.0
      ),
      decoration: InputDecoration.collapsed(
        border: InputBorder.none,
        hintText: AppLocalizations.of(context).search,
        hintStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w400,
          fontSize: 20.0
        ),
      ),
      onChanged: (String text) {
        setState(() {
          nameFilter = text.toLowerCase();
          List<DocumentSnapshot> newDocs = documents
              .where((document) =>
                document.data["animalName"]
                  .toString()
                  .contains(text))
                  .toList();

          List<DocumentSnapshot> tempList = [];

          for(DocumentSnapshot snap in newDocs) {
            Animal curr = Animal.fromData(snap);
            if(curr.animalName.contains(nameFilter))
              tempList.add(snap);
          }
          newDocs.clear();
          newDocs.addAll(tempList);
          body = _buildCattleListView(newDocs);
        });
      },
    );
  }

  Widget _buildGraphSection() {
    String id = widget.docKey;
    String collectionName = 'userProductivityGraph';
    String idName = 'userID';
    List<YieldPoint> points = List();

    return Container(
      constraints: BoxConstraints(
          maxHeight: 200.0
      ),
      child: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection(collectionName)
            .where(
              idName, isEqualTo:id
            )
            .snapshots(),
        builder: (context, snapshot) {
          if(!snapshot.hasData)
            return Text(AppLocalizations.of(context).loading);

          List<DocumentSnapshot> documents = snapshot.data.documents;

          points.clear();
          points.add(YieldPoint("0/0/00", 0.0));
          
          if (documents.length > 0) {
            YieldSet set = YieldSet.fromData(documents[0]);
            List<String> timeList = set.monthYearList;
            List<String> yieldList = set.yieldList;
            points.clear();
            for(int i = 0; i < timeList.length; i++) {
              points.add(YieldPoint(timeList[i], double.parse(yieldList[i])));
            }
          }

          var series = [
            charts.Series<YieldPoint, String>(
                id: "Yields",
                colorFn: (_, __) => charts.Color(r: 91, g: 190,b: 133,a: 255),
                domainFn: (YieldPoint yieldPoint, _) 
                  => yieldPoint.time,
                measureFn: (YieldPoint yieldPoint, _) 
                  => yieldPoint.quantity,
                data: points
            )
          ];
          var chart = charts.BarChart(
            series,
            animate: true,
          );
          return chart;
        },

      ),
    );
  }

  Widget _buildCattleListView(List<DocumentSnapshot> filtered) {
    return ListView.builder(
      padding: EdgeInsets.all(0.0),
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemCount: filtered.length,
      itemBuilder: (BuildContext context, int index) {
        Animal animal = Animal.fromData(filtered[index]);
        String animalID = filtered[index].documentID;

        if(["Dead", "Sold"].contains(animal.animalStatus))
          return Container();

        return CattlePageBodyState (
         child: CattleDisplay(animal, animalID, widget.docKey),
         onAnimalAdded: _setBody,
        );
      },
    );
  }

  Widget _buildAllCattleDisplayBody() {
    return StreamBuilder<QuerySnapshot> (
      stream: Firestore.instance
        .collection("users")
        .where("authUID", isEqualTo: widget.currentUser.uid)
        .snapshots(),
      
      builder: (_, AsyncSnapshot<QuerySnapshot> userSnapshot) {

        if (!userSnapshot.hasData)
          return Text(AppLocalizations.of(context).loading);

        String id = userSnapshot.data.documents[0].documentID;
        return _fetchFemaleCattleAndGenerateDisplay(id);
      }
    );
  }

  Widget _buildArchivedCattleDisplayBody() {
    return StreamBuilder<QuerySnapshot> (
      stream: Firestore.instance
        .collection("users")
        .where("authUID", isEqualTo: widget.currentUser.uid)
        .snapshots(),
      
      builder: (_, AsyncSnapshot<QuerySnapshot> userSnapshot) {

        if (!userSnapshot.hasData)
          return Text(AppLocalizations.of(context).loading);

        String id = userSnapshot.data.documents[0].documentID;
        return _fetchArchivedCattleAndGenerateDisplay(id);
      }
    );
  }

  void _setBody(Animal animal, String animalIDProvided) {

    setState(() {
      visible = false;
      isAnimal = true;
      animalID = animalIDProvided;
      body = CattlePageBodyState (
        child: CattleDisplay(animal, animalIDProvided, widget.docKey),
        onAnimalAdded: _setBody,
      );
    });
  }

  void _setBodyAll() {
    setState(() {
      visible = true;
      body = _buildAllCattleDisplayBody();
    });
  }

  void _setBodyArchived() {
    setState(() {
      visible = false;
      isAnimal = false;
      body = _buildArchivedCattleDisplayBody();
    });
  }

  Widget _fetchFemaleCattleAndGenerateDisplay(String id) {
    return StreamBuilder(
      stream: Firestore.instance
        .collection("animals")
        .where("userID", isEqualTo: id)
        .where("gender", isEqualTo: "Female")
        .snapshots(),

      builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData)
          return Text(AppLocalizations.of(context).loading);

        return _buildCounters(context, snapshot);
      }
    );
  }

  Widget _fetchArchivedCattleAndGenerateDisplay(String id) {
    return StreamBuilder(
      stream: Firestore.instance
        .collection("animals")
        .where("userID", isEqualTo: id)
        .snapshots(),

      builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData)
          return Text(AppLocalizations.of(context).loading);

        Size size = MediaQuery.of(context).size;

        List<Widget> children = snapshot.data.documents
          .where((DocumentSnapshot snapshot) => 
            snapshot.data["animalStatus"] != ""
          )
          .map((DocumentSnapshot snap) => 
            ArchivedCattleDetails(Animal.fromData(snap), snap.documentID, size))
            .toList();

        return Column(children: children);
      }
    );
  }

  Widget _buildCounters(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    return StreamBuilder<DocumentSnapshot> (
    stream: Firestore.instance
      .collection("Logics")
      .document("logics")
      .snapshots(),
      
    builder: (_, AsyncSnapshot<DocumentSnapshot> snap) {
      if (!snap.hasData) return Text(AppLocalizations.of(context).loading);

      List<Animal> animals = snapshot.data.documents
          .map((document) =>  Animal.fromData(document))
          .toList();
      
      List<Animal> healthyFemales = animals
        .where((Animal animal) => 
          animal.animalStatus != "Sold" && 
          animal.animalStatus != "Dead"
        )
        .toList();

      List<Animal> notMilkingList = healthyFemales
        .where((Animal animal) => 
          animal.isMilking != "Yes"
        ).toList();
      
      List<Animal> milking = healthyFemales
        .where((Animal animal) => 
          animal.isMilking == "Yes"
      ).toList();

      List<Animal> pregnancyList = healthyFemales
        .where((Animal animal) => 
        (animal.isPregnant != null
          ? animal.isPregnant
          : false)
      )
        .toList();

      
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNotMilkingCount(notMilkingList),
          _buildMilkingCount(milking),
          _buildPregnancyCount(pregnancyList),
          //_buildPregnancyList(notMilkingList, snap.data),
        ],
      );
    }
  );
  }
  
  // TODO Should modularize the following 3 functions. For space concerns. 

  Widget _buildNotMilkingCount(List<Animal> list) {
    String lengthStr = list.length.toString();
    lengthStr = lengthStr.length > 1 
      ? lengthStr 
      : "0" + lengthStr;

    return ListTile(
      title: Text(
        AppLocalizations.of(context).dryAnimals,
        style: const TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w600
        ),
      ),
      subtitle: Text(
        lengthStr,
        style: const TextStyle(
          fontSize: 32.0
        ),
      )
    );
  }

  Widget _buildMilkingCount(List<Animal> milkingList) {
    String lengthStr = milkingList.length.toString();
    lengthStr = lengthStr.length > 1 
      ? lengthStr 
      : "0" + lengthStr;

    return ListTile(
      title: Text(
        AppLocalizations.of(context).milkingAnimals,
        style: const TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w600
        ),
      ),
      subtitle: Text(
        lengthStr,
        style: const TextStyle(
          fontSize: 32.0
        ),
      ),
    );
  }

  Widget _buildPregnancyCount(List<Animal> pregnant) {
    String lengthStr = pregnant.length.toString();

    lengthStr = lengthStr.length > 1 
      ? lengthStr 
      : "0" + lengthStr;

    return ListTile(
      title: Text(
        AppLocalizations.of(context).pregnantAnimals,
        style: const TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w600
        ),
      ),
      subtitle: Text(
        lengthStr,
        style: const TextStyle(
          fontSize: 32.0
        ),
      )
    );
  }

  void getSharedPreferences() async {
    dataSet.clear();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    DateTime dateTime = DateTime.now();
    String currDate = dateTime.day.toString() + "/"
        + dateTime.month.toString() + "/"
        + dateTime.year.toString().substring(2,4);
    List<String> allData = preferences.getStringList("animalYield");
    if(allData == null)
      return;
    for(int i = 0; i < allData.length; i++) {
      String data = allData[i];
      var splitData = data.split(" && ");
      if(splitData[0] == animalID && splitData[1] == currDate) {
        //setState(() {
        dataSet.addAll(splitData);
        //});
        break;
      }
    }
  }

  Widget _buildGraphSectionSingle(BuildContext context) {
    String id = animalID;
    String collectionName = 'animalYieldGraph';
    String idName = 'animalID';
    //getSharedPreferences();
    List<YieldPoint> points = List();
    points.add(YieldPoint("0/0/00", 1.0));
    children.clear();
    children.add(_buildSingleGraphContent(id, collectionName, idName, points));

    if (_time != null) {
      children.add(
          Padding(
              padding: EdgeInsets.only(top: 5.0, left: 25.0),
              child: Text(AppLocalizations.of(context).date + _time)
          )
      );
    }
    _measures?.forEach((String series, num value) {
      children.add(
          Padding(
              padding: EdgeInsets.only(top: 5.0, left: 25.0),
              child: Text('${AppLocalizations.of(context).yields}: ${value}')
          )
      );
    });
    return Column(
      children: children
    );
  }

  Widget _buildSingleGraphContent(String animalID, String collectionName, String idName, List<YieldPoint> points) {
      return Container(
      padding: EdgeInsets.only(left: 20.0),
      constraints: BoxConstraints(
          maxHeight: 300.0,
          maxWidth: MediaQuery.of(context).size.width - 20,
          minHeight: 0.0,
          minWidth: 0.0
      ),
      child: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection(collectionName)
            .where(idName, isEqualTo: animalID)
            .snapshots(),
        builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
          if(!snapshot.hasData)
            return Text(AppLocalizations.of(context).loading);
          List<DocumentSnapshot> documents = snapshot.data.documents;
          points.clear();
          points.add(YieldPoint("0/0/00", 0.0));
          if(documents.length > 0) {
            YieldSet set = YieldSet.fromData(documents[0]);

            List<String> timeList = set.monthYearList;
            List<String> yieldList = set.yieldList;
            if(dataSet.length != 0) {
              timeList.add(dataSet[1]);
              yieldList.add(dataSet[2]);
            }

            points.clear();
            for(int i = 0; i < timeList.length; i++) {
              double val = double.parse(yieldList[i]);
              points.add(new YieldPoint(timeList[i], val));
            }
          }
          for(int i = 0; i < points.length; i++) {
            YieldPoint yieldPoint = points[i];
            if(yieldPoint.time == null ||
                yieldPoint.time.split('/').length != 3 ||
                yieldPoint.quantity == 0.0
            ) {
              points.remove(yieldPoint);
            }

          }
          if(points.length == 0)
            points.add(YieldPoint("0/0/00", 0.0));
          List<charts.Series<YieldPoint, DateTime>> series = [
            charts.Series<YieldPoint, DateTime>(
                id: "Yields",
                colorFn: (_, __) => charts.Color(r: 91, g: 190,b: 133,a: 255),
                domainFn: (YieldPoint yieldPoint, _) {
                  var time = yieldPoint.time.toString().split('/');
                  if(time.length != 3)
                    return null;
                  DateTime curr = new DateTime(
                      int.parse('20' + time[2]),
                      int.parse(time[1]),
                      int.parse(time[0])
                  );
                  return curr;
                },
                measureFn: (YieldPoint yieldPoint, _) => yieldPoint.quantity,
                data: points
            )
          ];

          YieldPoint initPoint = points[0];
          var time = initPoint.time.toString().split('/');
          if(time.length != 3)
            return null;
          DateTime initDate = new DateTime(
              int.parse('20' + time[2]),
              int.parse(time[1]),
              int.parse(time[0])
          );

          charts.TimeSeriesChart chart = charts.TimeSeriesChart(
            series,
            animate: true,
            selectionModels: [
              new charts.SelectionModelConfig(
                type: charts.SelectionModelType.info,
                listener: _onSelectionChanged,
              )
            ],
            behaviors: [
              charts.LinePointHighlighter(

                showHorizontalFollowLine:
                  charts.LinePointHighlighterFollowLineType.nearest,
                showVerticalFollowLine:
                  charts.LinePointHighlighterFollowLineType.nearest
              ),
              charts.SelectNearest(
                eventTrigger:
                  charts.SelectionTrigger.tapAndDrag
              )
            ],
          );
          return chart;
        },
      ),
    );
  }

  _onSelectionChanged(charts.SelectionModel model) {
    final selectedDatum = model.selectedDatum;
    String time;
    final measures = <String, double>{};
    if (selectedDatum.isNotEmpty) {
      time = selectedDatum.first.datum.time;
      selectedDatum.forEach((charts.SeriesDatum datumPair) {
        measures[datumPair.series.displayName] = datumPair.datum.quantity;
      });
    }

    // Request a build.
    setState(() {
      _time = time;
      _measures = measures;
    });
  }

}