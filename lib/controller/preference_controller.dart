import 'package:shared_preferences/shared_preferences.dart';

class PreferenceController {
  static SharedPreferences? prefs;
  static const String prefKeyUserPayload = "LoggedInUser";
  static const String prefKeyIsLoggedIn = "IsLogin";
  static const String prefKeyUserId = "UserId";
  static const String prefKeyLoginType = "LoginType";

  static const String prefKeyLanguage = "SelectedLanguage";
  static const loginTypeNormal = 'Normal';
  static const loginTypeGoogle = 'Google';
  static const loginTypeApple = 'Apple';
  static const loginTypeFaceBook = 'FaceBook';
  static const loginTypeMicrosoft = 'Microsoft';
  static const apiToken = 'apiToken';
  static const fcmToken = 'fcmToken';

  static Future initPreference() async {
    prefs = await SharedPreferences.getInstance();
  }

  static void clearLoginCredential() {
    if (prefs != null) {
      prefs!.remove(prefKeyUserPayload);
      prefs!.remove(prefKeyIsLoggedIn);
      prefs!.remove(prefKeyUserId);
      prefs!.remove(apiToken);
      prefs!.remove(prefKeyLanguage);
      prefs!.remove(prefKeyLoginType);
    }
  }

  static bool contains(String key) {
    return prefs?.containsKey(key) ?? false;
  }

  static void setInt(String key, int value) async {
    await prefs?.setInt(key, value);
  }

  static int getInt(String key, {int defaultValue = 0}) {
    return prefs?.getInt(key) ?? defaultValue;
  }

  static void setString(String key, String value) async {
    await prefs?.setString(key, value);
  }

  static String getString(String key, {defaultValue = ''}) {
    return prefs?.getString(key) ?? defaultValue;
  }

  static void setBoolean(String key, bool value) async {
    await prefs?.setBool(key, value);
  }

  static bool getBoolean(String key, {defaultValue = false}) {
    return prefs?.getBool(key) ?? defaultValue;
  }

  static void setDouble(String key, double value) async {
    await prefs?.setDouble(key, value);
  }

  static double getDouble(String key) {
    return prefs?.getDouble(key) ?? 0;
  }

  static void remove(String key) async {
    if (contains(key)) {
      await prefs?.remove(key);
    }
  }
}
