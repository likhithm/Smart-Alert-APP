import 'package:flutter/material.dart';
import 'package:kissaan_flutter/locale/locales.dart';
import 'package:kissaan_flutter/utils/NavBarState.dart';
class NavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: NavBarState.of(context).onTapped, 
      currentIndex: NavBarState.of(context).currentIndex, 
      items: [
        //0xe804 profile icon code.
        _buildNavigationBarItem(
          0xe800, 
          AppLocalizations.of(context).newsfeedPageTitle, 
          context
        ),
        _buildNavigationBarItem(
          0xe803,
            AppLocalizations.of(context).cattle,
          context
        ),
        _buildNavigationBarItem(
          0xe802,
            AppLocalizations.of(context).enterYield,
          context
        ),
        _buildNavigationBarItem(
          0xe801,
            AppLocalizations.of(context).tasks,
          context
        )
      ],
    );
  }

  BottomNavigationBarItem _buildNavigationBarItem(
    int iconCode, 
    String text, 
    BuildContext context
  ) 
  {
    return BottomNavigationBarItem(
      icon: Icon(
        IconData(
          iconCode, 
          fontFamily: "Kissaan"
        ),
        color: Colors.black38,
      ),
      activeIcon: Icon(
        IconData(
          iconCode, 
          fontFamily: "Kissaan"
        ), 
        color: Theme.of(context).accentColor
      ),
      title: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: Theme.of(context).accentColor
        )
      )
    );
  }
}

