import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kissaan_flutter/locale/locales.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kissaan_flutter/newsfeed/widgets/post_location_widget.dart';
import 'package:kissaan_flutter/newsfeed/model_classes/Post.dart';
import 'package:kissaan_flutter/utils/image_process.dart';
import 'package:kissaan_flutter/newsfeed/utils/post_header_state.dart';

class PostHeaderWidget extends StatelessWidget {
  final timeFormat = new DateFormat('dd-MM-yyyy \nhh:mm');
  String postID;
  bool notNull(Object o) => o != null;
  bool isOwner;
  @override
  Widget build(BuildContext context) {
    PostHeaderState state = PostHeaderState.of(context);
    final Post post = state.post;
    final String userID = state.userID;
    postID = state.postID;
    isOwner = (userID == post.userID);

    void _select(String value) {
      switch(value) {
        case 'edit':
          Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    AppLocalizations.of(context).availableSoon
                ),
              )
          );
          break;
        case 'delete':
          final DocumentReference reference = Firestore.instance.
          collection('posts').document(postID);
          Firestore.instance.runTransaction((Transaction tx) async {
            DocumentSnapshot snapshot = await tx.get(reference);
            if(snapshot.exists) {
              await tx.delete(reference);
            }
          });
          state.removePost(post);
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(context).postDeleted
              ),
            )
          );
          break;
        case 'like':
          break;
        case 'report':
          state.reportPost(postID, post);
          break;
      }
    }

    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        ClipOval(
          child: Container(
              width: 50.0,
              height: 50.0,
              child: binaryToImageSize(post.encodedImage, 50.0)
          )
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              children: [
                Text(post.userName ?? "",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(post.tag ?? "",
                    style: const TextStyle(fontSize: 12.0)),
                PostLocationWidget(post)
              ],
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start
            )
          )
        ),
        Container(
          alignment: FractionalOffset.centerRight,
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              Text(
                timeFormat.format(post.postDate),
                style: const TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w300
                )
              ),
            ]
          )
        ),
        FractionalTranslation(
          child: PopupMenuButton(
            itemBuilder: (_) =>
            <PopupMenuItem<String>>[
              PopupMenuItem<String>(
                child: Text(
                  isOwner?
                    AppLocalizations.of(context).editStr
                    : AppLocalizations.of(context).archive
                ),
                value: isOwner?'edit':'like',
              ),
              PopupMenuItem<String>(
                child: Text(
                  isOwner?
                    AppLocalizations.of(context).delete
                    : AppLocalizations.of(context).report
                ),
                value: isOwner?'delete':'report',
              )
            ],
            elevation: 8.0,
            onSelected:  _select,
          ),
          translation: Offset(0.0, -0.25)
        )
      ].where(notNull).toList(),
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
    );
  }
}