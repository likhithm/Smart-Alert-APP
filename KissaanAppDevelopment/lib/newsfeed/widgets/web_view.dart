
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:flutter/material.dart';


class WebView extends StatefulWidget {
  final String url;

  WebView(this.url,);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return WebViewState();
  }

}

class  WebViewState extends State<WebView> {

    final webView = FlutterWebviewPlugin();
    String url;
    //"https://youtube.com/";

    @override
    void initState() {
      super.initState();
      url = widget.url;
      webView.close();
      }

    @override
    void dispose() {
      super.dispose();
    }

    @override
    Widget build(BuildContext context) {
      return WebviewScaffold(
            url: url,
            appBar: AppBar(
                backgroundColor: Color.fromRGBO(91,190,133,1.0),
                title: Text("Kissaan"),

            ),
            withJavascript: true,
            withLocalStorage: true,
            withZoom: true,
          );
    }

}
