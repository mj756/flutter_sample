import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_sample/controller/app_setting_controller.dart';
import 'package:flutter_sample/controller/firebase_controller.dart';
import 'package:flutter_sample/controller/preference_controller.dart';
import 'package:flutter_sample/view/home.dart';
import 'package:flutter_sample/view/login.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseController().initialize();
  await PreferenceController.initPreference();
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
          builder: (context,child){
           return ChangeNotifierProvider(
                create:  (context) => AppSettingController(),
                builder: (context,child){
                  return MaterialApp(
                      debugShowCheckedModeBanner: false,
                      title: 'Flutter Demo',
                      locale: Locale(context.watch<AppSettingController>().appLanguage,''),
                      supportedLocales: AppLocalizations.supportedLocales,
                      localizationsDelegates:  const [
                        AppLocalizations.delegate,
                        GlobalMaterialLocalizations.delegate,
                        GlobalWidgetsLocalizations.delegate,
                        GlobalCupertinoLocalizations.delegate,
                      ],
                      theme: context.watch<AppSettingController>().defaultTheme,
                    home: PreferenceController.getBoolean(PreferenceController.prefKeyIsLoggedIn)==true ?  HomePage():LoginPage(),
                  );
                }
            );
          }
        );
  }
}

