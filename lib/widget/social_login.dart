import 'package:flutter/material.dart';
import 'package:flutter_sample/controller/extra_functionality/social_login_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class SocialLogin extends StatelessWidget {
  const SocialLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => SocialLoginController(),
        lazy: false,
        builder: (context, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                padding: const EdgeInsets.only(right: 5),
                onPressed: () async {
                  await context
                      .read<SocialLoginController>()
                      .googleLogin(context)
                      .then((value) {
                    if (value.isEmpty) {
                      Navigator.pushReplacementNamed(context, '/home');
                    } else {
                      print(value);
                    }
                  });
                },
                icon: Image.asset(
                  'assets/google.png',
                  height: 30,
                  width: 30,
                ),
                iconSize: ScreenUtil().setHeight(50),
              ),
              IconButton(
                padding: const EdgeInsets.only(right: 5),
                onPressed: () async {
                  /* await context
                          .read<SocialLoginController>()
                          .appleLogin(context);*/
                },
                icon: Image.asset(
                  'assets/apple.png',
                  height: 30,
                  width: 30,
                ),
                iconSize: ScreenUtil().setHeight(50),
              ),
              IconButton(
                padding: const EdgeInsets.only(right: 5),
                onPressed: () async {
                  await context
                      .read<SocialLoginController>()
                      .facebookLogin(context)
                      .then((value) {
                    if (value.isEmpty) {
                      Navigator.pushReplacementNamed(context, '/home');
                    }
                  });
                },
                icon: Image.asset(
                  'assets/facebook.png',
                  height: 30,
                  width: 30,
                ),
                iconSize: ScreenUtil().setHeight(50),
              ),
              IconButton(
                padding: const EdgeInsets.only(right: 5),
                onPressed: () async {
                  /* await context.read<SocialLoginController>().microsoftLogin();*/
                },
                icon: Image.asset(
                  'assets/microsoft.png',
                  height: 20,
                  width: 20,
                ),
                iconSize: ScreenUtil().setHeight(30),
              )
            ],
          );
        });
  }
}
