import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_sample/controller/splash_screen_controller.dart';
import 'package:flutter_sample/utils/app_colors.dart';
import 'package:provider/provider.dart';

import '../controller/preference_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);
  void moveToNextScreen(BuildContext context) {
    if (context.watch<SplashScreenController>().dataLoaded == true) {
      SchedulerBinding.instance.addPostFrameCallback((_) async {
        await Future.delayed(const Duration(seconds: 3)).then((value) {
          Navigator.pushReplacementNamed(
              context,
              PreferenceController.getBoolean(
                          PreferenceController.prefKeyIsLoggedIn) ==
                      true
                  ? '/home'
                  : '/login');
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SplashScreenController(context),
      lazy: false,
      builder: (context, child) {
        return Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.only(
                      top: 50, left: 10, right: 10, bottom: 10),
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: CustomColors.themeColor,
                      image: DecorationImage(
                          image: Image.asset('assets/ic_launcher.png').image)),
                  child: const Text(
                    'Flutter',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Positioned(
                    bottom: 10,
                    left: 1,
                    child: context.watch<SplashScreenController>().isLoading ==
                            true
                        ? SizedBox(
                            height: 3,
                            width: MediaQuery.of(context).size.width,
                            child: const LinearProgressIndicator(
                              backgroundColor: Colors.blue,
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                              minHeight: 3,
                              color: Colors.blue,
                            ),
                          )
                        : Builder(builder: (context) {
                            moveToNextScreen(context);
                            return const SizedBox.shrink();
                          }))
              ],
            ),
          ),
        );
      },
    );
  }
}
