import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_sample/constant/constants.dart';
import 'package:flutter_sample/controller/app_setting_controller.dart';
import 'package:flutter_sample/model/extra_functionality/video.dart';
import 'package:flutter_sample/view/extra_functionality/chat_user_list.dart';
import 'package:flutter_sample/view/extra_functionality/database_operation.dart';
import 'package:flutter_sample/view/extra_functionality/firestore_database.dart';
import 'package:flutter_sample/view/extra_functionality/googlead_view.dart';
import 'package:flutter_sample/view/extra_functionality/map.dart';
import 'package:flutter_sample/view/home.dart';
import 'package:flutter_sample/view/language_selection.dart';
import 'package:flutter_sample/view/login.dart';
import 'package:flutter_sample/view/profile.dart';
import 'package:flutter_sample/view/sign_up.dart';
import 'package:flutter_sample/view/splash_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  group('main app', () {
    testWidgets('value should start at 0', (tester) async {
      tester.pumpWidget(ScreenUtilInit(
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
                      '/profile': (context) => ProfileScreen(),
                      '/signup': (context) => SignUpPage(),
                      '/home': (context) => HomePage(),
                      '/language': (context) => const SelectLanguage(),
                      '/map': (context) => GoogleView(),
                      '/chatting': (context) => const ChatUserList(),
                      '/database': (context) => DatabaseOperation(),
                      '/firestorage': (context) => FirebaseDatabaseOperation(),
                      '/video': (context) => VideoPlayerView(),
                      '/advertisement': (context) => BannerAdPage(),
                    },
                  );
                });
          }));
      expect(find.byElementType(MaterialApp), findsOneWidget);
    });
  });
}
