import 'package:flutter/material.dart';
import 'package:flutter_sample/controller/app_setting_controller.dart';
import 'package:flutter_sample/controller/preference_controller.dart';
import 'package:flutter_sample/controller/push_notification_controller.dart';
import 'package:provider/provider.dart';
import 'api_controller.dart';
import 'firebase_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class SplashScreenController with ChangeNotifier{

  bool isLoading=true;
  bool dataLoaded=false;
  @override
  void dispose() {
    //do your stuff here
    super.dispose();
  }
  SplashScreenController(BuildContext context){
    isLoading=true;
    initializeApp(context,isCalledFromConstructor: true).then((value) {
      isLoading=false;
      notifyListeners();
    });
  }
  Future<bool> initializeApp(BuildContext context,{bool isCalledFromConstructor=false}) async {
    bool status = false;
    if(isCalledFromConstructor==false){
      isLoading=true;
      notifyListeners();
    }
    await PreferenceController.initPreference().then((value) {
      String language=PreferenceController.getString(PreferenceController.prefKeyLanguage);
      context.read<AppSettingController>().changeLanguage(language.isEmpty ? 'es':language);
    });
    await ApiController.checkInternetStatus().then((value) async {
      if (value == true) {
        await FirebaseController().initialize();
        await PushNotificationController.initialize();
        status = true;
        dataLoaded=true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                action:SnackBarAction(onPressed: () {
                  initializeApp(context);
                }, label: 'Retry',textColor: Colors.white,),

          content: Text(
            AppLocalizations.of(context)!
                .message_no_internet_connection,
            style: const TextStyle(color: Colors.red,),
          ),
        ));
        status = false;
      }
    });
    isLoading=false;
    notifyListeners();
    return status;
  }

}