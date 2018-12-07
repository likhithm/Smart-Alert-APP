import 'package:cloud_firestore/cloud_firestore.dart';

class Yield {
  String animalID;
  String yieldQty;
  String yieldTime;
  DateTime yieldDate;

  Yield(
      this.animalID,
      this.yieldQty,
      this.yieldTime,
      this.yieldDate,);

  Yield.fromData(DocumentSnapshot document) {
    animalID = document['animalID'];
    yieldQty = document['yieldQty'];
    yieldTime = document['yieldTime'];
    yieldDate = DateTime.fromMillisecondsSinceEpoch(document['yieldDate']);
  }
}