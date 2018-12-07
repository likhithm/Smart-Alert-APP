import 'package:flutter/material.dart';
import 'package:kissaan_flutter/locale/locales.dart';
import 'package:kissaan_flutter/newsfeed/model_classes/Post.dart';

class ReportDialog extends StatefulWidget {
  final String postID;
  final Post post;

  ReportDialog(this.postID, this.post);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ReportDialogState();
  }
}

class ReportDialogState extends State<ReportDialog> {
  TextEditingController desController = new TextEditingController();

  @override
  void dispose() {
    super.dispose();
    desController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AlertDialog(
      title: Text(AppLocalizations.of(context).report),
      content: _buildDialogBody(),
      actions: <Widget>[
        FlatButton(
          child: Text(AppLocalizations.of(context).confirm),
          onPressed: _onPressed,
        ),
        FlatButton(
          child: Text(AppLocalizations.of(context).cancel),
          onPressed: () {
            Map<String, String> fields = new Map();
            Navigator.of(context).pop(fields);
          },
        )
      ],
    );
  }

  Widget _buildDialogBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          AppLocalizations.of(context).postBy + widget.post.userName,
          style: TextStyle(
              fontWeight: FontWeight.w900
          ),
        ),
        TextField(
            maxLength: 50,
            maxLines: 2,
            controller: desController,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.only(
                    bottom: 10.0
                ),
                hintText: AppLocalizations.of(context).enterDescription,
                labelText: AppLocalizations.of(context).description,
                labelStyle: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500
                )
            )
        )
      ],
    );
  }


  void _onPressed() async{
    Map<String, String> fields = new Map();
    fields.putIfAbsent('description', () => desController.text.toString());
    print("in report dialog ${fields.length} !!!!!!!!!!!!!!");
    Navigator.of(context).pop(fields);
  }

}