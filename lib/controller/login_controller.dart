import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_sample/controller/preference_controller.dart';
import 'package:flutter_sample/model/user.dart';
import 'api_controller.dart';
import 'push_notification_controller.dart';

class LoginController with ChangeNotifier
{
    bool isPasswordVisible=false;
    @override
    void dispose() {
      print('disposed');
      super.dispose();
    }
    void changePasswordVisibility()
    {
      isPasswordVisible=!isPasswordVisible;
      notifyListeners();
    }

    Future<String> login(String email,String password) async
    {
       String status='';
       await ApiController.post(ApiController.endpointLogin,json.encode({
         'email':email,
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
              user.token=PreferenceController.getString(
                  PreferenceController.fcmToken);
                 final value =
                 await FirebaseFirestore.instance.collection('users').add(user.toJson());
                 return value;

           }else
             {
               status=response.message;
             }
       });
       return status;
    }
    Future<String> forgotPassword(String email) async
    {
      String status='';
      await ApiController.post(ApiController.endpointLogin,json.encode({
        'email':email,
      })).then((response)  {
        if(response.code==0)
        {

        }else
        {
          status=response.message;
        }
      });
      return status;
    }
}