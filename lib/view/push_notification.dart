import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sample/controller/api_controller.dart';
import 'package:flutter_sample/controller/preference_controller.dart';
import 'package:flutter_sample/controller/push_notification_controller.dart';

class PushNotificationTest extends StatelessWidget{
  const PushNotificationTest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(),
     body: Center(
       child: ElevatedButton(
         onPressed: ()async{

           if(PreferenceController.getString(PreferenceController.fcmToken).isEmpty)
             {
               await PushNotificationController.getFCMToken().then((value)  {
                 if(value!=null && value.isNotEmpty)
                 {
                   PreferenceController.setString(PreferenceController.fcmToken,value);
                 }
               });
             }
             await ApiController.sendPushMessage();

         },
         child: Text("Test"),
       ),
     ),
   );
  }




}