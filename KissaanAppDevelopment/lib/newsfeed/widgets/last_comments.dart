import 'package:flutter/material.dart';
import 'package:kissaan_flutter/locale/locales.dart';
import 'package:kissaan_flutter/newsfeed/model_classes/Post.dart';

class LastComments extends StatefulWidget {

  final Post post;
  final List<Map<dynamic, dynamic>> comments;

  LastComments(this.post)
    : comments = post.comments;

  @override
  State<StatefulWidget> createState() {
    return _LastCommentsState();
  }
}

class _LastCommentsState extends State<LastComments> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: RichText(text: getCommentsSpan(context))
    );
  }

  TextSpan getCommentsSpan(BuildContext context) {
    var innerF = () {
      List<TextSpan> list = new List();

      int furtherComments = widget.comments.length > 2?(widget.comments.length - 2):0;

      for(int i = 0; i < 2 && i < widget.comments.length; i++) {
        Map<String, String> currentComment = new Map<String, String>.from(widget.comments[i]);
        String title = currentComment['userName']
            + (currentComment['reply']!=null?'@' + currentComment['reply']: '') + ': ';
        list.add(
          TextSpan(
            text: title,
            style: TextStyle(
                fontWeight: FontWeight.w400
            )
          )
        );

        list.add(
          TextSpan(
            text: currentComment['message'] + '\n',
            style: TextStyle(
                fontWeight: FontWeight.w300
            )
          )
        );
      }
      if (furtherComments > 0) {
        list.add(
            TextSpan(
                text: "... $furtherComments ${AppLocalizations.of(context).moreComments}\n",
                style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w300
                )
            )
        );
      }
      return list;
    };

    return TextSpan(
      children: innerF(),
      style: Theme
          .of(context)
          .textTheme
          .body2
    );
  }
}