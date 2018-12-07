import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:kissaan_flutter/locale/locales.dart';
import 'package:kissaan_flutter/newsfeed/model_classes/Post.dart';

// Given a canvas and an image, determine what size the image should be to be
// contained in but not exceed the canvas while preserving its aspect ratio.
Size _containmentSize(Size canvas, Size image) {}

class ImageViewBuilder extends StatefulWidget {
  final Post post;
  final double maxScale;
  final GestureTapCallback onTap;
  final Color backgroundColor;
  final Widget placeholder;

  ImageViewBuilder(
      this.post, {
        Key key,
        @deprecated double scale,

        /// Maximum ratio to blow up image pixels. A value of 2.0 means that the
        /// a single device pixel will be rendered as up to 4 logical pixels.
        this.maxScale = 2.0,
        this.onTap,
        this.backgroundColor = Colors.black,

        /// Placeholder widget to be used while [image] is being resolved.
        this.placeholder,
      }) : super(key: key);

  @override
  ImageViewBuilderState createState() => new ImageViewBuilderState();
}

class ImageViewBuilderState extends State<ImageViewBuilder> {
  ImageStream _imageStream;
  ui.Image _image;
  Size _imageSize;
  ImageProvider provider;
  Offset _startingFocalPoint;
  int prevLoc = 0;

  Offset _previousOffset;
  Offset _offset; // where the top left corner of the image is drawn

  double _previousScale;
  double _scale; // multiplier applied to scale the full image

  Orientation _previousOrientation;

  Size _canvasSize;
  List<ui.Color> colorList = new List();

  @override
  void initState() {
    provider = new NetworkImage(widget.post.imgURLs[0]);
    colorList.add(Colors.greenAccent);
    for(int i = 1; i < widget.post.imgURLs.length; i++) {
      colorList.add(Colors.white);
    }
  }

  void _centerAndScaleImage() {
    _imageSize = new Size(
      _image.width.toDouble(),
      _image.height.toDouble(),
    );

    _scale = math.min(
      _canvasSize.width / _imageSize.width,
      _canvasSize.height / _imageSize.height,
    );
    Size fitted = new Size(
      _imageSize.width * _scale,
      _imageSize.height * _scale,
    );

    Offset delta = _canvasSize - fitted;
    _offset = delta / 2.0; // Centers the image

    print(_scale);
  }


  Function() _handleDoubleTap(BuildContext ctx) {
    return () {
      double newScale = _scale * 2;
      if (newScale > widget.maxScale) {
        _centerAndScaleImage();
        setState(() {});
        return;
      }
      Offset center = ctx.size.center(Offset.zero);
      Offset newOffset = _offset - (center - _offset);
      setState(() {
        _scale = newScale;
        _offset = newOffset;
      });
    };
  }


  void _handleScaleStart(ScaleStartDetails d) {
    print("starting scale at ${d.focalPoint} from $_offset $_scale");
    _startingFocalPoint = d.focalPoint;
    _previousOffset = _offset;
    _previousScale = _scale;
  }


  void _handleScaleUpdate(ScaleUpdateDetails d) {
    double newScale = _previousScale * d.scale;
    if (newScale > widget.maxScale) {
      return;
    }

    // Ensure that item under the focal point stays in the same place despite zooming
    final Offset normalizedOffset =
        (_startingFocalPoint - _previousOffset) / _previousScale;
    final Offset newOffset = d.focalPoint - normalizedOffset * newScale;

    setState(() {
      _scale = newScale;
      _offset = newOffset;
    });
  }

  List<Widget> listContent() {
    ThemeData theme = Theme.of(context);

    List<Widget> widgetList = new List();
    List<String> urlList = List<String>.from(widget.post.imgURLs);
    for(String url in urlList) {
//      FlatButton curr = FlatButton(
//        onPressed: (){
//          setState(() {
//            Orientation orientation = MediaQuery.of(context).orientation;
//            if (orientation != _previousOrientation) {
//              _previousOrientation = orientation;
//              _centerAndScaleImage();
//            }
//            provider = new NetworkImage(url);
//            didChangeDependencies();
//          });
//        },
      int currLoc = urlList.indexOf(url);
      Container container = new Container(
        decoration: BoxDecoration(
          color: Colors.black
        ),
        width: MediaQuery.of(context).size.width/9 - 10.0,
        padding: EdgeInsets.only(left: 5.0, right: 5.0, bottom: 60.0, top: 20.0),
        child: Ink(
          decoration: BoxDecoration(
            border: Border.all(color: theme.accentColor, width: 4.0),
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: InkWell(
          //This keeps the splash effect within the circle
            borderRadius: BorderRadius.circular(1000.0), //Something large to ensure a circle
            onTap: () {
              setState(() {
                int currLoc = urlList.indexOf(url);
                colorList.removeAt(prevLoc);
                colorList.insert(currLoc, Colors.greenAccent);
                provider = new NetworkImage(url);
                didChangeDependencies();
                _centerAndScaleImage();
                prevLoc = currLoc;
              });
            },
            child: Icon(
              Icons.brightness_1,
              size: 15.0,
              color: colorList[currLoc],
            )
          ),
        ),
      );

      widgetList.add(container);
    }
    return widgetList;
  }

  @override
  Widget build(BuildContext ctx) {
    Widget paintWidget() {
      return new CustomPaint(
        child: new Container(color: widget.backgroundColor),
        foregroundPainter: new _ZoomableImagePainter(
          image: _image,
          offset: _offset,
          scale: _scale,
        ),
      );
    }

    if (_image == null) {
      return widget.placeholder;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(91,190,133,1.0),
        title: Text(""),
        actions: [
          FlatButton(
            onPressed: () async {
              Navigator
                .of(context)
                .pop();
            },
            child: Text(AppLocalizations.of(context).confirm,
              style: Theme
                .of(context)
                .textTheme
                .subhead
                .copyWith(color: Colors.white))),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.black,

        ),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: listContent()
        ),
      ),
      body: LayoutBuilder(builder: (ctx, constraints) {
        Orientation orientation = MediaQuery.of(ctx).orientation;
        if (orientation != _previousOrientation) {
          _previousOrientation = orientation;
          _canvasSize = constraints.biggest;
          _centerAndScaleImage();
        }
        return GestureDetector(
          child: paintWidget(),
          onTap: widget.onTap,
          onDoubleTap: _handleDoubleTap(ctx),
          onScaleStart: _handleScaleStart,
          onScaleUpdate: _handleScaleUpdate,
          //  )
        //  ]
        );
      })
    );
  }

  @override
  void didChangeDependencies() {
    _resolveImage();
    super.didChangeDependencies();
  }

  @override
  void reassemble() {
    _resolveImage(); // in case the image cache was flushed
    super.reassemble();
  }

  void _resolveImage() {
    _imageStream = provider.resolve(createLocalImageConfiguration(context));
    _imageStream.addListener(_handleImageLoaded);
  }

  void _handleImageLoaded(ImageInfo info, bool synchronousCall) {
    print("image loaded: $info");
    setState(() {
      _image = info.image;
    });
  }

  @override
  void dispose() {
    _imageStream.removeListener(_handleImageLoaded);
    super.dispose();
  }
}

class _ZoomableImagePainter extends CustomPainter {
  const _ZoomableImagePainter({this.image, this.offset, this.scale});

  final ui.Image image;
  final Offset offset;
  final double scale;

  @override
  void paint(Canvas canvas, Size canvasSize) {
    Size imageSize = new Size(image.width.toDouble(), image.height.toDouble());
    Size targetSize = imageSize * scale;

    paintImage(
      canvas: canvas,
      rect: offset & targetSize,
      image: image,
      fit: BoxFit.fill,
    );
  }

  @override
  bool shouldRepaint(_ZoomableImagePainter old) {
    return old.image != image || old.offset != offset || old.scale != scale;
  }
}