import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kissaan_flutter/locale/locales.dart';
import 'package:kissaan_flutter/newsfeed/widgets/ghost_like.dart';
import 'package:kissaan_flutter/newsfeed/model_classes/Post.dart';
import 'package:kissaan_flutter/newsfeed/widgets/liking_channels.dart';
import 'package:kissaan_flutter/newsfeed/widgets/last_comments.dart';
import 'package:kissaan_flutter/newsfeed/widgets/all_comments.dart';

class PostInteraction extends StatefulWidget {
  final Post post;
  final String postID;
  final String userID;
  final String userName;
  PostInteraction(this.post, this.userID, this.postID, this.userName);

  @override
  State<StatefulWidget> createState() {
    return _PostInteractionState();
  }
}

class _PostInteractionState extends State<PostInteraction> {
  Map<String, String> likes;
  bool isLike = false;
  bool fullComment = false;
  String btnMsg = "";

  @override
  void initState() {
    super.initState();
    setState(() {
      likes = widget.post.likes;
      isLike = likes.containsKey(widget.userID);

    });
  }

  @override
  Widget build(BuildContext context) {
    setState((){
      if(btnMsg == "")
        btnMsg = AppLocalizations.of(context).showAll;

    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            GhostLike(
              like: isLike,//widget.post["liked"],
              likeCallback: likeCallback
            ),
            Expanded(
              child: LikingChannels(widget.post)
            ),
            Text(
              _buildCommentCounter(widget.post.comments.length),
              style: const TextStyle(
                fontWeight: FontWeight.w500
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.chat_bubble_outline,
                size: 25.0,
                color: Colors.grey
              ),
              onPressed: () {
                setState((){
                  fullComment = !fullComment;
                });
              }
            )
          ]
        ),
        fullComment
          ? AllComments(
              widget.post,
              widget.postID,
              widget.userName,
              widget.userID
            )
          :LastComments(widget.post),

        widget.post.comments.length > 2
          ? FlatButton(
              child: Text(
                btnMsg,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontWeight: FontWeight.w600
                ),
              ),
              onPressed: () {
                setState((){
                  btnMsg == AppLocalizations.of(context).showAll?
                    btnMsg = AppLocalizations.of(context).collapse
                      :btnMsg = AppLocalizations.of(context).showAll;
                  fullComment = !fullComment;
                });
              }
            )
          :Container()
      ]
    );
  }

  void likeCallback(bool like) {
    setState(() {
      updateLikeList(like);
      isLike = isLike
        ? false
        :true;

    });
  }

  void updateLikeList(bool like) {
    Map<String, String> updatedMap = widget.post.likes;
    if(like) {
      updatedMap.putIfAbsent(widget.userID, ()=>widget.userName);
    } else {
      updatedMap.remove(widget.userID);
    }

    final DocumentReference postRef = Firestore.instance
        .collection('posts')
        .document(widget.postID);
    Firestore.instance.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(postRef);
      if (postSnapshot.exists) {
        await tx.update(postRef, <String, dynamic>{'likes': updatedMap});
      }
    });
  }

  String _buildCommentCounter(int count) {
    if (count < 1000) {
      return count.toString();
    } else if (count < 99999) {
      double n = count / 1000000;
      return n.toStringAsFixed(1) + "M";
    } else if(count > 1000) {
      double n = count / 1000;
      return n.toStringAsFixed(1) + "K";
    }
    return count.toString();
  } 
}