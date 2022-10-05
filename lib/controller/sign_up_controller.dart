import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_sample/controller/preference_controller.dart';

import '../model/user.dart';
import '../utils/constants.dart';
import 'api_controller.dart';

class SignUpController with ChangeNotifier {
  bool isPasswordVisible = false;
  @override
  void dispose() {
    // do your stuff here
    super.dispose();
  }

  void changePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  Future<String> signUp(String name, String email, String password) async {
    String status = 'error';
    await ApiController.post(
        AppConstants.endpointRegistration,
        json.encode({
          'email': email,
          'name': name,
          'password': password,
          'gender': 'M',
          'dob': '${DateTime.now().toUtc()}'
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
        status = '';
      } else {
        status = response.message;
      }
    });
    return status;
  }
}
