import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart';
import 'package:kissaan_flutter/newsfeed/model_classes/Post.dart';
import 'package:vector_math/vector_math_64.dart';

class ImageViewer extends StatefulWidget {
  final Post post;

  ImageViewer(this.post);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ImageViewerState();
  }
}

class ImageViewerState extends State<ImageViewer> {
  final Offset initPos = Offset(100.0, 100.0);
  Offset position = Offset(0.0, 0.0);
  int boxNumberIsDragged = null, boxNumber = 1;
  double _previousScale = null, _scale = 1.0;
  List<String> imageRaw;
  bool isDragging = false;

  @override
  void initState() {
    super.initState();
    imageRaw = List<String>.from(widget.post.imgURLs);
    position = initPos;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(
      children: <Widget>[
        _buildZoomView()
      ],
    );
  }

  Widget _buildZoomView() {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: _buildDraggable(),

    );
  }

  Widget _buildDraggable() {
    return Draggable(
      child: _buildInnerZoomView(false),
      feedback: _buildInnerZoomView(true),
      //childWhenDragging: _buildInnerZoomView(true),
      onDragStarted: () {
        setState((){
          isDragging = true;
        });
      },
      onDragCompleted: () {
        setState((){
          isDragging = false;
        });
      },
      onDraggableCanceled: (_, initPos) {
        setState((){
          position = initPos;
          isDragging = false;
        });
      },
    );
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

  Widget _buildZoomFuncView() {
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onScaleStart: (ScaleStartDetails details) {
        print(details);
        _previousScale = _scale;
      },
      onScaleUpdate: (ScaleUpdateDetails details) {
        print(details);
        setState(() => _scale = _previousScale * details.scale);
      },
      onScaleEnd: (ScaleEndDetails details) {
        print(details);
        _previousScale = null;
      },
      child: new Transform(
        transform: new Matrix4.diagonal3(new Vector3(_scale, _scale, _scale)),
        alignment: FractionalOffset.center,
        child: Container(
          padding: EdgeInsets.only(top: 15.0, bottom: 5.0),
          constraints: BoxConstraints(
              minHeight: imageRaw.length == 0
                  ? 0.0
                  : 250.0
          ),
          child: getImages(width),
        ),
      )
    );
  }

  Widget _buildInnerZoomView(bool dragging) {
    if(dragging) {
      return _buildZoomFuncView();
    }
    return isDragging?Container():_buildZoomFuncView();
  }


}