import 'package:cloud_firestore/cloud_firestore.dart';

class YieldSet {
  List<String> monthYearList;
  List<String> yieldList;

  YieldSet(this.yieldList, this.monthYearList);

  YieldSet.fromData(DocumentSnapshot document) {
    yieldList = document['yieldList'].toString().split(',').toList();
    monthYearList = document['monthYearList'].toString().split(',').toList();
  }
  List<String> _parseSingle(String date) {
    var tier1Array = date.split(' ');
    var tier2Array = tier1Array[0].split('-');
    String retStr =  tier2Array[2] + "/" +
        tier2Array[1] + "/" +
        tier2Array[0].substring(0,2);
    List<String> retList = new List();
    retList.add(retStr);
    return retList;
  }
}