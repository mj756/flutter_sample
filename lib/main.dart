import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_sample/controller/app_setting_controller.dart';
import 'package:flutter_sample/utils/constants.dart';
import 'package:flutter_sample/view/extra_functionality/audio_player.dart';
import 'package:flutter_sample/view/extra_functionality/chat_user_list.dart';
import 'package:flutter_sample/view/extra_functionality/database_operation.dart';
import 'package:flutter_sample/view/extra_functionality/googlead_view.dart';
import 'package:flutter_sample/view/extra_functionality/map.dart';
import 'package:flutter_sample/view/home.dart';
import 'package:flutter_sample/view/language_selection.dart';
import 'package:flutter_sample/view/login.dart';
import 'package:flutter_sample/view/sign_up.dart';
import 'package:flutter_sample/view/splash_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import 'controller/firebase_controller.dart';
import 'controller/push_notification_controller.dart';
import 'model/extra_functionality/video.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await FirebaseController().initialize();
  await PushNotificationController.initialize();
  PushNotificationController.onBackgroundMessage(message);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseController().initialize();
  await MobileAds.instance.initialize();
  RequestConfiguration configuration =
      RequestConfiguration(testDeviceIds: ["79D189AD178449F9A8A6BD36DBB5CA91"]);
  MobileAds.instance.updateRequestConfiguration(configuration);
  await PushNotificationController.initialize();
  FirebaseMessaging.onBackgroundMessage(
      PushNotificationController.onBackgroundMessage);
  FirebaseMessaging.instance.getInitialMessage().then((message) {
    if (message != null) {
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
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, _) {
          return ChangeNotifierProvider(
              create: (context) => AppSettingController(),
              builder: (context, child) {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'Flutter Demo',
                  locale: Locale(
                      context.watch<AppSettingController>().appLanguage, ''),
                  supportedLocales: AppLocalizations.supportedLocales,
                  localizationsDelegates: const [
                    AppLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  theme: ThemeData(
                    fontFamily: 'Lato',
                    primarySwatch: AppConstants.themeColor,
                    visualDensity: VisualDensity.adaptivePlatformDensity,
                    textTheme: Theme.of(context).textTheme,
                    iconTheme: const IconThemeData(
                      color: AppConstants.themeColor,
                      size: 20,
                    ),
                  ),
                  initialRoute: '/splash',
                  routes: {
                    '/splash': (context) => const SplashScreen(),
                    '/login': (context) => LoginPage(),
                    '/signup': (context) => SignUpPage(),
                    '/home': (context) => HomePage(),
                    '/language': (context) => const SelectLanguage(),
                    '/map': (context) => GoogleView(),
                    '/chatting': (context) => const ChatUserList(),
                    '/database': (context) => DatabaseOperation(),
                    '/video': (context) => VideoPlayerView(),
                    '/advertisement': (context) => BannerAdPage(),
                    '/audio': (context) => AudioDemo(),
                  },
                );
              });
        });
  }
}
