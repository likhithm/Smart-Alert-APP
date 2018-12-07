import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:kissaan_flutter/locale/Application.dart';
import 'dart:async';
import 'package:kissaan_flutter/l10n/messages_all.dart';

class AppLocalizations {
  static Future<AppLocalizations> load(Locale locale) {
    final String name =
        locale.countryCode == null ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((bool _) {
      Intl.defaultLocale = localeName;
      return AppLocalizations();
    });
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }


  String get title {
    return Intl.message(
      'Kissaan',
      name: 'title',
      desc: 'The title of the applications'
    );
  }

  String get newsfeedPageTitle {
    return Intl.message(
      "విషయసేకరణ",
      name: 'newsfeedPageTitle',
    );
  }

  String get cattlePageTitle {
    return Intl.message(
      "పశువులు ",
        name: 'cattlePageTitle',
    );
  }

  String get yieldPageTitle {
    return Intl.message(
      "దిగుబడి",
        name: 'yieldPageTitle',
    );
  }

  String get taskPageTitle {
    return Intl.message(
      "విషయాలు",
      name: 'taskPageTitle',
    );
  }

  String get userProfileTitle {
    return Intl.message(
      "వ్యక్తిగత వివరణ",
      name: 'userProfileTitle',
    );
  }

  String get changeNumberText {
    return Intl.message(
      "ఫోన్ నెంబర్ మార్చుకోనుట",
      name: 'changeNumberText',
    );
  }

  String get logout {
    return Intl.message(
      "నిష్క్రమణ",
      name: 'logout',
    );
  }

  String get addCattlePrompt {
    return Intl.message(
      "పశువుల చేరిక లేదా నూతన పశువుల చేరిక",
      name: 'addCattlePrompt',
    );
  }

  String get allCattle {
    return Intl.message(
      "అన్ని పశువులు",
      name: 'allCattle',
    );
  }

  String get selectDate {
    return Intl.message(
      "ఎంచుకోబడు తేదీ",
      name: 'selectDate',
    );
  }

  String get am {
    return Intl.message(
      'AM',
      name: 'am',
    );
  }

  String get pm {
    return Intl.message(
      'PM',
      name: 'pm',
    );
  }

  String get submit {
    return Intl.message(
      'అంగీకరించండి',
      name: 'submit',
    );
  }

  String get cancel {
    return Intl.message(
      'రద్దు',
      name: 'cancel',
    );
  }

  String get newAnimal {
    return Intl.message(
      'కొత్త పశువు',
      name: 'newAnimal',
    );
  }

  String get save {
    return Intl.message(
      ' సేవ్ ',
      name: 'save',
    );
  }

  String get gender {
    return Intl.message(
      'లింగనిర్ధారణ',
      name: 'gender',
    );
  }

  String get male {
    return Intl.message(
      'మగ',
      name: 'male',
    );
  }

  String get female {
    return Intl.message(
      'ఆడ',
      name: 'female',
    );
  }

  String get milking {
    return Intl.message(
      'పాలు ఇచ్చు',
      name: 'milking',
    );
  }

  String get yes {
    return Intl.message(
      'అవును',
      name: 'yes',
    );
  }

  String get no {
    return Intl.message(
      'కాదు',
      name: 'no',
    );
  }

  String get dateOfBirth {
    return Intl.message(
      'పుట్టిన తేది',
      name: 'dateOfBirth',
    );
  }

  String get dateOfPurchase {
    return Intl.message(
      'కొనుగోలు చేసిన తేదీ',
      name: 'dateOfPurchase',
    );
  }

  String get insuranceNumber {
    return Intl.message(
      'జీవిత భీమా నంబరు',
      name: 'insuranceNumber',
    );
  }

  String get cow {
    return Intl.message(
      'ఆవు',
      name: 'cow',
    );
  }

  String get buffalo {
    return Intl.message(
      'గేదె',
      name: 'buffalo',
    );
  }

  String get ongole {
    return Intl.message(
      'ఒంగోలు',
      name: 'ongole',
    );
  }

  String get punganoor {
    return Intl.message(
      'పుంగనూరు',
      name: 'punganoor',
    );
  }

  String get holstein {
    return Intl.message(
      'హోలిస్టెయిన్',
      name: 'holstein',
    );
  }

  String get jersey {
    return Intl.message(
      'జెర్సీ',
      name: 'jersey',
    );
  }

  String get gir {
    return Intl.message(
      'గిర్',
      name: 'gir',
    );
  }

  String get shahiwal {
    return Intl.message(
      'షాహివాల్',
      name: 'shahiwal',
    );
  }

  String get deoni {
    return Intl.message(
      'దియోని',
      name: 'deoni',
    );
  }

  String get ratti {
    return Intl.message(
      'రాఠి',
      name: 'ratti',
    );
  }

  String get mixedBreed {
    return Intl.message(
      'సంకరజాతి',
      name: 'mixedBreed',
    );
  }

  String get other {
    return Intl.message(
      ' ఇతర రకాలు ',
      name: 'other',
    );
  }

  String get murrah {
    return Intl.message(
      'ముర్ర',
      name: 'murrah',
    );
  }

  String get mehsana {
    return Intl.message(
      'మెహసన',
      name: 'mehsana',
    );
  }

  String get jaffarbadi {
    return Intl.message(
      'జాఫ్ఫార్ బాడీ',
      name: 'jaffarbadi',
    );
  }

  String get addEvent {
    return Intl.message(
      ' ఈవెంట్ను నమోదు చేయండి ',
      name: 'addEvent',
    );
  }

  String get breeding {
    return Intl.message(
      'సంక్రమణం',
      name: 'breeding',
    );
  }

  String get pregnancy {
    return Intl.message(
      'గర్భం',
      name: 'pregnancy',
    );
  }

  String get insemination {
    return Intl.message(
      'వీర్యదానం',
      name: 'insemination',
    );
  }

  String get medicalAndHealth {
    return Intl.message(
      'వైద్యం మరియు ఆరోగ్యం.',
      name: 'medicalAndHealth',
    );
  }

  String get dryCowTherapy {
    return Intl.message(
      'వట్టిపోయిన పశువుకు వైద్యం',
      name: 'dryCowTherapy',
    );
  }

  String get generalCheckUp {
    return Intl.message(
      'సహజమైన వైద్య పరీక్ష',
      name: 'generalCheckUp',
    );
  }

  String get intramammaryAntibiotics {
    return Intl.message(
      'అంతర్గత వ్యాధి నిరోధకత మందులు',
      name: 'intramammaryAntibiotics',
    );
  }

  String get delivery {
    return Intl.message(
      'ప్రసవం',
      name: 'delivery',
    );
  }

  String get maleCalf {
    return Intl.message(
      'మగ దూడ',
      name: 'maleCalf',
    );
  }

  String get femaleCalf {
    return Intl.message(
      'ఆడ దూడ',
      name: 'femaleCalf',
    );
  }

  String get deadCalf {
    return Intl.message(
      'ఈసుకుపోవడం',
      name: 'deadCalf',
    );
  }

  String get status {
    return Intl.message(
      'ప్రస్తుత పరిస్థితి',
      name: 'status',
    );
  }

  String get sold {
    return Intl.message(
      'అమ్ముట',
      name: 'sold',
    );
  }

  String get dead {
    return Intl.message(
      'చనిపోవుట',
      name: 'dead',
    );
  }

  String get checkUpdateToDate {
    return Intl.message(
        ' అప్లికేషన్ నవీకరణ చేయండి ',
        name: 'checkUpdateToDate'
    );
  }

  String get reply {
    return Intl.message(
        'జవాబు',
        name: 'reply'
    );
  }

  String get inMind {
    return Intl.message(
        'ఏంటి కబుర్లు!!!',
        name: 'inMind'
    );
  }

  String get moreComments {
    return Intl.message(
        ' మరిన్ని వ్యాఖ్యలు ',
        name: 'moreComments'
    );
  }

  String get general {
    return Intl.message(
        ' జనరల్ ',
        name: 'general'
    );
  }

  String get post {
    return Intl.message(
        ' పోస్ట్ ',
        name: 'post'
    );
  }
  String get sending {
    return Intl.message(
        ' పంపుతోంది ',
        name: 'sending'
    );
  }

  String get enterComments {
    return Intl.message(
        'మీ మనసులో మాట',
        name: 'enterComments'
    );
  }

  String get chooseSource {
    return Intl.message(
        ' దయచేసి మూలాన్ని ఎంచుకోండి ',
        name: 'chooseSource'
    );
  }

  String get camera {
    return Intl.message(
        ' కెమెరా ',
        name: 'camera'
    );
  }

  String get gallery {
    return Intl.message(
        ' గ్యాలరీ ',
        name: 'gallery'
    );
  }

  String get event {
    return Intl.message(
        ' ఈవెంట్ ',
        name: 'event'
    );
  }

  String get buySell {
    return Intl.message(
        ' కొను/అమ్ము ',
        name: 'buySell'
    );
  }

  String get like {
    return Intl.message(
        ' లైక్ ',
        name: 'like'
    );
  }

  String get dislike {
    return Intl.message(
        ' అయిష్టం ',
        name: 'dislike'
    );
  }

  String get showAll {
    return Intl.message(
        ' అన్నీ చూపండి ',
        name: 'showAll'
    );
  }

  String get collapse {
    return Intl.message(
        ' కుదించు ',
        name: 'collapse'
    );
  }

  String get enterSMS {
    return Intl.message(
        ' SMS కోడ్ను నమోదు చేయండి ',
        name: 'enterSMS'
    );
  }

  String get done {
    return Intl.message(
        ' పూర్తి ',
        name: 'done'
    );
  }

  String get numTransferFail {
    return Intl.message(
        ' ఫోన్ నంబర్ బదిలీ విఫలమైంది ',
        name: 'numTransferFail'
    );
  }

  String get numAlreadyUsed {
    return Intl.message(
        ' ఫోనంబర్ ఇప్పటికే ఉపయోగించబడింది ',
        name: 'numAlreadyUsed'
    );
  }

  String get confirm {
    return Intl.message(
        ' నిర్ధారించండి ',
        name: 'confirm'
    );
  }

  String get oldPhoneNum {
    return Intl.message(
        ' పాత ఫోన్ నంబర్ ',
        name: 'oldPhoneNum'
    );
  }

  String get newPhoneNum {
    return Intl.message(
        ' క్రొత్త ఫోన్ నంబర్ ',
        name: 'newPhoneNum'
    );
  }

  String get invalidPhoneNum {
    return Intl.message(
        ' చెల్లని ఫోన్ నంబర్ ',
        name: 'invalidPhoneNum'
    );
  }

  String get phoneNumNoMatch {
    return Intl.message(
        " ఫోన్ నంబర్ సరిపోలలేదు ",
        name: 'phoneNumNoMatch'
    );
  }

  String get phone {
    return Intl.message(
        ' ఫోన్ ',
        name: 'phone'
    );
  }

  String get yourPhoneNum {
    return Intl.message(
        ' మీ ఫోను నంబరు ',
        name: 'yourPhoneNum'
    );
  }

  String get changeNum {
    return Intl.message(
        ' ఫోన్ నంబర్ని మార్చండి ',
        name: 'changeNum'
    );
  }

  String get loading {
    return Intl.message(
        ' లోడ్... ',
        name: 'loading'
    );
  }

  String get thingsToDo {
    return Intl.message(
        ' చేయవలసిన పనులు ',
        name: 'thingsToDo'
    );
  }

  String get notValidDate {
    return Intl.message(
        ' చెల్లుబాటు అయ్యే తేదీ కాదు ',
        name: 'notValidDate'
    );
  }

  String get enterEventDate {
    return Intl.message(
        ' ఈవెంట్ తేదీని నమోదు చేయండి (mm / dd / yyyy) ',
        name: 'enterEventDate'
    );
  }

  String get date {
    return Intl.message(
        ' తేదీ: ',
        name: 'date'
    );
  }

  String get positive {
    return Intl.message(
        ' పాజిటివ్ ',
        name: 'positive'
    );
  }

  String get negative {
    return Intl.message(
        ' నెగటివ్ ',
        name: 'negative'
    );
  }


  String get enterEventDesc {
    return Intl.message(
        ' ఈవెంట్ వివరణని నమోదు చేయండి ',
        name: 'enterEventDesc'
    );
  }

  String get description {
    return Intl.message(
        ' వివరణ ',
        name: 'description'
    );
  }

  String get eventRegister {
    return Intl.message(
        ' ఈవెంట్ను నమోదు చేయండి ',
        name: 'eventRegister'
    );
  }



  String get registerUsingAddCattle {
    return Intl.message(
        ' యాడ్ పశువుల బటన్ను ఉపయోగించి మీ పశువులను నమోదు చేయండి. ',
        name: 'registerUsingAddCattle'
    );
  }

  String get registerCattleEvents {
    return Intl.message(
        ' పశువుల ప్రొఫైల్ వద్ద యాడ్ ఈవెంట్స్ బటన్ను ఉపయోగించి పశువుల సంబంధిత ఈవెంట్లను నమోదు చేయండి. ',
        name: 'registerCattleEvents'
    );
  }

  String get checkTipOfDay {
    return Intl.message(
        ' రోజువారీ చిట్కా న్యూస్ ఫీడ్ లో చూడండి ',
        name: 'checkTipOfDay'
    );
  }

  String get updateAnimalYields {
    return Intl.message(
        ' దిగుబడి పేజీలో మీ జంతువుల దిగుబడి నమోదు చేసుకోండి. ',
        name: 'updateAnimalYields'
    );
  }

  String get cropImage {
    return Intl.message(
        ' మీ చిత్రం సర్దుబాటు చేయండి ',
        name: 'cropImage'
    );
  }

  String get cattle {
    return Intl.message(
        ' పశువులు ',
        name: 'cattle'
    );
  }

  String get enterYield {
    return Intl.message(
        ' దిగుబడిని నమోదు చేయండి ',
        name: 'enterYield'
    );
  }

  String get tasks {
    return Intl.message(
        ' విషయాలు ',
        name: 'tasks'
    );
  }

  String get submissionConfirm {
    return Intl.message(
        ' సమర్పణ ఆమోదించబడింది ',
        name: 'submissionConfirm'
    );
  }

  String get noDataSaved {
    return Intl.message(
        ' డేటా సేవ్ చేయబడలేదు! ',
        name: 'noDataSaved'
    );
  }

  String get dataSavedSuccessfully {
    return Intl.message(
        ' డేటా విజయవంతంగా సేవ్ చేయబడింది! ',
        name: 'dataSavedSuccessfully'
    );
  }

  String get today {
    return Intl.message(
        ' నేడు, ',
        name: 'today'
    );
  }

  String get yields {
    return Intl.message(
        ' దిగుబడి ',
        name: 'yields'
    );
  }

  String get avgYieldNoRecord {
    return Intl.message(
        ' సగటు దిగుబడి : 0 ',
        name: 'avgYieldNoRecord'
    );
  }

  String get avgYield {
    return Intl.message(
        ' సగటు దిగుబడి : ',
        name: 'avgYield'
    );
  }

  String get perDay {
    return Intl.message(
        ' రోజుకు ',
        name: 'perDay'
    );
  }

  String get selectDateTap {
    return Intl.message(
        ' ఇక్కడ నొక్కడం ద్వారా తేదీని ఎంచుకోండి ',
        name: 'selectDateTap'
    );
  }

  String get editUser {
    return Intl.message(
        ' వినియోగదారుని సవరించండి ',
        name: 'editUser'
    );
  }

  String get name {
    return Intl.message(
        ' పేరు: ',
        name: 'name'
    );
  }

  String get pleaseEnterText {
    return Intl.message(
        ' దయచేసి కొంత వచనాన్ని నమోదు చేయండి ',
        name: 'pleaseEnterText'
    );
  }

  String get enterLocation {
    return Intl.message(
        ' స్థానాన్ని నమోదు చేయండి: ',
        name: 'enterLocation'
    );
  }

  String get locationOPT {
    return Intl.message(
        ' స్థానం (ఐచ్ఛిక): ',
        name: 'locationOPT'
    );
  }

  String get enterAadhar {
    return Intl.message(
        ' మీ ఆధార్ నంబర్ నమోదు చేయండి ',
        name: 'enterAadhar'
    );
  }


  String get aadharOPT {
    return Intl.message(
        ' ఆధార్ నంబర్(ఐచ్ఛిక): ',
        name: 'aadharOPT'
    );
  }

  String get welcome {
    return Intl.message(
        ' స్వాగతం! ',
        name: 'welcome'
    );
  }

  String get location {
    return Intl.message(
        ' స్థానం : ',
        name: 'location'
    );
  }

  String get aadhar {
    return Intl.message(
        ' ఆధార్ నంబర్: ',
        name: 'aadhar'
    );
  }

  String get news {
    return Intl.message(
        ' సమాచారం ',
        name: 'news'
    );
  }


  String get phoneNumCantEmpty {
    return Intl.message(
        " మీ ఫోన్ నంబర్ ఖాళీగా ఉండకూడదు! ",
        name: 'phoneNumCantEmpty'
    );
  }

  String get phoneNumInvalid {
    return Intl.message(
        ' ఈ ఫోన్ నంబర్ చెల్లనిది! ',
        name: 'phoneNumInvalid'
    );
  }


  String get couldntVerifyCode {
    return Intl.message(
        " ఇప్పుడే మీ కోడ్ను మేము ధృవీకరించలేకపోయాము, దయచేసి మళ్ళీ ప్రయత్నించండి! ",
        name: 'couldntVerifyCode'
    );
  }

  String get verificationCodeEmpty {
    return Intl.message(
        " మీ ధృవీకరణ కోడ్ ఖాళీగా ఉండకూడదు! ",
        name: 'verificationCodeEmpty'
    );
  }

  String get invalidVerificationCode {
    return Intl.message(
        ' ఈ ధృవీకరణ కోడ్ చెల్లదు! ',
        name: 'invalidVerificationCode'
    );
  }

  String get couldntVerifyCodeRetry {
    return Intl.message(
        " మేము మీ కోడ్ను ధృవీకరించలేకపోయాము, దయచేసి మళ్ళీ ప్రయత్నించండి! ",
        name: 'couldntVerifyCodeRetry'
    );
  }

  String get couldntCreatProfile {
    return Intl.message(
        " మేము మీ కోడ్ను ధృవీకరించలేకపోయాము, దయచేసి మళ్ళీ ప్రయత్నించండి! ",
        name: 'couldntCreatProfile'
    );
  }

  String get cantRetryYet {
    return Intl.message(
        " మీరు ఇంకా మళ్ళీ ప్రయత్నించలేరు! ",
        name: 'cantRetryYet'
    );
  }

  String get codeNotThereInOneMin {
    return Intl.message(
        " మీ కోడ్ 1 నిమిషంలో రాకుంటే, తాకండి ",
        name: 'codeNotThereInOneMin'
    );
  }

  String get verificationCode {
    return Intl.message(
        " ధృవీకరణ కోడ్ ",
        name: 'verificationCode'
    );
  }

  String get authentication {
    return Intl.message(
        " ప్రామాణీకరణ ",
        name: 'authentication'
    );
  }

  String get enterNumberBelow {
    return Intl.message(
        " దయచేసి క్రింద మీ నంబర్ను నమోదు చేయండి. \n ",
        name: 'enterNumberBelow'
    );
  }

  String get willSendSMS {
    return Intl.message(
        " మీ గుర్తింపుని ధృవీకరించడానికి మేము SMS సందేశాన్ని పంపుతాము. ",
        name: 'willSendSMS'
    );
  }


  String get search {
    return Intl.message(
        " వెతుకు ",
        name: 'search'
    );
  }

  String get dryAnimals {
    return Intl.message(
        " వట్టి  పశువులు ",
        name: 'dryAnimals'
    );
  }

  String get milkingAnimals {
    return Intl.message(
        " పాడి పశువులు ",
        name: 'milkingAnimals'
    );
  }

  String get pregnantAnimals {
    return Intl.message(
        " చూడి పశువులు ",
        name: 'pregnantAnimals'
    );
  }

  String get banni {
    return Intl.message(
        " బన్ని ",
        name: 'banni'
    );
  }

  String get invalidDate {
    return Intl.message(
        " చెల్లుబాటు అయ్యే తేదీ కాదు. ",
        name: 'invalidDate'
    );
  }

  String get cattleName {
    return Intl.message(
        " పశువుల పేరును నమోదు చేయండి ",
        name: 'cattleName'
    );
  }

  String get enterDescription {
    return Intl.message(
        " వివరణ నమోదు చేయండి ",
        name: 'enterDescription'
    );
  }

  String get enterInsuranceNum {
    return Intl.message(
        " బీమా నెంబర్ నమోదు చేయండి ",
        name: 'enterInsuranceNum'
    );
  }

  String get insurance {
    return Intl.message(
        " భీమా :",
        name: 'insurance'
    );
  }

  String get kankrej {
    return Intl.message(
        "కాంక్రేజ్",
        name: 'kankrej'
    );
  }

  String get hallikar {
    return Intl.message(
        "హాలికర్",
        name: 'hallikar'
    );
  }

  String get kangayan {
    return Intl.message(
        "కంగాయం",
        name: 'kangayan'
    );
  }

  String get hariana {
    return Intl.message(
        "హరియాణా",
        name: 'hariana'
    );
  }

  String get marnadu {
    return Intl.message(
        "మర్నాడు",
        name: 'marnadu'
    );
  }

  String get tharparkar {
    return Intl.message(
        "థర్పర్కర్",
        name: 'tharparkar'
    );
  }

  String get Vechur {
    return Intl.message(
        "వేచూర్",
        name: 'Vechur'
    );
  }

  String get RedSindhi {
    return Intl.message(
        " రెడ్ సింధీ ",
        name: 'RedSindhi'
    );
  }

  String get NiliRavi {
    return Intl.message(
        "నిలి రవి",
        name: 'NiliRavi'
    );
  }

  String get Jaffarabadi {
    return Intl.message(
        "జఫ్ఫారబడి",
        name: 'Jaffarabadi'
    );
  }

  String get Naatu {
    return Intl.message(
        "నాటు",
        name: 'Naatu'
    );
  }

  String get Surti {
    return Intl.message(
        "సూర్తి",
        name: 'Surti'
    );
  }

  String get enterName {
    return Intl.message(
        " దయచేసి మీ పేరు నమోదు చేయండి ",
        name: "enterName"
    );
  }

  String get accept {
    return Intl.message(
        "ఆమోదించు",
        name: 'accept'
    );
  }

  String get here {
    return Intl.message(
        "     ఇక్కడ.",
        name: 'here'
    );
  }
  String get referral {
    return Intl.message(
        "రెఫరల్: ",
        name: 'referral'
    );
  }
  String get enterAgentCode {
    return Intl.message(
        "దయచేసి ఏజెంట్ కోడ్ను నమోదు చేయండి",
        name:'enterAgentCode'
    );
  }

  String get and {
    return Intl.message(
        " మరియు ",
        name:'and'
    );
  }

  String get likeDecoration {
    return Intl.message(
        " ఇతరులుకు నచ్చింది",
        name:'likeDecoration'
    );
  }

  String get editStr {
    return Intl.message(
        "మార్చు",
        name:'editStr'
    );
  }

  String get language {
    return Intl.message(
        "భాష",
        name:'language'
    );
  }

  String get addPost {
    return Intl.message(
      "పోస్ట్ చేయండి",
      name:"addPost"
    );
  }

  String get pregnancyCheckPass {
    return Intl.message(
      "గర్భం పరీక్ష పాస్",
      name: 'pregnancyCheckPass'
    );
  }

  String get pregnancyCheckFail {
    return Intl.message(
        "గర్భం పరీక్ష విఫలమైంది",
        name: 'pregnancyCheckFail'
    );
  }

  String get delivered {
    return Intl.message(
        "ప్రసవం",
        name: 'delivered'
    );
  }

  String get medication {
    return Intl.message(
      "మందులు",
      name:'medication'
    );
  }

  String get enterPurchaseDate {
    return Intl.message(
      "కొనుగోలు చేసిన తేదీని నమోదు చేయండి (dd/mm/yyyy)",
      name: 'enterPurchaseDate'
    );
  }

  String get enterBirthDate {
    return Intl.message(
      "పుట్టిన తేదీని నమోదు చేయండి (dd/mm/yyyy)",
      name: 'enterBirthDate'
    );
  }

  String get addAnimal {
    return Intl.message(
      "పశువుల నమోదు",
      name:'addAnimal'
    );
  }

  String get archived {
    return Intl.message(
      "ప్రాచీన పశువులు",
      name: 'archived'
    );
  }

  String get delete {
    return Intl.message(
      "తొలగించు",
      name: 'delete'

    );
  }

  String get lastDate {
    return Intl.message(
      "చివరి దిగుబడి నమోదు తేదీ: ",
      name: 'lastDate'

    );
  }

  String get yieldNotNormal {
    return Intl.message(
      "దిగుబడి సాధారణ వెలుపల ఉంది. మరోసారి తనిఖీ చేయండి",
      name: 'yieldNotNormal'
    );
  }

  String get postDeleted {
    return Intl.message(
      "పోస్ట్ తీసివేయబడింది, రిఫ్రెష్ చేయండి",
      name: "postDeleted"
    );
  }

  String get availableSoon {
    return Intl.message(
      "త్వరలో అందుబాటులో ఉంటుంది",
      name: "availableSoon"
    );
  }

  String get undo {
    return Intl.message(
      "Undo",
      name: 'undo'
    );
  }

  String get restored {
    return Intl.message(
      'Restored',
      name: 'restored'
    );
  }

  String get report {
    return Intl.message(
        'Report',
        name: 'report'
    );
  }

  String get postBy {
    return Intl.message(
      'Posted By: ',
      name: 'postBy'
    );
  }

  String get archive {
    return Intl.message(
        'Archive',
        name: 'archive'
    );
  }
}



class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  final Locale newLocale;
  const AppLocalizationsDelegate({this.newLocale});

  @override
  bool isSupported(Locale locale) {
    return application.supportedLanguagesCodes.contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return AppLocalizations.load(newLocale ?? locale);
  }
  @override
  bool shouldReload(AppLocalizationsDelegate old) {
    return old!=this;
  }
}
