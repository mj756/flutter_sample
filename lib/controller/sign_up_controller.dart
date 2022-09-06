import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_sample/controller/preference_controller.dart';
import 'package:flutter_sample/controller/push_notification_controller.dart';
import '../model/user.dart';
import 'api_controller.dart';

class SignUpController extends ChangeNotifier
{
  bool isPasswordVisible=false;
  void changePasswordVisibility()
  {
    isPasswordVisible=!isPasswordVisible;
    notifyListeners();
  }

  Future<String> signUp(String name,String email,String password) async
  {
    String status='';
    await ApiController.post(ApiController.endpointRegistration,json.encode({
      'email':email,
      'name':name,
      'password':password
    })).then((response)  async{
      if(response.code==0)
      {
        AppUser user=AppUser.fromJson(json.decode(json.encode(response.data)));
        PreferenceController.setBoolean(PreferenceController.prefKeyIsLoggedIn,true);
        PreferenceController.setString(PreferenceController.prefKeyUserPayload,json.encode(user));
        await PushNotificationController.getFCMToken().then((value) {
          if(value!=null) {
            PreferenceController.setString(
                PreferenceController.fcmToken, value);
          }
        });
      }else
      {
        status=response.message;
      }
    });
    return status;
  }
}