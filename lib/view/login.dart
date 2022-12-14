import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_sample/Utils/Utility.dart';
import 'package:flutter_sample/constant/constants.dart';
import 'package:flutter_sample/controller/login_controller.dart';
import 'package:flutter_sample/utils/styles.dart';
import 'package:flutter_sample/widget/social_login.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../widget/progress_indicator.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => LoginController(),
        lazy: false,
        builder: (context, child) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: SafeArea(
              child: GestureDetector(
                onTap: () => Utility.hideKeyboard(),
                child: Container(
                  color: AppConstants.themeColor,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.fitHeight,
                                    image:
                                        AssetImage('assets/ic_launcher.png'))),
                            padding: EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: Alignment.topRight,
                                  child: InkWell(
                                      onTap: () async {
                                        await Navigator.pushNamed(
                                            context, '/language');
                                      },
                                      child: const Icon(
                                        Icons.language,
                                        size: 30,
                                        color: AppConstants.whiteColor,
                                      )),
                                ),
                                Text(
                                  AppLocalizations.of(context)!.label_welcome,
                                  style: CustomStyles.customTextStyle(
                                      isBold: true,
                                      defaultColor: AppConstants.whiteColor,
                                      isExtraLargeFont: true),
                                ),
                                AppConstants.spaceHeight10,
                                Text(
                                  AppLocalizations.of(context)!
                                      .label_login_to_account,
                                  style: CustomStyles.customTextStyle(
                                      isBold: true,
                                      defaultColor: AppConstants.whiteColor,
                                      isLargeFont: true),
                                ),
                              ],
                            )),
                      ),
                      Expanded(
                        flex: 7,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(50),
                                  topRight: Radius.circular(50))),
                          child: Column(
                            children: [
                              Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    TextFormField(
                                      controller: _emailController,
                                      decoration: InputDecoration(
                                        prefixIcon: const Icon(Icons.email),
                                        hintText: AppLocalizations.of(context)!
                                            .title_enter_address,
                                        label: Text(
                                            AppLocalizations.of(context)!
                                                .label_email),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                      ),
                                      validator: (value) {
                                        if (value == null ||
                                            value.isEmpty ||
                                            !Utility.isValidEmail(value)) {
                                          return AppLocalizations.of(context)!
                                              .message_invalid_email;
                                        }
                                        return null;
                                      },
                                    ),
                                    AppConstants.spaceHeight20,
                                    TextFormField(
                                      controller: _passwordController,
                                      obscureText: !context
                                          .watch<LoginController>()
                                          .isPasswordVisible,
                                      decoration: InputDecoration(
                                        prefixIcon: const Icon(Icons.lock),
                                        suffixIcon: GestureDetector(
                                          onTap: () {
                                            Provider.of<LoginController>(
                                                    context,
                                                    listen: false)
                                                .changePasswordVisibility();
                                          },
                                          child: Icon(context
                                                      .watch<LoginController>()
                                                      .isPasswordVisible ==
                                                  true
                                              ? Icons.visibility
                                              : Icons.visibility_off),
                                        ),
                                        hintText: AppLocalizations.of(context)!
                                            .title_enter_password,
                                        label: Text(
                                            AppLocalizations.of(context)!
                                                .label_password),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                      ),
                                      validator: (value) {
                                        if (value == null ||
                                            value.isEmpty ||
                                            value.length < 6) {
                                          return AppLocalizations.of(context)!
                                              .message_minimum_password_length;
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              AppConstants.spaceHeight20,
                              Align(
                                alignment: Alignment.centerRight,
                                child: InkWell(
                                  onTap: () async {
                                    await _showMyDialog(context);
                                  },
                                  child: Text(
                                      AppLocalizations.of(context)!
                                          .label_forgot_password,
                                      style: CustomStyles.customTextStyle(
                                          defaultColor: AppConstants
                                              .screenBackgroundColor,
                                          isBold: true)),
                                ),
                              ),
                              AppConstants.spaceHeight20,
                              ElevatedButton(
                                  style: CustomStyles.filledRoundedCornerButton(
                                      fullWidth: false),
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate() ==
                                        true) {
                                      await Utility.checkInternetStatus()
                                          .then((value) async {
                                        if (value == false) {
                                          Utility.showSnackBar(
                                              context,
                                              AppLocalizations.of(context)!
                                                  .message_no_internet_connection);
                                        } else {
                                          LoadingProgressDialog dialog =
                                              Utility.showLoaderDialog(context);
                                          await Provider.of<LoginController>(
                                                  context,
                                                  listen: false)
                                              .login(_emailController.text,
                                                  _passwordController.text)
                                              .then((value) {
                                            dialog.hideDialog();
                                            if (value.isEmpty) {
                                              Navigator.pushReplacementNamed(
                                                  context, '/home');
                                            } else {
                                              Utility.showSnackBar(
                                                  context, value);
                                            }
                                          });
                                        }
                                      });
                                    }
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)!.label_login,
                                    style: CustomStyles.customTextStyle(
                                        isLargeFont: true,
                                        defaultColor: AppConstants.whiteColor,
                                        isBold: true),
                                  )),
                              SocialLogin(),
                              Expanded(
                                  flex: 1,
                                  child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: AppLocalizations.of(
                                                      context)!
                                                  .label_do_not_have_account
                                                  .substring(
                                                      0,
                                                      AppLocalizations.of(
                                                                  context)!
                                                              .label_do_not_have_account
                                                              .lastIndexOf(
                                                                  ' ') +
                                                          1),
                                              style:
                                                  CustomStyles.customTextStyle(
                                                      isLargeFont: true),
                                            ),
                                            TextSpan(
                                              text: AppLocalizations.of(
                                                      context)!
                                                  .label_do_not_have_account
                                                  .substring(AppLocalizations
                                                              .of(context)!
                                                          .label_do_not_have_account
                                                          .lastIndexOf(' ') +
                                                      1),
                                              style:
                                                  CustomStyles.customTextStyle(
                                                      defaultColor: AppConstants
                                                          .themeColor,
                                                      isExtraLargeFont: true,
                                                      isBold: true),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  Navigator
                                                      .pushReplacementNamed(
                                                          context, '/signup');
                                                },
                                            ),
                                          ],
                                        ),
                                      ))),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  Future<void> _showMyDialog(BuildContext mainContext) async {
    final TextEditingController forgotPasswordController =
        TextEditingController();
    return showDialog<void>(
      context: mainContext,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(10.w),
          title: Text(AppLocalizations.of(context)!.label_forgot_password),
          content: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: ListBody(
              children: <Widget>[
                Text(AppLocalizations.of(context)!
                    .label_send_password_description),
                SizedBox(height: 20.h),
                TextFormField(
                  controller: forgotPasswordController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.email),
                    hintText: AppLocalizations.of(context)!.title_enter_address,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        !Utility.isValidEmail(value)) {
                      return AppLocalizations.of(context)!
                          .message_invalid_email;
                    }
                    return null;
                  },
                ),
                AppConstants.spaceHeight20,
                ElevatedButton(
                    style: CustomStyles.filledRoundedCornerButton(
                        fullWidth: false),
                    onPressed: () async {
                      if (Utility.isValidEmail(forgotPasswordController.text) ==
                          true) {
                        await Utility.checkInternetStatus().then((value) async {
                          if (value == false) {
                            Utility.showSnackBar(
                                context,
                                AppLocalizations.of(context)!
                                    .message_no_internet_connection);
                          } else {
                            await Provider.of<LoginController>(mainContext,
                                    listen: false)
                                .forgotPassword(
                              forgotPasswordController.text,
                            )
                                .then((value) {
                              if (value.isNotEmpty) {
                                Utility.showSnackBar(
                                    context,
                                    value.startsWith('0')
                                        ? 'Password is sent to your email address'
                                        : value
                                            .substring(value.indexOf('-') + 1),
                                    isSuccess: value.startsWith('0'));
                                if (value.startsWith('0'))
                                  Future.delayed(const Duration(seconds: 3))
                                      .then((value) {
                                    Navigator.pop(context);
                                  });
                              } else {
                                Utility.showSnackBar(context, value);
                              }
                            });
                          }
                        });
                      } else {
                        Utility.showSnackBar(
                            context,
                            AppLocalizations.of(context)!
                                .message_invalid_email);
                      }
                    },
                    child: Text(
                      AppLocalizations.of(context)!.label_send,
                      style: CustomStyles.customTextStyle(
                          isLargeFont: true,
                          defaultColor: AppConstants.whiteColor,
                          isBold: true),
                    ))
              ],
            ),
          ),
        );
      },
    );
  }
}
