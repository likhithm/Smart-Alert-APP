  import 'package:intl/intl.dart';

bool isValidDob(String dob) {
    if (dob.isEmpty) return true;
    var d = convertToDate(dob);
    return d != null && d.isBefore(new DateTime.now());
  }

  DateTime convertToDate(String input) {
    try {
        var d = new DateFormat.yMd().parseStrict(input);
        return d;
      } catch (e) {
        return null;
      }    
  }