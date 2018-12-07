import 'package:flutter/material.dart';
import 'package:kissaan_flutter/newsfeed/model_classes/Post.dart';

class PostLocationWidget extends StatelessWidget {

  final Post post;

  PostLocationWidget(this.post);

  @override
  Widget build(BuildContext context) {
    double distance = double.parse(post.distance);
    String city = post.city;

    if (distance == null && city == null) {
      return new Container();
    }

    double km = distance != null ? 0.0 : null; //distance needed


    String display;

    if (km == null || (km > 30.0 && city != null)) {
      display = city;
    } else {
      display = "${km.toStringAsFixed(1)} km";
    }

    return new Text(
        display,
        style: new TextStyle(
            fontSize: 10.0,
            fontWeight: FontWeight.w300
        )
    );
  }
}

