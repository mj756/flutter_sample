import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_sample/constant/constants.dart';
import 'package:flutter_sample/controller/preference_controller.dart';
import 'package:flutter_sample/model/user.dart';

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
        AppConstants.endpointLogin,
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
        PreferenceController.setString(
            PreferenceController.prefKeyUserId, user.id);
        PreferenceController.setString(PreferenceController.prefKeyLoginType,
            PreferenceController.loginTypeNormal);
        PreferenceController.setString(
            PreferenceController.apiToken, user.token);
      } else {
        status = response.message;
      }
    });
    return status;
  }

  Future<String> forgotPassword(String email) async {
    String status = '';
    await ApiController.post(
        AppConstants.endpointForGotPassword,
        json.encode({
          'email': email,
        })).then((response) {
      if (response.status == 0) {
        status = '${response.status}-${response.message}';
      } else {
        status = '${response.status}-${response.message}';
      }
    });
    return status;
  }
}
