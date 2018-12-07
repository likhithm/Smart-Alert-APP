import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:kissaan_flutter/locale/locales.dart';
import 'package:kissaan_flutter/newsfeed/utils/post_header_state.dart';
import 'package:kissaan_flutter/newsfeed/widgets/report_dialog.dart';
import 'package:kissaan_flutter/utils/YieldPoint.dart';
import 'package:kissaan_flutter/utils/YieldSet.dart';
import 'package:kissaan_flutter/newsfeed/widgets/post_header_widget.dart';
import 'package:kissaan_flutter/newsfeed/widgets/post_interaction.dart';
import 'package:kissaan_flutter/newsfeed/model_classes/Post.dart';
import 'package:kissaan_flutter/newsfeed/widgets/post_image_widget.dart';
import 'package:kissaan_flutter/newsfeed/utils/post_image_state.dart';
import 'package:kissaan_flutter/newsfeed/widgets/post_dialog.dart';
import 'package:kissaan_flutter/widgets/drawer_builder.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info/device_info.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:kissaan_flutter/newsfeed/widgets/web_view.dart';



class NewsfeedPage extends StatefulWidget {

  final FirebaseUser currentUser;
  final String docKey;
  final double paddingH = 8.0;
  final String userName;

  final Map<String, dynamic> post = new Map();

  NewsfeedPage(this.currentUser, this.docKey, this.userName);

  @override
  _NewsfeedPageState createState() => _NewsfeedPageState();
}

class _NewsfeedPageState extends State<NewsfeedPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  Size size;
  Color colorEvent, colorSell, colorGeneral;
  String _time;
  String binaryCode, lang, tip = "", category = "General";
  bool hasLoaded = false, _isLoading = true;
  bool notNull(Object o) => o != null;

  DocumentSnapshot _lastVisible = null;

  List<DocumentSnapshot> _data = new List();
  List<Widget> widgetList = new List();
  List<Post> postList = new List();
  List<String> dataSet = new List();
  List<Widget> children = new List();
  Map<String, int> postMap = new Map();
  Map<String, double> _measures;

  ScrollController _feedController;
  ScrollController controller = new ScrollController();


  @override
  initState() {
    super.initState();
    controller = new ScrollController()..addListener(_scrollListener);
    _feedController = ScrollController();
    Firestore.instance
        .collection("users")
        .document(widget.docKey)
        .get()
        .then((DocumentSnapshot snapshot) {
      setState(() {
        binaryCode = snapshot.data['encodedImage'];
      });
    });
    _isLoading = true;
    _getData();
    DeviceInfoPlugin info = DeviceInfoPlugin();
    info.androidInfo.then((deviceInfo) {
    });
  }

  @override
  dispose() {
    _feedController.dispose();
    controller.removeListener(_scrollListener);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(!hasLoaded) {
      hasLoaded = true;
      getLocaleCode();
    }
    bool showFab = MediaQuery.of(context).viewInsets.bottom == 0.0;
    size = MediaQuery.of(context).size;

    ThemeData theme = Theme.of(context);
    double height = MediaQuery.of(context).size.height;

    return Scaffold(

      key: scaffoldKey,
      floatingActionButton: showFab?FloatingActionButton(
        onPressed: _openPostDialog,
        child: Image.asset('assets/icons/post.png')
      ): Container(),
      drawer: DrawerBuilder(widget.currentUser, widget.docKey),
      body: SizedBox(
        height: size.height,
        child: NestedScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return <Widget>[
              SliverOverlapAbsorber(
                handle: NestedScrollView
                  .sliverOverlapAbsorberHandleFor(context),
                child: PreferredSize(
                  child: SliverAppBar(
                    backgroundColor: theme.accentColor,
                    title: _buildAppBar(theme.accentColor),
                  ),
                  preferredSize: Size.fromHeight(10.0)
                )
              )
            ];
          },
          body: Column(
            children: <Widget>[
              Container(
                constraints: BoxConstraints(maxHeight: 1.5 * height/4),
                child: _buildTipSection(size),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  InkWell(
                    onTap: (){
                      setState(() {
                        colorEvent = Colors.greenAccent;
                        colorSell = Colors.grey;
                        colorGeneral = Colors.grey;
                      });
                      _chooseCategory(0);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25.0),
                          color: colorEvent
                      ),
                      child: Text(AppLocalizations.of(context).event, textAlign: TextAlign.center,),
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      setState(() {
                        colorEvent = Colors.grey;
                        colorSell = Colors.greenAccent;
                        colorGeneral = Colors.grey;
                      });
                      _chooseCategory(1);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25.0),
                          color: colorSell
                      ),
                      child: Text(AppLocalizations.of(context).buySell, textAlign: TextAlign.center,),
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      setState(() {
                        colorEvent = Colors.grey;
                        colorSell = Colors.grey;
                        colorGeneral = Colors.greenAccent;
                      });
                      _chooseCategory(2);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25.0),
                          color: colorGeneral
                      ),
                      child: Text(AppLocalizations.of(context).general, textAlign: TextAlign.center,),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: _buildNewsFeed(),
              ),
              Divider(height: 10.0,),
            ],
          )
        ),
      ),

    );
  }

  void _chooseCategory(int cate) async {
    switch(cate) {
      case 0:
        category = "Event";
        break;
      case 1:
        category = "Buy/Sell";
        break;
      case 2:
        category = "General";
        break;
    }
    _data.clear();
    postList.clear();
    postMap.clear();
    widgetList.clear();
    _lastVisible=null;
    await _getData();
    _contentList();
  }

  void _scrollListener() {
    if (!_isLoading) {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        setState(() => _isLoading = true);
          _getData();
      }
    }
  }

  Widget _buildAppBar(Color color) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(widget.userName),
          //_buildProfilePicture(binaryCode)
        ],
      ),
    );
  }


  void _openPostDialog() async {
    await Navigator.of(context)
      .push(MaterialPageRoute<Map<String, String>>(
        builder: (BuildContext context) {
          return PostDialog(widget.docKey, binaryCode, widget.userName);
        },
        fullscreenDialog: false
      )
    );
    _data.clear();
    postList.clear();
    postMap.clear();
    widgetList.clear();
    _lastVisible=null;
    await _getData();
    _contentList();
  }

  void _removePost(Post post) async{
    setState(() {
      int loc = postList.indexOf(post);
      postList.removeAt(loc);
      _data.removeAt(loc);
    });
  }

  void _reportPost(String postID, Post post) async{
    Map<String, String> fields;
    fields = await Navigator.of(context)
        .push(MaterialPageRoute<Map<String,String>>(
        builder: (BuildContext context) {
          return ReportDialog(postID, post);
        },
        fullscreenDialog: false
    ));
    if(fields == null)
      return;
    final DocumentReference reference = Firestore.instance
        .collection('reportedPosts').document(postID);
    DocumentSnapshot snapshot = await reference.get();
    List<String> reportDetails = new List();
    String reportEntry = widget.docKey + " + "
        + fields['description'];// + " + " + fields[1];
    reportDetails.add(reportEntry);
    if(!snapshot.exists) {
      Map<String, dynamic> data = new Map();
      data.putIfAbsent('postID', () => postID);
      data.putIfAbsent('reportDetails', () => reportDetails);
      data.putIfAbsent('count', () => 1);
      reference.setData(data);
    }
    else {
      Firestore.instance.runTransaction((Transaction tx) async {
        DocumentSnapshot snapshot = await tx.get(reference);
        if (snapshot.exists) {
          int num = snapshot.data['count'];
          reportDetails.addAll(List.from(snapshot.data['reportDetails']));
          await tx.update(reference, <String, dynamic>{
            "count": num + 1,
            "reportDetails": reportDetails}
          );
        }
      });
    }
  }

  Widget _buildNewsFeed() {
    return RefreshIndicator(
      child: ListView.builder(
        controller: controller,
        itemCount: _data.length + 1,
        itemBuilder: (_, int index) {
          if (index < _data.length) {
            final DocumentSnapshot document = _data[index];
            String postID = document.documentID;
            Post post = postList[index];
            return _buildPost(post, postID);
          }
          return Center(
            child: new Opacity(
              opacity: _isLoading ? 1.0 : 0.0,
              child: new SizedBox(
                  width: 32.0,
                  height: 32.0,
                  child: new CircularProgressIndicator()),
            ),
          );
        },
      ),
      onRefresh: ()async{
        _data.clear();
        postList.clear();
        postMap.clear();
        _lastVisible=null;
        await _getData();
      },
    );
  }

  Future<Null> _getData() async {
    QuerySnapshot data;
    if(category == 'General') {
      if (_lastVisible == null)
        data = await Firestore.instance
            .collection('posts')
            .orderBy("postDate", descending: true)
            .limit(5)
            .getDocuments();
      else
        data = await Firestore.instance
            .collection('posts')
            .orderBy("postDate", descending: true)
            .startAfter([_lastVisible['postDate']])
            .limit(5)
            .getDocuments();
    }
    else {
      if (_lastVisible == null)
        data = await Firestore.instance
            .collection('posts')
            .where('tag', isEqualTo: category).orderBy(
            "postDate", descending: true)
            .limit(5)
            .getDocuments();
      else
        data = await Firestore.instance
            .collection('posts')
            .where('tag', isEqualTo: category).orderBy(
            "postDate", descending: true)
            .startAfter([_lastVisible['postDate']])
            .limit(5)
            .getDocuments();
    }
    if (data != null && data.documents.length > 0) {
      _lastVisible = data.documents[data.documents.length - 1];
      if (mounted) {
        setState(() {
          _isLoading = false;
          for(DocumentSnapshot snapshot in data.documents) {
            _data.add(snapshot);
            String postID = snapshot.documentID;
            Post post = Post.fromData(snapshot);
            postList.add(post);
            postMap.putIfAbsent(postID, ()=>postList.length - 1);
          }
        });
      }
    } else {
      if(mounted) {
        setState(() => _isLoading = false);
      }
    }
    return null;
  }

  Widget _buildPost(Post post, String postID) {
    Card card;
    bool isForSale = false;
    if(post.hasData != null && post.hasData)
      isForSale = true;


    card = Card(
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      elevation: 8.0,
      color: Colors.white,
      child: Container(
        margin: const EdgeInsets.fromLTRB(
          15.0, 20.0, 15.0, 0.0
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PostHeaderState(
              post: post,
              postID: postID,
              userID: widget.docKey,
              removePost: _removePost,
              reportPost: _reportPost,
              child: PostHeaderWidget(),
            ),
            SizedBox(height: 10.0,),
            Linkify(
              text: post.message,
              onOpen: (url) async {
                if (await canLaunch(url)) {
                 // await launch(url);
                  await Navigator.of(context)
                      .push(MaterialPageRoute<Map<String, String>>(
                      builder: (BuildContext context) {
                        return WebView(url);
                      },
                      fullscreenDialog: false
                  )
                  );
                }
                 else {
                  throw 'Could not launch $url';
                }
              },
            ),


            PostImageState(
              post: post,
              child: PostImageWidget(),
            ),
            isForSale?_buildGraphSectionSingle(post, context):Container(),
            PostInteraction(post, widget.docKey, postID, widget.userName),
          ].where(notNull).toList()
        ),
      )
    );
    return card;
  }

  Widget _buildGraphSectionSingle(Post post, BuildContext context) {
    String id = post.animalID;
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
                yieldPoint.quantity == 0.0) {
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
    setState(() {
      _time = time;
      _measures = measures;
    });
  }

  Widget _buildTipSection(Size size) {
    return ExpansionTile(
      initiallyExpanded: false,
      title: Text(AppLocalizations.of(context).checkTipOfDay),
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 15.0
          ),
          constraints: BoxConstraints(
            maxHeight: size.height/4.5,
            minWidth: size.width
          ),
          child: _buildTipOfTheDay()
        )
      ],
    );


  }

  Widget _buildTipOfTheDay() {
    return StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance
        .collection("tips")
        .document("tipOfTheDay")
        .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return TipOfTheDay(AppLocalizations.of(context).checkUpdateToDate);

        Map<String, dynamic> fields = snapshot.data.data;
        if(fields != null)
          tip = fields[lang];
        return getTipOfTheDay();
      },
    );
  }

  Widget getTipOfTheDay() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          "assets/icons/tip_icon.png",
          width: 50.0
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            tip!=null?tip:AppLocalizations.of(context).checkTipOfDay,
            textAlign: TextAlign.center,
            style: TextStyle(
              //font size of 18 will cause overflow for phone with small
              //screen, so please keep it to 14.
                fontSize: 14.0
            )
          ),
        )
      ]
    );
  }

  void getLocaleCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    lang = prefs.getString("locale");
    if(lang == null || lang == '')
      lang = 'en_AU';
  }



  List<Widget> _contentList() {
    widgetList.clear();
    for(int i = 0; i <= _data.length; i++) {
      if(i < _data.length) {
        final DocumentSnapshot document = _data[i];
        String postID = document.documentID;
        Post post = postList[i];
        widgetList.add(_buildPost(post, postID));
      }
      else {
        Center center = Center(
          child: new Opacity(
            opacity: _isLoading ? 1.0 : 0.0,
            child: new SizedBox(
                width: 32.0,
                height: 32.0,
                child: new CircularProgressIndicator()),
          ),
        );
        widgetList.add(center);
      }
    }

    return widgetList;
  }
  Widget _buildNewsFeed1() {
    return RefreshIndicator(
      child: ListView(
        //controller: controller,
        children: _data.map((item) => _buildPost(postList[_data.indexOf(item)], item.documentID)).toList(),
      ),
      onRefresh: ()async{
        _data.clear();
        postList.clear();
        postMap.clear();
        _lastVisible=null;
        await _getData();
        _contentList();
      },
    );
  }
}

class TipOfTheDay extends StatelessWidget {
  final String tip;
  TipOfTheDay(this.tip);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Image.asset(
            "assets/icons/tip_icon.png",
            width: 50.0
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
              tip,
              textAlign: TextAlign.center,
              style: TextStyle(
                //font size of 18 will cause overflow for phone with small
                //screen, so please keep it to 14.
                fontSize: 14.0
              )
          ),
        )
      ]
    );
  }
}