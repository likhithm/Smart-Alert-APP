import 'package:flutter/material.dart';
import 'package:kissaan_flutter/newsfeed/utils/utils.dart';

typedef LimeLikeCallback(bool like);

class GhostLike extends StatefulWidget {


  final bool like;
  final LimeLikeCallback likeCallback;

  GhostLike({
    this.like: false,
    this.likeCallback
  });


  @override
  State<StatefulWidget> createState() {
    return new _GhostLikeState();
  }
}

class _GhostLikeState extends State<GhostLike>
    with SingleTickerProviderStateMixin {

  AnimationController controller;
  Curve scaleCurve;
  double likeAlpha = 0.0;
  double scale = 1.0;


  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      child: InkResponse(
        child: FractionallySizedBox(
            child: buildGhost(context),
            heightFactor: scale
        ),
        onTap: onTap
      ),
      constraints: BoxConstraints(
          maxHeight: 25.0
      )
    );
  }

  Widget buildGhost(BuildContext context) {
    return FractionallySizedBox(
      child: Image.asset(
        "assets/icons/like.png",
        color: Color.lerp(Colors.grey, Colors.red, likeAlpha),
        colorBlendMode: BlendMode.srcATop,
      ),
    );
  }

  void onTap() {
    if (widget.likeCallback != null) {
      widget.likeCallback(controller.value < 0.5);
    }
  }

  @override
  void initState() {
    super.initState();

    scaleCurve = BoomerangCurve(child: Curves.bounceInOut);
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )
      ..addListener(() {
        setState(() {
          scale = scaleCurve.transform(controller.value);
          likeAlpha = controller.value;
        });
      });
    controller.value = widget.like ? 1.0 : 0.0;
  }


  @override
  void didUpdateWidget(GhostLike oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.like) {
      controller.forward();
    } else {
      controller.reverse();
    }
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
}