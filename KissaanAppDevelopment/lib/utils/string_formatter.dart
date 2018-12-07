
class StringFormatter {
  const StringFormatter();

  String nameFormatter(String str) {
    return str.length > 14? str.substring(0, 14)+"...":str;
  }

  String likesFormatter(Map<String, String> nameList, List<String> likeDec) {
    String build = '';
    bool first = true;
    int counter = 0;
    String beginName = "";


    for(String name in nameList.values) {
      String temp = build;
      temp = "$build${!first ? "," : ""} $name";
      if(nameList.length == 1)
        return temp.length > 23 ? temp.substring(0, 20) + "..." : temp;
      if(build.length + name.length > 20) {
        continue;
      }
      beginName = name;
      if(temp.length < 20) {
        build = temp;
        counter++;
        first = false;
      }
      if(counter >= 1)
        break;
    }
    if(build.length == 0 && nameList.length > 0) {
      build = beginName.substring(0, 17) + '...';
      counter++;
    }
    if(counter < nameList.length) {
      build = build + likeDec[0] + _buildCounter(nameList.length - counter) + likeDec[1];
    }
    return build;
  }

  String _buildCounter(int count) {
    if (count < 1000) {
      return count.toString();
    } else if (count < 99999) {
      double n = count / 1000000;
      return n.toStringAsFixed(1) + "M";
    } else if(count > 1000) {
      double n = count / 1000;
      return n.toStringAsFixed(1) + "K";
    }
  }
}