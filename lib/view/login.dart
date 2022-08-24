import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sample/controller/login_controller.dart';
import 'package:flutter_sample/utils/app_colors.dart';
import 'package:flutter_sample/utils/styles.dart';
import 'package:flutter_sample/view/home.dart';
import 'package:flutter_sample/view/sign_up.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../utils/utility.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => LoginController(),
        builder: (context, child) {
          return Scaffold(
            body: SafeArea(
              child: Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        CustomColors.whiteColor,
                        CustomColors.themeColor
                      ],
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(2.w))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 9,
                      child: Stack(children: [
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            padding: EdgeInsets.all(10.w),
                            height: 400,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.w))),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Login',
                                    style: CustomStyles.customTextStyle(
                                        isBold: true,
                                        defaultColor:
                                            CustomColors.screenBackgroundColor,
                                        fontSize: 18),
                                  ),
                                  SizedBox(height: 20.h),
                                  TextFormField(
                                    controller: _emailController,
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(Icons.email),
                                      hintText: AppLocalizations.of(context)!
                                          .title_enter_address,
                                      label: Text(AppLocalizations.of(context)!
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
                                  SizedBox(height: 20.h),
                                  TextFormField(
                                    controller: _passwordController,
                                    obscureText: !context
                                        .watch<LoginController>()
                                        .isPasswordVisible,
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(Icons.lock),
                                      suffixIcon: Icon(context
                                                  .watch<LoginController>()
                                                  .isPasswordVisible ==
                                              true
                                          ? Icons.visibility
                                          : Icons.visibility_off),
                                      hintText: AppLocalizations.of(context)!
                                          .title_enter_password,
                                      label: Text(AppLocalizations.of(context)!
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
                                  SizedBox(height: 20.h),
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
                                              defaultColor: CustomColors
                                                  .screenBackgroundColor,
                                              isBold: true)),
                                    ),
                                  ),
                                  SizedBox(height: 20.h),
                                  ElevatedButton(
                                      style: CustomStyles
                                          .themeBigFilledRoundedCornerButtonStyle(
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
                                              await Provider.of<
                                                          LoginController>(
                                                      context,
                                                      listen: false)
                                                  .login(_emailController.text,
                                                      _passwordController.text)
                                                  .then((value) {
                                                if (value.isEmpty) {
                                                  Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                               HomePage()));
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
                                        AppLocalizations.of(context)!
                                            .label_login,
                                        style: CustomStyles.customTextStyle(
                                            fontSize: 16,
                                            defaultColor:
                                                CustomColors.whiteColor,
                                            isBold: true),
                                      ))
                                ],
                              ),
                            ),
                          ),
                        ),
                      ]),
                    ),
                    Expanded(
                        flex: 1,
                        child: Align(
                            alignment: Alignment.bottomCenter,
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: AppLocalizations.of(context)!
                                        .label_do_not_have_account
                                        .substring(
                                            0,
                                            AppLocalizations.of(context)!
                                                    .label_do_not_have_account
                                                    .lastIndexOf(' ') +
                                                1),
                                    style: CustomStyles.customTextStyle(
                                        fontSize: 13),
                                  ),
                                  TextSpan(
                                    text: AppLocalizations.of(context)!
                                        .label_do_not_have_account
                                        .substring(AppLocalizations.of(context)!
                                                .label_do_not_have_account
                                                .lastIndexOf(' ') +
                                            1),
                                    style: CustomStyles.customTextStyle(
                                        defaultColor: CustomColors.whiteColor,
                                        fontSize: 15,
                                        isBold: true),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () async {
                                        await Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SignUpPage()));
                                      },
                                  ),
                                ],
                              ),
                            )))
                  ],
                ),
              ),
            ),
          );
        });
  }

  Future<void> _showMyDialog(BuildContext context) async {
    final TextEditingController forgotPasswordController =
        TextEditingController();
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(10.w),
          title: Text(AppLocalizations.of(context)!.label_forgot_password),
          content: SingleChildScrollView(
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
                SizedBox(
                  height: 20.h,
                ),
                ElevatedButton(
                    style: CustomStyles.themeBigFilledRoundedCornerButtonStyle(
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
                            await Provider.of<LoginController>(context,
                                    listen: false)
                                .forgotPassword(
                              _emailController.text,
                            )
                                .then((value) {
                              if (value.isEmpty) {
                                Navigator.pop(context);
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
                          fontSize: 16,
                          defaultColor: CustomColors.whiteColor,
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
