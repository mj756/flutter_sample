import 'package:flutter/material.dart';
import 'package:flutter_sample/controller/preference_controller.dart';

class AppSetting extends ChangeNotifier
{
  String appLanguage='en';

  AppSetting()
  {
    String language=PreferenceController.getString(PreferenceController.prefKeyLanguage);

    print(language);
    appLanguage=language.isEmpty ? 'en':language;
  }

   ThemeData defaultTheme=ThemeData(
    primarySwatch: Colors.blue,
     visualDensity: VisualDensity.adaptivePlatformDensity,
     iconTheme: const IconThemeData(
       color: Colors.blue,
       size: 18,
     ),

  );
  void changeLanguage(String newLanguage)
  {
    appLanguage=newLanguage;
    PreferenceController.setString(PreferenceController.prefKeyLanguage,newLanguage);
    notifyListeners();
  }

}