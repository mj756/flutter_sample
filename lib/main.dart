import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_sample/controller/app_setting_controller.dart';
import 'package:flutter_sample/controller/firebase_controller.dart';
import 'package:flutter_sample/controller/preference_controller.dart';
import 'package:flutter_sample/view/home.dart';
import 'package:flutter_sample/view/push_notification.dart';
import 'package:provider/provider.dart';

import 'controller/push_notification_controller.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await FirebaseController().initialize();
  await PushNotificationController.initialize();
  PushNotificationController.onBackgroundMessage(message);
}
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseController().initialize();
  await PreferenceController.initPreference();
  await PushNotificationController.initialize();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  FirebaseMessaging.instance.getInitialMessage().then((message) {
    if(message!=null) {
      PushNotificationController.getInitialMessage(message);
    }
  });
  FirebaseMessaging.onMessage
      .listen(PushNotificationController.onMessageReceive);
  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    PushNotificationController.onMessageOpenedApp(event);
  });
  runApp(
     const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
        return ChangeNotifierProvider(
          create:  (context) => AppSetting(),
          builder: (context,child){
            return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Flutter Demo',
                locale: Locale(context.watch<AppSetting>().appLanguage,''),
                supportedLocales: AppLocalizations.supportedLocales,
                localizationsDelegates:  const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                theme: context.watch<AppSetting>().defaultTheme,
                home: PushNotificationTest()
            );
          }
        );
  }
}

