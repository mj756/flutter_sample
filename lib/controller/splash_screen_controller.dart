import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_sample/controller/app_setting_controller.dart';
import 'package:flutter_sample/controller/extra_functionality/local_storage_controller.dart';
import 'package:flutter_sample/controller/preference_controller.dart';
import 'package:flutter_sample/controller/push_notification_controller.dart';
import 'package:flutter_sample/utils/constants.dart';
import 'package:provider/provider.dart';

import 'api_controller.dart';
import 'firebase_controller.dart';

class SplashScreenController with ChangeNotifier {
  bool isLoading = true;
  bool dataLoaded = false;
  @override
  void dispose() {
    //do your stuff here
    super.dispose();
  }

  SplashScreenController(BuildContext context) {
    isLoading = true;
    initializeApp(context, isCalledFromConstructor: true).then((value) {
      isLoading = false;
      notifyListeners();
    });
  }
  Future<bool> initializeApp(BuildContext context,
      {bool isCalledFromConstructor = false}) async {
    bool status = false;
    if (isCalledFromConstructor == false) {
      isLoading = true;
      notifyListeners();
    }
    await PreferenceController.initPreference().then((value) {
      String language =
          PreferenceController.getString(PreferenceController.prefKeyLanguage);
      context
          .read<AppSettingController>()
          .changeLanguage(language.isEmpty ? 'es' : language);
    });
    await StorageController.initDatabase();
    await ApiController.checkInternetStatus().then((value) async {
      if (value == true) {
        await FirebaseController().initialize();

       final FirebaseRemoteConfig config= await FirebaseRemoteConfig.instance;
       await config.fetchAndActivate();
       String baseAddress=await config.getString('apiAddress');
       if(baseAddress.isNotEmpty){
         AppConstants.baseAddress=baseAddress;
       }
        await PushNotificationController.initialize();
        if (PreferenceController.getString(PreferenceController.fcmToken)
            .isEmpty) {
          await PushNotificationController.getFCMToken().then((value) {
            if (value != null && value.isNotEmpty) {
              PreferenceController.setString(
                  PreferenceController.fcmToken, value);
            }
          });
        }

        status = true;
        dataLoaded = true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          action: SnackBarAction(
            onPressed: () {
              initializeApp(context);
            },
            label: 'Retry',
            textColor: Colors.white,
          ),
          content: Text(
            AppLocalizations.of(context)!.message_no_internet_connection,
            style: const TextStyle(
              color: Colors.red,
            ),
          ),
        ));
        status = false;
      }
    });
    isLoading = false;
    notifyListeners();
    return status;
  }
}
