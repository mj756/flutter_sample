import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_sample/Utils/Utility.dart';
import 'package:flutter_sample/controller/sign_up_controller.dart';
import 'package:flutter_sample/utils/constants.dart';
import 'package:flutter_sample/utils/styles.dart';
import 'package:flutter_sample/view/login.dart';
import 'package:flutter_sample/widget/social_login.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';


class SignUpPage extends StatelessWidget {
  SignUpPage({Key? key}) : super(key: key);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    _emailController.text = 'demo@gmail.com';
    _passwordController.text = '1234567890';
    _nameController.text = 'Milan';
    return ChangeNotifierProvider(
        create: (context) => SignUpController(),
        lazy: false,
        builder: (context, child) {
          return Scaffold(
            body: SafeArea(
              child: Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [AppConstants.whiteColor,AppConstants. themeColor],
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
                            height: 450,
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
                                    AppLocalizations.of(context)!
                                        .label_registration,
                                    style: CustomStyles.customTextStyle(
                                        isBold: true,
                                        defaultColor: AppConstants.screenBackgroundColor,
                                        isExtraLargeFont: true),
                                  ),
                                  SizedBox(height: 20.h),
                                  TextFormField(
                                    controller: _nameController,
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(Icons.email),
                                      hintText: AppLocalizations.of(context)!
                                          .label_enter_user_name,
                                      label: Text(AppLocalizations.of(context)!
                                          .label_name),
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return AppLocalizations.of(context)!
                                            .message_invalid_user_name;
                                      }
                                      return null;
                                    },
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
                                        .watch<SignUpController>()
                                        .isPasswordVisible,
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(Icons.lock),
                                      suffixIcon: Icon(context
                                                  .watch<SignUpController>()
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
                                  ElevatedButton(
                                      style: CustomStyles
                                          .filledRoundedCornerButton(
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
                                                          SignUpController>(
                                                      context,
                                                      listen: false)
                                                  .signUp(
                                                      _nameController.text,
                                                      _emailController.text,
                                                      _passwordController.text)
                                                  .then((value) {
                                                if (value.isEmpty) {
                                                  Navigator
                                                      .pushReplacementNamed(
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
                                        AppLocalizations.of(context)!
                                            .label_sign_up,
                                        style: CustomStyles.customTextStyle(
                                            isLargeFont: true,
                                            defaultColor: AppConstants.whiteColor,
                                            isBold: true),
                                      )),
                                  const SocialLogin(),
                                  Expanded(
                                      child: Align(
                                          alignment: Alignment.bottomCenter,
                                          child: RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: AppLocalizations.of(
                                                          context)!
                                                      .label_already_have_account
                                                      .substring(
                                                          0,
                                                          AppLocalizations.of(
                                                                      context)!
                                                                  .label_already_have_account
                                                                  .lastIndexOf(
                                                                      ' ') +
                                                              1),
                                                  style: CustomStyles
                                                      .customTextStyle(
                                                          isSmallFont: true),
                                                ),
                                                TextSpan(
                                                  text: AppLocalizations.of(
                                                          context)!
                                                      .label_already_have_account
                                                      .substring(AppLocalizations
                                                                  .of(context)!
                                                              .label_already_have_account
                                                              .lastIndexOf(
                                                                  ' ') +
                                                          1),
                                                  style: CustomStyles
                                                      .customTextStyle(
                                                          defaultColor:
                                                          AppConstants.themeColor,
                                                          isLargeFont: true,
                                                          isBold: true),
                                                  recognizer:
                                                      TapGestureRecognizer()
                                                        ..onTap = () async {
                                                          await Navigator.pushReplacement(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          LoginPage()));
                                                        },
                                                ),
                                              ],
                                            ),
                                          )))
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
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                        text: AppLocalizations.of(context)!
                                            .label_terms_and_condition
                                            .substring(
                                                0,
                                                AppLocalizations.of(context)!
                                                        .label_terms_and_condition
                                                        .lastIndexOf('terms') -
                                                    1),
                                        style: CustomStyles.customTextStyle(
                                            isNormalFont: true)),
                                    TextSpan(
                                      text: AppLocalizations.of(context)!
                                          .label_terms_and_condition
                                          .substring(
                                              AppLocalizations.of(context)!
                                                      .label_terms_and_condition
                                                      .lastIndexOf('terms') -
                                                  1),
                                      style: CustomStyles.customTextStyle(
                                          defaultColor: AppConstants.whiteColor,
                                          isNormalFont: true,
                                          isBold: true,
                                          isUnderLine: true),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () async {
                                          await Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      LoginPage()));
                                        },
                                    ),
                                  ],
                                ),
                              ),
                            )))
                  ],
                ),
              ),
            ),
          );
        });
  }
}
