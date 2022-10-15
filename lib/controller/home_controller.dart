import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_sample/controller/api_controller.dart';
import 'package:flutter_sample/controller/preference_controller.dart';
import 'package:flutter_sample/utils/constants.dart';

import '../model/user.dart';

class HomeController with ChangeNotifier {
  int currentPage = 0;
  late AppUser loggedInUser;

  HomeController() {
    getUserProfile();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void changePageIndex(int index) {
    currentPage = index;
    notifyListeners();
  }

  Future<void> getUserProfile() async {
    await ApiController.get(
            '${AppConstants.endpointGeProfileDetail}?id=${PreferenceController.getString(PreferenceController.prefKeyUserId)}')
        .then((response) {
      print(response.data);
      if (response.status == 0) {
        loggedInUser =
            AppUser.fromJson(json.decode(json.encode(response.data)));
      }
    });
  }
}
