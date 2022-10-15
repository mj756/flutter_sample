import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_sample/controller/preference_controller.dart';

import '../model/user.dart';
import '../utils/constants.dart';
import 'api_controller.dart';

class ProfileController extends ChangeNotifier {
  late AppUser user;
  late String filePath;
  late String selectedGender = '';
  List<String> genderList = List.empty(growable: true);
  ProfileController(List<String> genders) {
    user = AppUser.fromJson(json.decode(PreferenceController.getString(
        PreferenceController.prefKeyUserPayload)));
    filePath = user.profileImage;
    genderList.clear();
    genderList.addAll(genders);

    if (user.gender.isEmpty) {
      selectedGender = genderList[0];
    } else {
      switch (user.gender) {
        case 'M':
          selectedGender = genderList[1];
          break;
        case 'F':
          selectedGender = genderList[2];
          break;
        case 'O':
          selectedGender = genderList[3];
          break;
      }
    }
  }
  Future<String> changeProfile(
      {required String name,
      required String email,
      required String password}) async {
    String status = '';
    Map<String, String> param = {};
    param['id'] =
        '${PreferenceController.getString(PreferenceController.prefKeyUserId)}';
    param['email'] = email;
    param['name'] = name;
    param['password'] = password;
    param['dob'] = user.dob;
    param['gender'] = user.gender;

    await ApiController.postFormData(AppConstants.endpointChangeProfileImage,
            filePath.startsWith('http') ? '' : filePath, param)
        .then((response) {
      if (response.status == 0) {
        AppUser temp =
            AppUser.fromJson(json.decode(json.encode(response.data)));
        user.profileImage = temp.profileImage;
        user.name = temp.name;
        user.email = temp.email;
        user.gender = temp.gender;
        user.dob = temp.dob;
        PreferenceController.setString(
            PreferenceController.prefKeyUserPayload, json.encode(user));
        status = '${response.status}-${response.message}';
        notifyListeners();
      } else {
        status = '${response.status}-${response.message}';
      }
    });
    return status;
  }

  void changeFilePath(String path) {
    filePath = path;
    notifyListeners();
  }

  void changeDob(String date) {
    user.dob = date;
    notifyListeners();
  }

  void changeGender(String value) {
    if (value != genderList[0]) {
      selectedGender = value;
      int index = genderList.indexOf(value);
      switch (index) {
        case 1:
          user.gender == 'M';
          break;
        case 2:
          user.gender == 'F';
          break;
        case 3:
          user.gender == 'O';
          break;
      }
    }
    notifyListeners();
  }
}
