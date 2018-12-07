import 'package:flutter/material.dart';
import 'package:kissaan_flutter/locale/locales.dart';
import 'package:kissaan_flutter/newsfeed/model_classes/Post.dart';
import 'package:kissaan_flutter/utils/string_formatter.dart';

class LikingChannels extends StatefulWidget {

  final Post post;

  LikingChannels(this.post);

  @override
  State<StatefulWidget> createState() {
    return _LikingChannelsState();
  }
}


class _LikingChannelsState extends State<LikingChannels> {
  StringFormatter formatter = new StringFormatter();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
            child: Text(
              _buildDisplayString(),
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: width/28
              ),
              overflow: TextOverflow.ellipsis,
              softWrap: true,
            ),
            padding: EdgeInsets.only(right: 8.0)
          )
    );
  }


  String _buildDisplayString() {
    String build = '';
    Map<String, String> nameList = widget.post.likes;
    List<String> likeDec = new List();
    likeDec.add(AppLocalizations.of(context).and);
    likeDec.add(AppLocalizations.of(context).likeDecoration);
    build = formatter.likesFormatter(nameList, likeDec);
    return build;
  }

  @override
  void didUpdateWidget(LikingChannels oldWidget) {
    super.didUpdateWidget(oldWidget);
  }
}