import 'package:flutter/material.dart';
import 'package:kissaan_flutter/locale/locales.dart';

class NewsDisplay extends StatelessWidget {
 const NewsDisplay(this.news);
  final Map<String, List<String>> news;

  @override
  Widget build(BuildContext context) {
    return  Container(
      constraints: BoxConstraints(
        maxHeight: 250.0, 
        maxWidth: 350.0
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Text(
              AppLocalizations.of(context).news,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.w500
              ),
            ),
          ),
          Container(
            constraints: BoxConstraints(maxHeight: 200.0),
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
            child: Card(
              elevation: 4.0,
              child: ListView(
                padding: EdgeInsets.fromLTRB(5.0, 2.5, 5.0, 2.5),
                shrinkWrap: true,
                children: news.keys.map(
                  (String key) {
                    return _buildNewsTile(key);
                  }
                ).toList(),
              ),
            ),
          ),
        ]
      )
    );
  }

  Widget _buildNewsTile(String eventTitle) {
    return ListTile(
      isThreeLine: true,
      title: Text(
        eventTitle, 
        style: TextStyle(
          fontSize: 20.0, 
          fontWeight: FontWeight.w500
        )
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            news[eventTitle][0], 
            style: TextStyle(
              fontSize: 16.0, 
              fontWeight: FontWeight.w300
            )
          ), 
          Text(
            news[eventTitle][1], 
            style: TextStyle(
              fontSize: 18.0, 
              fontWeight: FontWeight.w400
            )
          )
        ],
      )
    );
  }
}