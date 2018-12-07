import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as Images;
import 'package:path_provider/path_provider.dart';

  Container binaryToImage(String base64Image, bool userOrCattle) {
    if(base64Image == null)
      return Container(
        child: CircleAvatar(
          radius: userOrCattle
          ? 75.0
          : 25.0,
          backgroundImage: userOrCattle
            ? AssetImage("https://via.placeholder.com/400x200")
            : AssetImage("assets/icons/all_cattle.png"),
        )
      );
    Uint8List bytes = base64.decode(base64Image);

    return Container(
      padding: EdgeInsets.all(userOrCattle?10.0:0.0),
      child: CircleAvatar(
        radius: userOrCattle?75.0:26.0,
        backgroundImage: bytes.length==0
          ? AssetImage("assets/icons/cattle.png")
          : MemoryImage(bytes),
      )
    );
  }

  Container cattleImage(String base64Image, String type, {bool isBig = false}) {
    if (base64Image == null) {
      String image = type == "Cow"
      ? "assets/icons/cattle.png"
      : "assets/icons/buffalo.jpg";

    return Container(
      padding: EdgeInsets.all(0.0),
      child: CircleAvatar(
        radius: !isBig ? 26.0 : 100.0,
        backgroundImage: AssetImage(image)
      )
    );
    }
    Uint8List bytes = base64.decode(base64Image);

    return Container(
      padding: EdgeInsets.all(0.0),
      child: CircleAvatar(
        radius: !isBig ? 26.0 : 35.0,
        backgroundImage: bytes.length==0
          ? AssetImage("assets/icons/cattle.png")
          : MemoryImage(bytes),
      )
    );
    
  }

  
  Container binaryToImageSize(String base64Image, double radius) {
    if(base64Image == null)
      return Container(
        child: CircleAvatar(
          radius: radius,
          child: ImageIcon(AssetImage("assets/icons/cattle.png")),
        )
      );
    Uint8List bytes = base64.decode(base64Image);
    return Container(
      padding: EdgeInsets.all(0.0),
      child: CircleAvatar(
        radius: radius,
        backgroundImage: bytes.length==0?NetworkImage("https://via.placeholder.com/400x200"):MemoryImage(bytes),
      )
    );
  }

  Widget binaryToAppbarImage(String base64Image) {
    if (base64Image == null)
      return Container(
        padding: EdgeInsets.only(top: 5.0),
        child: CircleAvatar(
          radius: 25.0,
          child: Icon(Icons.person),
        )
      );
    Uint8List bytes = base64.decode(base64Image);
    return CircleAvatar(
      radius: 25.0,
      backgroundImage: bytes.length==0?NetworkImage("https://via.placeholder.com/400x200"):MemoryImage(bytes),
    );
  }

  Widget binaryToDrawerImage(String base64Image) {
    if (base64Image == null)
      return Container(
        child: CircleAvatar(
          radius: 50.0,
          child: Icon(Icons.person, size: 100.0,),
        )
      );
    Uint8List bytes = base64.decode(base64Image);
    return CircleAvatar(
      radius: 25.0,
      backgroundImage: bytes.length==0?NetworkImage("https://via.placeholder.com/400x200"):MemoryImage(bytes),
    );
  }

  Future<String> imgToBinary(File imageFile) async{

    List<int> imageBytes = imageFile.readAsBytesSync();
    String base64Image = base64Encode(imageBytes);
    //Firestore.instance.collection(location).document(id).setData({"encodedImage": base64Image});
    return base64Image;
  }

  Future<File> formatUploadImage(File file, int limit, String identifier) async{
    int len = await file.length();
    double ratio = limit/len > 1 ? 1 : limit/len;
//    Images.Image img = Images.decodeImage(file.readAsBytesSync());
//    print("decoded!!!!!!!!");
//    Images.Image compressedImg = Images.copyResize(
//        img,
//        (ratio * img.width).round()
//    );
//    print("compressedImg created !!!!!!!!!!!");
//    print(img.width.toString() + " " + img.height.toString() + ' !!!!!!!!!!');
//    print(compressedImg.width.toString() + " " + compressedImg.height.toString() + ' !!!!!!!!!!');
//
//    //Directory tempDir = await getTemporaryDirectory();
//    //String tempPath = tempDir.path;
//
//    Directory appDocDir = await getApplicationDocumentsDirectory();
//    String appDocPath = appDocDir.path;
//    print("get path!!!!!!!!!!");
//    new File(appDocPath + "/thumbnail.png")
//        ..writeAsBytesSync(Images.encodePng(compressedImg));
//    print("write file !!!!!!!!!");
//    File compressed = new File('thumbnail.png');

    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    int rand = new Random().nextInt(10000);

    Images.Image image = Images.decodeImage(file.readAsBytesSync());
    Images.Image smallerImage = Images.copyResize(image, (ratio * image.width).round()); // choose the size here, it will maintain aspect ratio
    var compressedImage = new File('$path/img_$rand.jpg')
      ..writeAsBytesSync(Images.encodeJpg(smallerImage, quality: (ratio*100).round()));
    print(smallerImage.width.toString() + " " + smallerImage.height.toString() + ' !!!!!!!!!!');
    int len1 = await compressedImage.length();
    return compressedImage;
  }