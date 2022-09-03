import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_sample/controller/app_setting_controller.dart';
import 'package:flutter_sample/utils/app_colors.dart';
import 'package:flutter_sample/view/home.dart';
import 'package:flutter_sample/view/language_selection.dart';
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
                    fontFamily: 'Lato',
                    primarySwatch: CustomColors.themeColor,
                    visualDensity: VisualDensity.adaptivePlatformDensity,
                    textTheme: Theme.of(context).textTheme,
                    iconTheme: const IconThemeData(
                      color: CustomColors.themeColor,
                      size: 20,
                    ),
                  ),
                  initialRoute: '/splash',
                  routes: {
                    '/splash': (context) => const SplashScreen(),
                    '/login': (context) =>  LoginPage(),
                    '/signup': (context) =>  SignUpPage(),
                    '/home': (context) =>  HomePage(),
                    '/language': (context) =>  const SelectLanguage(),
                  },
                );
              });
        });
  }
}
