import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_sample/controller/preference_controller.dart';
import 'package:flutter_sample/model/user.dart';
import 'package:flutter_sample/utils/constants.dart';

import 'api_controller.dart';

class LoginController with ChangeNotifier {
  bool isPasswordVisible = false;

  @override
  void dispose() {
    super.dispose();
  }

  void changePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  Future<String> login(String email, String password) async {
    String status = '';
    await ApiController.post(
        endpointLogin,
        json.encode({
          'email': email,
          'password': password,
          'fcmToken':
              PreferenceController.getString(PreferenceController.fcmToken)
        })).then((response) {
      if (response.status == 0) {
        AppUser user =
            AppUser.fromJson(json.decode(json.encode(response.data)));
        PreferenceController.setString(
            PreferenceController.prefKeyUserPayload, json.encode(user));
        PreferenceController.setBoolean(
            PreferenceController.prefKeyIsLoggedIn, true);
        PreferenceController.setString(PreferenceController.prefKeyLoginType,
            PreferenceController.loginTypeNormal);
      } else {
        status = response.message;
      }
    });
    return status;
  }

  Future<String> forgotPassword(String email) async {
    String status = '';
    await ApiController.post(
        endpointLogin,
        json.encode({
          'email': email,
        })).then((response) {
      if (response.status == 0) {
      } else {
        status = response.message;
      }
    });
    return status;
  }
}
