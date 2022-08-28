import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_sample/controller/app_setting_controller.dart';
import 'package:flutter_sample/utils/styles.dart';
import 'package:flutter_sample/view/home.dart';
import 'package:flutter_sample/view/login.dart';
import 'package:flutter_sample/view/sign_up.dart';
import 'package:flutter_sample/view/splash_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

void main()  {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CustomStyles.setContext(context);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, _) {
          return  ChangeNotifierProvider(
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
                    primarySwatch: Colors.blue,
                    visualDensity: VisualDensity.adaptivePlatformDensity,
                    iconTheme: const IconThemeData(
                      color: Colors.blue,
                      size: 18,
                    ),
                 /*   textTheme: const TextTheme(
                      // headline1: TextStyle(fontSize: 96.0, fontWeight: FontWeight.bold),
                      //  headline2: TextStyle(fontSize: 60.0, fontWeight: FontWeight.bold),
                      //  headline3: TextStyle(fontSize: 48.0, fontWeight: FontWeight.bold),
                      //  headline4: TextStyle(fontSize: 34.0, fontWeight: FontWeight.bold),
                      headline5: TextStyle(
                          fontSize: 24.0, fontWeight: FontWeight.bold),
                      headline6: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                      subtitle1: TextStyle(
                          fontSize: 16.0, fontStyle: FontStyle.italic),
                      subtitle2: TextStyle(
                          fontSize: 14.0, fontStyle: FontStyle.italic),
                      bodyText1: TextStyle(
                          fontSize: 16.0, fontStyle: FontStyle.italic),
                      bodyText2: TextStyle(
                          fontSize: 14.0, fontStyle: FontStyle.italic),
                      button: TextStyle(
                          fontSize: 14.0, fontStyle: FontStyle.italic),
                      caption: TextStyle(
                          fontSize: 12.0, fontStyle: FontStyle.italic),
                      overline: TextStyle(
                          fontSize: 10.0, fontStyle: FontStyle.italic),
                    ),*/
                  ),
                  initialRoute: '/splash',
                  routes: {
                    '/splash': (context) => const SplashScreen(),
                    '/login': (context) =>  LoginPage(),
                    '/signup': (context) =>  SignUpPage(),
                    '/home': (context) =>  HomePage(),
                  },
                );
              });
        });
  }
}
