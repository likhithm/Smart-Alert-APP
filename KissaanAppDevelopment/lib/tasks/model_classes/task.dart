import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  String ownerID;
  String animalName;
  String animalID;
  String encodedImage;
  String taskDescription;
  DateTime taskDate;
  String taskType;
  String taskCategory;
  bool taskActionableYN;
  String taskID;
  String userID;
  String taskTypeCode;

  Task(
    this.ownerID,
    this.animalName,
    this.animalID,
    this.encodedImage,
    this.taskDate,
    this.taskType,
    this.taskActionableYN,
    this.taskDescription,
    this.taskCategory,
    this.taskID,
    this.userID,
    this.taskTypeCode
  );

  Task.fromData(DocumentSnapshot document) {
    ownerID = document['userID'];
    animalName = document['animalName'];
    animalID = document['animalID'];
    encodedImage = document['encodedImage'];
    taskDate = DateTime.fromMillisecondsSinceEpoch(
                  int.parse(document['taskDate'].toString()));
    taskType = document['taskType'];
    taskActionableYN = document['taskActionableYN'].toString() == "Y";
    taskDescription = document['taskDescription'];
    taskCategory = document['taskCategory'];
    taskID = document.documentID;
    userID = document['userID'];
    taskTypeCode = document['taskTypeCode'];
  }
}