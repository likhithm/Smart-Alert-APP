import 'dart:ui';
import 'package:kissaan_flutter/locale/locales.dart';

class Application {

  static final Application _application = Application._internal();

  AppLocalizationsDelegate delegate = new AppLocalizationsDelegate();

  factory Application() {
    return _application;
  }

  Application._internal();

  final List<String> supportedLanguages = [
    "English",
    "हिंदी",
    "తెలుగు"
  ];

  final List<String> supportedLanguagesCodes = [
    "en",
    "hi",
    'en_AU'
  ];

  List<String> _cowBreeds = [
    "Ongole",
    "Punganoor",
    "Holstein",
    "Jersey",
    "Gir",
    "Shahiwal",
    "Deoni",
    "Ratti",
    "Other"
  ];

  List<String> _buffaloBreeds = [
    "Murrah",
    "Mehsana",
    "Jaffarbadi",
    "Banni",
    "Other"
  ];

  //returns the list of supported Locales
  Iterable<Locale> supportedLocales() =>
      supportedLanguagesCodes.map<Locale>((language) => Locale(language, ""));

  //function to be invoked when changing the language
  LocaleChangeCallback onLocaleChanged;
}

Application application = Application();


typedef void LocaleChangeCallback(Locale locale);