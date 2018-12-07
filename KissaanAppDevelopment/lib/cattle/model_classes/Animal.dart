import 'package:cloud_firestore/cloud_firestore.dart';

class Animal {
  String animalName;
  String animalType;
  String gender;
  String encodedImage;
  DateTime dateOfBirth;
  DateTime dateOfPurchase;
  String animalBreed;
  String animalStatus;
  DateTime pregnancyDate;
  DateTime nextBreedingDate;
  DateTime lastDeliveryDate;
  String userID;
  String isMilking;
  String insuranceID;
  String animalDescription;
  bool isPregnant;

  Animal(
    this.animalName,
    this.animalType,
    this.gender,
    this.animalBreed,
    this.encodedImage,
    this.animalStatus,
    this.userID,
    this.isPregnant,
    this.animalDescription,
    {this.dateOfBirth, this.dateOfPurchase, this.pregnancyDate, this.nextBreedingDate, this.lastDeliveryDate, this.insuranceID}
  );

  Animal.fromData(DocumentSnapshot document) {
    animalName = document['animalName'];
    animalType = document['animalType'];
    animalBreed = document['animalBreed'];
    animalStatus = document['animalStatus'];
    encodedImage = document['encodedImage'];
    userID = document['ownerID'];
    gender = document['gender'];
    animalDescription = document['animalDescription'];
    isPregnant = document['isPregnant'];
    this.dateOfBirth = (document['birthDate'] != null && document['birthDate'].length > 0)
        ? DateTime.fromMillisecondsSinceEpoch(
        int.parse(document['birthDate'])
    ) : null;

    this.dateOfPurchase = (document['purchaseDate'] != null && document['purchaseDate'].length > 0)
        ? DateTime.fromMillisecondsSinceEpoch(
        int.parse(document['purchaseDate'])
    ) : null;
    
    this.pregnancyDate = document['pregnancyDate'] != null 
    ? DateTime.fromMillisecondsSinceEpoch(
        document['pregnancyDate']
      ) : null;

    this.lastDeliveryDate = document['lastDeliveryDate'] != null 
    ? DateTime.fromMillisecondsSinceEpoch(
        document['lastDeliveryDate']
      ) : null;
    userID = document['userID'];
    isMilking = document['isMilking'];
    this.insuranceID = document['insuranceID'];
  }
}