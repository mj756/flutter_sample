import 'package:flutter/cupertino.dart';

class AppSetting extends ChangeNotifier
{
  String appLanguage='en';
  void changeLanguage(String newLanguage)
  {
    appLanguage=newLanguage;
    notifyListeners();
  }

}