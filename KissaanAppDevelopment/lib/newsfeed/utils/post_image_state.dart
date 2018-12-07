import 'package:flutter/material.dart';
import 'package:kissaan_flutter/newsfeed/model_classes/Post.dart';

class PostImageState extends InheritedWidget {
  const PostImageState({
    Key key,
    @required this.post,
    @required Widget child
  }) : assert(child != null),
        super(key: key, child:child);

  final Post post;

  static PostImageState of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(PostImageState);
  }

  @override
  bool updateShouldNotify(PostImageState oldWidget) {
    // TODO: implement updateShouldNotify
    return oldWidget.post != post;
  }

}