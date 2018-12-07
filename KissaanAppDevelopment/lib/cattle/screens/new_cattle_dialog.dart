import 'dart:async';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kissaan_flutter/cattle/model_classes/Animal.dart';
import 'package:kissaan_flutter/cattle/utils/animal_type_state.dart';
import 'package:kissaan_flutter/cattle/utils/birth_date_state.dart';
import 'package:kissaan_flutter/cattle/utils/breed_state.dart';
import 'package:kissaan_flutter/cattle/utils/cattle_enums.dart';
import 'package:kissaan_flutter/cattle/utils/cattle_name_state.dart';
import 'package:kissaan_flutter/cattle/utils/gender_state.dart';
import 'package:kissaan_flutter/cattle/utils/milking_state.dart';
import 'package:kissaan_flutter/cattle/utils/description_state.dart';
import 'package:kissaan_flutter/cattle/utils/purchase_date_state.dart';
import 'package:kissaan_flutter/cattle/utils/insurance_state.dart';
import 'package:kissaan_flutter/cattle/widgets/insurance_field.dart';
import 'package:kissaan_flutter/cattle/widgets/description_field.dart';
import 'package:kissaan_flutter/cattle/widgets/animal_type_dropdown.dart';
import 'package:kissaan_flutter/cattle/widgets/birth_date_input_field.dart';
import 'package:kissaan_flutter/cattle/widgets/breed_dropdown.dart';
import 'package:kissaan_flutter/cattle/widgets/cattle_name_field.dart';
import 'package:kissaan_flutter/cattle/widgets/gender_picker.dart';
import 'package:kissaan_flutter/cattle/widgets/milking_picker.dart';
import 'package:kissaan_flutter/cattle/widgets/purchase_date_input_field.dart';
import 'package:kissaan_flutter/locale/locales.dart';
import 'package:kissaan_flutter/utils/picture_select.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddCattleDialog extends StatefulWidget {
  final Animal animal;
  AddCattleDialog({this.animal});


  @override
  AddEntryDialogState createState() => AddEntryDialogState.AddCattleDialogState();
}

class AddEntryDialogState extends State<AddCattleDialog> {
  AddEntryDialogState.AddCattleDialogState();
  final _formKey = GlobalKey<FormState>();
  List<String> srcList = new List();
  Map<String, String> cowMap = new Map();
  Map<String, String> buffaloMap = new Map();
  Map<String, String> genderMap = new Map();
  Map<String, String> breedMap = new Map();
  Map<String, String> strMap = new Map();
  List<String> cowBreedsLocal = new List(),
      buffaloBreedsLocal = new List();
  List<String> _cowBreeds = [
    "Ongole",
    "Punganoor",
    "Holstein",
    "Jersey",
    "Gir",
    "Shahiwal",
    "Deoni",
    "Ratti",
    "Other"
  ];

  List<String> _buffaloBreeds = [
    "Murrah",
    "Mehsana",
    "Jaffarbadi",
    "Banni",
    "Other"
  ];

  String _breed = "Ongole";
  String _gender = "Female";
  String _animalType = "Cow";
  String docKey;
  String _milking = "Yes";

  bool isPressed = false;

  DateTime _purchaseDate;
  DateTime _birthDate;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _insuranceController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  final format = DateFormat('dd-MM-yyyy');

  @override
  void initState() {
    super.initState();
    srcList.add('');
    if (widget.animal != null) {
      _nameController.text = widget.animal.animalName;
      _insuranceController.text = widget.animal.insuranceID;
      _descriptionController.text = widget.animal.animalDescription;
      Animal animal = widget.animal;
      _breed = animal.animalBreed;
      _gender = animal.gender;
      _milking = animal.isMilking != null?animal.isMilking:"No";
      _animalType = animal.animalType;
      _purchaseDate = animal.dateOfPurchase;
      _birthDate = animal.dateOfBirth;
      if(animal.encodedImage != null)
        srcList[0] = animal.encodedImage;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _insuranceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _createMap() {
    cowMap = {
      "Ongole": AppLocalizations.of(context).ongole,
      "Punganoor": AppLocalizations.of(context).punganoor,
      "Holstein": AppLocalizations.of(context).holstein,
      "Jersey": AppLocalizations.of(context).jersey,
      "Gir": AppLocalizations.of(context).gir,
      "Shahiwal": AppLocalizations.of(context).shahiwal,
      "Deoni": AppLocalizations.of(context).deoni,
      "Ratti": AppLocalizations.of(context).ratti,
      "Other": AppLocalizations.of(context).other,
    };

    buffaloMap = {
      "Murrah": AppLocalizations.of(context).murrah,
      "Mehsana": AppLocalizations.of(context).mehsana,
      "Jaffarbadi": AppLocalizations.of(context).jaffarbadi,
      "Banni": AppLocalizations.of(context).banni,
      "Other": AppLocalizations.of(context).other
    };
    genderMap = {
      'Male': AppLocalizations.of(context).male,
      'Female': AppLocalizations.of(context).female
    };
    breedMap = {
      'Cow': AppLocalizations.of(context).cow,
      'Buffalo': AppLocalizations.of(context).buffalo
    };
    strMap = {
      'Yes': AppLocalizations.of(context).yes,
      'No': AppLocalizations.of(context).no
    };
    for(String str in _cowBreeds) {
      cowBreedsLocal.add(cowMap[str]);
    }
    for(String str in _buffaloBreeds) {
      buffaloBreedsLocal.add(buffaloMap[str]);
    }
  }

  Widget _buildImageSelector() {
    return picture_select(srcList, false);
  }

  @override
  Widget build(BuildContext context) {
    _createMap();
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(91,190,133,1.0),
        title: Text( widget.animal == null ? AppLocalizations.of(context).newAnimal : AppLocalizations.of(context).editStr),
        actions: [
          FlatButton(
            onPressed: () async {
              Map<String, String> fields = await _cattleFields();
              isPressed = true;
              if (_formKey.currentState.validate()) {
                 Navigator
                    .of(context)
                    .pop(fields);
              }
            },
            child: Text(
              isPressed?
                AppLocalizations.of(context).sending
                : AppLocalizations.of(context).save,
              style: Theme
                  .of(context)
                  .textTheme
                  .subhead
                  .copyWith(color: Colors.white))),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            _buildImageSelector(),
            CattleNameState(
              controller: _nameController,
              child: widget.animal != null
                ? CattleNameField(name: widget.animal.animalName)
                : CattleNameField(),
            ),
            GenderState(
              child: GenderPicker(), 
              gender: _gender, 
              onTap: _setGender,
            ),
            MilkingState(
              enabled: _gender == "Female",
              child: MilkingPicker(),
              milking: _milking,
              onTap: _setMilking,
            ),
            AnimalTypeState(
              child: AnimalTypeDropdown(),
              animalType: _animalType,
              onChanged: _setAnimalType,
            ),
            BreedState(
              child: BreedDropdown(),
              breed: _breed,
              breedsMap: _animalType == "Cow" ? cowMap: buffaloMap,
              onChanged: _setBreed,
              breeds: _animalType == "Cow" ? _cowBreeds: _buffaloBreeds,
            ),
             BirthDateState(
               birthDate: _birthDate,
               child: BirthDateInputField(),
               onTap: _selectDate,
             ),
             PurchaseDateState(
               purchaseDate: _purchaseDate,
               child: PurchaseDateInputField(),
               onPress: _selectDate,
             ),
            InsuranceState(
              controller: _insuranceController,
              child: widget.animal != null
                  ? InsuranceField(code: widget.animal.insuranceID)
                  : InsuranceField(),
            ),
            DescriptionState(
              controller: _descriptionController,
              child: widget.animal != null
                  ? DescriptionField(description: widget.animal.animalDescription)
                  : DescriptionField(),
            ),
          ],
        ),
      )
    );
  }

  Future<Null> _selectDate(BuildContext context, DateCase dateCase) async {
    final DateTime picked = await showDatePicker(
      context: context,
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
      initialDate: DateTime.now().subtract(Duration(seconds: 5))
    );

    if (picked != null) {
      if (dateCase == DateCase.purchase) {
        if(picked != _purchaseDate) {
          setState(() {
            _purchaseDate = picked;
          });
        } 
      } else {
        if(picked != _birthDate) {
          setState(() {
            _birthDate = picked;
          });
        }  
      }
    }
  }

  void _setGender(String gender) {
    setState(() {
      _gender = gender; 

      if (gender == "Male") {
        _milking = "No";
      }     
      
    });
  }

  void _setMilking(String isMilking) {
    setState(() {
      _milking = isMilking;
    });
  }

  void _setAnimalType(String animalType) {
    setState(() {
      _animalType = animalType; 
      if (animalType == "Cow") {
        _breed = "Ongole";
      } else {
        _breed = "Murrah";
      }
    });
  }

   void _setBreed(String breed) {
    setState(() {
      _breed = breed;
    });
  }

  Future<Map<String, String>> _cattleFields() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    QuerySnapshot snapshot = await Firestore.instance.
      collection("users").
      where("authUID", isEqualTo: user.uid).
      limit(1).
      getDocuments();

    docKey = snapshot.documents[0].documentID;

    Map<String, String> fields = {
      "userID" : docKey,
      "animalName" : _nameController.text,
      "animalType" : _animalType,
      "gender": _gender,
      "insuranceID": _insuranceController.text,
      "animalBreed" : _breed,
      "encodedImage" : srcList[0],
      "isMilking" : _milking,
      "animalDescription" : _descriptionController.text,
      "birthDate" : _birthDate != null 
        ? _birthDate.millisecondsSinceEpoch.toString() 
        : null,
      "purchaseDate" : _purchaseDate != null 
        ? _purchaseDate.millisecondsSinceEpoch.toString() 
        : null,
      "animalStatus" : widget.animal != null 
        ? (
          widget.animal.animalStatus != null 
            ? widget.animal.animalStatus 
            : ""
          ) 
        : ""
    };
    return fields;
  }
}