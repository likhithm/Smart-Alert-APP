import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String userID;
  String userName;
  String encodedImage;
  String distance;
  String city;
  String tag;
  String message;
  String animalID;
  DateTime postDate;
  List<dynamic> imgURLs;
  List<Map<dynamic, dynamic>> comments;
  List<Map<String, dynamic>> lastComments;
  Map<dynamic, dynamic> likes;

  bool hasData;


  Post(
      this.userID,
      this.userName,
      this.encodedImage,
      this.postDate,
      this.tag,
      this.message,
      this.imgURLs,
      this.comments,
      this.lastComments,
      this.distance,
      this.city,
      this.likes,
      this.hasData,
      this.animalID
  );

  Post.fromData(DocumentSnapshot document) {
    userID = document['userID'];
    userName = document['userName'];
    encodedImage = document['encodedImage'];
    postDate = DateTime.fromMillisecondsSinceEpoch(int.parse(document['postDate']));
    message = document['message'];
    tag = document['tag'];
    imgURLs = document['imgURLs'];
    likes = new Map<String, String>.from(document['likes']);
    distance = document['distance'];
    city = document['city'];
    comments = new List<Map<dynamic, dynamic>>.from(document['comments']);
    hasData = document['hasData'];
    animalID = document['animalID'];
  }
}