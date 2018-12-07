import 'package:flutter/material.dart';
import 'package:kissaan_flutter/locale/locales.dart';
import 'package:kissaan_flutter/newsfeed/model_classes/Post.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:kissaan_flutter/newsfeed/utils/post_image_state.dart';
import 'package:kissaan_flutter/widgets/image_view_builder.dart';
import 'package:vector_math/vector_math_64.dart';
import 'package:kissaan_flutter/widgets/image_viewer.dart';

//class PostImageWidget extends StatefulWidget {
//  final Post post;
//
//  PostImageWidget(this.post);
//
//  @override
//  State<StatefulWidget> createState() {
//    // TODO: implement createState
//    return PostImageWidgetState(post);
//  }
//}

class PostImageWidget extends StatelessWidget {
  //final Post post;

  //PostImageWidgetState(this.post);

  int boxNumberIsDragged = null, boxNumber = 1;
  List<String> imageRaw;



  @override
  Widget build(BuildContext context) {
    PostImageState state = PostImageState.of(context);
    Post post = state.post;

    double getAspectRatio() {
      var arRaw = 1.0 / post.imgURLs.length;
      if (arRaw != null) {
        double ratio = arRaw;
        if (ratio > 1.2) return 1 / 1.2;
        if (ratio < 0.2) return 1 / 0.2;
        //return ratio;
      }
      return 1.0;
    }

    Widget getImages(double width) {
      return imageRaw.length == 0
          ? Container()
          : SizedBox(
        height: 250.0,
        width: width,
        child: Carousel(
            autoplay: false,
            images: imageRaw.map((string) => NetworkImage(string)).toList()
        ),
      );
    }

    void _openImageViewer() {
      Navigator.of(context).push(MaterialPageRoute<Map<String,String>>(
          builder: (context) {
            return ImageViewBuilder(post);
          },
          fullscreenDialog: false
      ));
    }


    imageRaw = List<String>.from(post.imgURLs);
    double width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: _openImageViewer,
      child: Container(
        padding: EdgeInsets.only(top: 15.0, bottom: 5.0),
        constraints: BoxConstraints(
          minHeight: imageRaw.length == 0
            ? 0.0
            : 250.0
        ),
        child: getImages(width),
      ),
    );
  }

}