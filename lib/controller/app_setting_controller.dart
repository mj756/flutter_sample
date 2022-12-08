import 'package:flutter/material.dart';
import 'package:flutter_sample/controller/preference_controller.dart';

class AppSettingController with ChangeNotifier {
  String appLanguage = 'en';

  AppSettingController() {
    // String language=PreferenceController.getString(PreferenceController.prefKeyLanguage);
    //  appLanguage=language.isEmpty ? 'en':language;
  }

  final ThemeData defaultTheme = ThemeData(
    primarySwatch: Colors.blue,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    iconTheme: const IconThemeData(
      color: Colors.blue,
      size: 18,
    ),
    textTheme: const TextTheme(
      headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
      headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
      bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
    ),
  );

  void changeLanguage(String newLanguage) {
    appLanguage = newLanguage;
    PreferenceController.setString(
        PreferenceController.prefKeyLanguage, newLanguage);
    notifyListeners();
  }

  ThemeData changeTheme(String themeName) {
    return ThemeData(
      primarySwatch: Colors.lime,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      iconTheme: const IconThemeData(
        color: Colors.lime,
        size: 18,
      ),
      textTheme: const TextTheme(
        headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
        headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
        bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Lato'),
      ),
    );
  }
}
