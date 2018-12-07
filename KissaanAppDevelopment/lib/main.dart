import 'dart:async';
import 'package:kissaan_flutter/dashboard/screens/main_screen.dart';
import 'package:kissaan_flutter/locale/Application.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kissaan_flutter/authorization/screens/auth.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kissaan_flutter/locale/locales.dart';
import 'package:kissaan_flutter/splash/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  List<FirebaseApp> apps = await FirebaseApp.allApps();

  if (await FirebaseApp.appNamed("Secondary") == null) {
    final FirebaseApp third = await FirebaseApp.configure(
      name: "Secondary", 
      options: FirebaseOptions(
        googleAppID: "1:12329378561:android:01894e508d82a44a",
        apiKey: "AIzaSyA8h_yR54ctoyApV4n3EBQtYg4B2FopNkU",
        projectID: "kissaanflutternonpersistent",
        androidClientID: "com.example.kissaanflutter",
        databaseURL: "https://kissaanflutternonpersistent.firebaseio.com",
        
      )
    );
  }
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  _MyAppState createState() => _MyAppState();

  static void setLocale(BuildContext context, Locale newLocale) async{
    _MyAppState state = context
      .ancestorStateOfType(TypeMatcher<_MyAppState>());

    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

    SharedPreferences prefs = await _prefs;
    
    state.setState(() {
      state.locale = newLocale;
      prefs.setString('locale', newLocale.languageCode.toString());
    });
  }
}

class _MyAppState extends State<MyApp> {
  Locale locale;
  String code = "";
  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    code = prefs.getString("locale");
    setState(() {
      if(code == "" || code == null)
        locale = new Locale("en_AU");
      else
        locale = new Locale(code);
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      routes: <String, WidgetBuilder> {
        '/auth': (BuildContext context) => new AuthScreen(),
      },
      localizationsDelegates: [
        AppLocalizationsDelegate(newLocale: locale),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: application.supportedLocales(),//[Locale('zh', "CN"), Locale('en', "US"), Locale("hi", "IN"), ],
      onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context).title,
      theme: ThemeData.light().copyWith(
        primaryColor: Color.fromRGBO(0,230,118,1.0),
        accentColor: Color.fromRGBO(91,190,133,1.0),
        // textTheme: TextTheme(
          
        // )
      ),
      home: SplashScreen(),
    );
  }
}