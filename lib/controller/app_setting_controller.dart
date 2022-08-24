import 'package:flutter/material.dart';
import 'package:flutter_sample/controller/preference_controller.dart';
import 'package:flutter_sample/model/user.dart';

class AppSettingController extends ChangeNotifier
{
  String appLanguage='en';
  late AppUser currentUser;
  AppSettingController()
  {
    String language=PreferenceController.getString(PreferenceController.prefKeyLanguage);

    appLanguage=language.isEmpty ? 'en':language;
  }
   final ThemeData defaultTheme=ThemeData(
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