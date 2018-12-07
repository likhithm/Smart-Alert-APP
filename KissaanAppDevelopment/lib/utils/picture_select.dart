import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:kissaan_flutter/locale/locales.dart';

import 'package:kissaan_flutter/utils/image_process.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:async';

class picture_select extends StatefulWidget {
  final List<String> srcList;
  final bool userOrCattle;
  picture_select(this.srcList, this.userOrCattle);

  @override
  State<StatefulWidget> createState() => _PictureState(srcList, userOrCattle);
}

class _PictureState extends State<picture_select>{
  File image;
  bool userOrCattle;
  List<String> srcList;
  _PictureState(this.srcList, this.userOrCattle);

  _chooseSource() {
    return showDialog<Null>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return  AlertDialog(
          title: Text(AppLocalizations.of(context).chooseSource),
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
    img = await _cropImage(img);

    //handle this in the future when just open the gallery with picking and then close
    ImageProperties properties = await FlutterNativeImage.getImageProperties(img.path);
    File compressedFile = await FlutterNativeImage.compressImage(img.path, quality: 100,
        targetWidth: 700, targetHeight: (properties.height * 700 / properties.width).round());
    image = compressedFile;

    //here is the binary code for the image, u can use it for insersion in firebase
    String res = await imgToBinary(compressedFile);

    srcList[0] = res;
    setState((){});
    Navigator.of(context, rootNavigator: true).pop();
  }

  Future<File> _cropImage(File imgFile) async {
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: imgFile.path,
      ratioX: 1.0,
      ratioY: 1.0,
      toolbarTitle: AppLocalizations.of(context).cropImage,
      toolbarColor: Colors.blue,
    );
    return croppedFile;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //width: 100.0,
      //height: 100.0,
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: () {
          _chooseSource();
        },
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: EdgeInsets.all(10.0),
            child: CircleAvatar(
              radius: 75.0,
              backgroundImage: srcList[0].length==0?AssetImage("assets/icons/all_cattle.png"):MemoryImage(base64.decode(srcList[0])),
            )
        )
      ),

    );
  }

}