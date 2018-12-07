import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kissaan_flutter/locale/locales.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:kissaan_flutter/utils/image_process.dart';

class PostDialog extends StatefulWidget {
  final String userID;
  final String encodedImage;
  final String userName;

  PostDialog(this.userID, this.encodedImage, this.userName);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PostDialogState();
  }

}

class PostDialogState extends State<PostDialog> {
  TextEditingController _commentController = TextEditingController();
  String tag, btnText;
  int maxImageNo = 9;
  List<Asset> images = [];
  List<Uint8List> imgList = [];
  List<File> imgFiles = [];
  List<String> imgURLs = [];
  Color colorEvent = Colors.grey;
  Color colorSell = Colors.grey;
  Color colorGeneral = Colors.grey;
  bool isClickable = true, set = false;

  @override
  void initState() {
    super.initState();
    tag = "General";
  }

  @override
  void dispose() {
    super.dispose();
    _commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(!set) {
      btnText = AppLocalizations
          .of(context)
          .post;
      set = true;
    }
    Size size = MediaQuery.of(context).size;
    // TODO: implement build
    Color g = Theme.of(context).accentColor;

    return Scaffold(
      appBar: _buildButtonSection(context, size),
      body: ListView(
        children: <Widget>[
          _buildCommentField(),
          _buildPicField(),
          _buildTagField(g)
        ]   
      )
    );
  }

  Widget _buildButtonSection(BuildContext context, Size size) {
    return AppBar(
      title: Text(AppLocalizations.of(context).addPost),
      backgroundColor: Color.fromRGBO(91,190,133,1.0),
      actions: [
        FlatButton(
          child: Text(
            btnText,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white
            ),
          ),
          onPressed: _onPostPressed,
        ),            
      ],
    );
  }

  void _onPostPressed() async{
    Completer completer = new Completer();

    if(isClickable) {
      setState(() {
        btnText = AppLocalizations.of(context).sending;
        isClickable = false;
      });
    }
    else
      return;
    for(File file in imgFiles) {
      await saveImages(file);
    }
    Map<String, dynamic> data = {};
    data.putIfAbsent('userName', ()=>widget.userName);
    data.putIfAbsent('userID', ()=>widget.userID);
    data.putIfAbsent('encodedImage', ()=>widget.encodedImage);
    data.putIfAbsent('city', ()=>'');
    data.putIfAbsent('distance', ()=>'0');
    data.putIfAbsent('message', ()=>_commentController.text.toString());
    data.putIfAbsent('postDate', (){
      DateTime currTime = DateTime.now();
      String retVal = currTime.millisecondsSinceEpoch.toString();
      return retVal;
    });
    data.putIfAbsent('tag', ()=>tag);
    List<Map<String, String>> comments = [];
    Map<String, String> likes = {};
    List<String> lastComments = [];
    data.putIfAbsent('comments', ()=>comments);
    data.putIfAbsent('likes', ()=>likes);
    data.putIfAbsent('imgURLs', ()=>imgURLs);
    data.putIfAbsent('lastComments', ()=>lastComments);

    Firestore.instance
        .collection('posts')
        .add(data)
        .then((result){
          Navigator.of(context).pop();
    });
  }

  void saveImages(File imgFile) async{
    String stamp = widget.userID + DateTime.now().millisecondsSinceEpoch.toString();
    final StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('posts').child(stamp);
    StorageUploadTask task =
      firebaseStorageRef.putFile(imgFile);
    String downloadUrl = await (await task.onComplete).ref.getDownloadURL();
    String urlStr = downloadUrl;
    imgURLs.add(urlStr);
  }

  Widget _buildCommentField() {
    return Container(
      padding: const EdgeInsets.only(
        top: 30.0, 
        left: 30.0, 
        right: 30.0, 
        bottom:20.0
      ),
      child: TextFormField(
        controller: _commentController,
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(bottom: 10.0),
            hintText: AppLocalizations.of(context).inMind,
            labelStyle: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500)
        ),
      ),
    );
  }

  Widget _buildPicField() {
    return Container(
      constraints: BoxConstraints(maxHeight: 400.0, maxWidth: 400.0),
      child:GridView.count(
        crossAxisCount: 3,
        children: _buildGridTiles(imgFiles),
      )
    );
  }

  List<Container> _buildGridTiles(List<File> images) {

    List<Container> containers = List<Container>.generate(images.length, (int index) {
      return Container(
        padding: const EdgeInsets.all(10.0),
        child: SizedBox(
          height: 300.0,
          width: 400.0,
          child: Image.file(
            images[index],
            fit: BoxFit.fill,
          ),
        ),
      );
    });
    containers.add(_buildAddPic());
    return containers;
  }

  Widget _buildAddPic() {
    return Container(
      child: InkResponse(
          enableFeedback: true,
          child: Image.asset('assets/icons/add.png'),
          onTap: _chooseSource
      )
    );
  }

  _chooseSource() {
    return showDialog<Null>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return  AlertDialog(
          title:  Text(AppLocalizations.of(context).chooseSource),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                FlatButton(
                  child: Text(AppLocalizations.of(context).camera),
                  onPressed: () {
                    picker(true);
                  },
                ),
                FlatButton(
                  child: Text(AppLocalizations.of(context).gallery),
                  onPressed: () {
                    picker(false);
                  },
                ),
              ],
            )
          ),
        );
      },
    );
  }

  picker(bool cameraOrGallery) async {
    ImageSource source = ImageSource.camera;
    if(!cameraOrGallery)
      source = ImageSource.gallery;
    File img = await ImagePicker.pickImage(source: source);
    File compressed = await formatUploadImage(img, 1000000, widget.userID);
    //here is the binary code for the image, u can use it for insersion in firebase
    setState((){
      imgFiles.add(compressed);
    });
    Navigator.of(context, rootNavigator: true).pop();
  }

  void initSinglePickUp() async {

  }


  void initMultiPickUp() async {
    List<Asset> resultList;
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: maxImageNo,
        enableCamera: false,
      );
    } on PlatformException catch (e) {
      String error = e.message.toString();
    }


    if (!mounted) return;

    images.addAll(resultList);
    maxImageNo = 9 - images.length;
    List<Uint8List> tempList = List();
    for(Asset asset in images) {
      ByteData data = await asset.requestOriginal();
      Uint8List imgData = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      tempList.add(imgData);
    }
    setState((){
      imgList.addAll(tempList);
    });
  }

  Widget _buildTagField(Color g) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          InkWell(
            onTap: (){
              setState(() {
                colorEvent = g;
                colorSell = Colors.grey;
                colorGeneral = Colors.grey;
                tag = "Event";
              });
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
                colorSell = g;
                colorGeneral = Colors.grey;
                tag = "Buy/Sell";
              });
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
                colorGeneral = g;
                tag = "General";
              });
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
    );
  }
}