import 'package:flutter/material.dart';
import 'package:kissaan_flutter/newsfeed/model_classes/Post.dart';

class PostHeaderState extends InheritedWidget {
  const PostHeaderState({
    Key key,
    @required this.post,
    @required this.userID,
    @required this.postID,
    @required this.removePost,
    @required this.reportPost,
    @required Widget child
  }) : assert(child != null),
      super(key: key, child:child);

  final Post post;
  final String userID;
  final String postID;
  final Function removePost, reportPost;

  static PostHeaderState of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(PostHeaderState);
  }

  @override
  bool updateShouldNotify(PostHeaderState oldWidget) {
    // TODO: implement updateShouldNotify
    return oldWidget.post != post;
  }

}