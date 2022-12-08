import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_sample/Utils/Utility.dart';
import 'package:flutter_sample/constant/constants.dart';
import 'package:flutter_sample/controller/sign_up_controller.dart';
import 'package:flutter_sample/utils/styles.dart';
import 'package:flutter_sample/view/login.dart';
import 'package:flutter_sample/widget/social_login.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../widget/progress_indicator.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({Key? key}) : super(key: key);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => SignUpController(),
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
                    children: [
                      Expanded(
                        flex: 3,
                        child: Container(
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.fitHeight,
                                    image:
                                        AssetImage('assets/ic_launcher.png'))),
                            padding: EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
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
                                      .label_registration,
                                  style: CustomStyles.customTextStyle(
                                      isBold: true,
                                      defaultColor: AppConstants.whiteColor,
                                      isExtraLargeFont: true),
                                ),
                              ],
                            )),
                      ),
                      Expanded(
                        flex: 7,
                        child: Container(
                          padding: EdgeInsets.all(10.w),
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
                                      controller: _nameController,
                                      decoration: InputDecoration(
                                        prefixIcon: const Icon(Icons.person),
                                        hintText: AppLocalizations.of(context)!
                                            .label_enter_user_name,
                                        label: Text(
                                            AppLocalizations.of(context)!
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
                                    SizedBox(height: 20.h),
                                    TextFormField(
                                      controller: _passwordController,
                                      obscureText: !context
                                          .watch<SignUpController>()
                                          .isPasswordVisible,
                                      decoration: InputDecoration(
                                        prefixIcon: const Icon(Icons.lock),
                                        suffixIcon: GestureDetector(
                                          onTap: () =>
                                              Provider.of<SignUpController>(
                                                      context,
                                                      listen: false)
                                                  .changePasswordVisibility(),
                                          child: Icon(context
                                                      .watch<SignUpController>()
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
                                          await Provider.of<SignUpController>(
                                                  context,
                                                  listen: false)
                                              .signUp(
                                                  _nameController.text,
                                                  _emailController.text,
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
                                    AppLocalizations.of(context)!.label_sign_up,
                                    style: CustomStyles.customTextStyle(
                                        isLargeFont: true,
                                        defaultColor: AppConstants.whiteColor,
                                        isBold: true),
                                  )),
                              const SocialLogin(),
                              Align(
                                  alignment: Alignment.bottomCenter,
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: AppLocalizations.of(context)!
                                              .label_already_have_account
                                              .substring(
                                                  0,
                                                  AppLocalizations.of(context)!
                                                          .label_already_have_account
                                                          .lastIndexOf(' ') +
                                                      1),
                                          style: CustomStyles.customTextStyle(
                                              isSmallFont: true),
                                        ),
                                        TextSpan(
                                          text: AppLocalizations.of(context)!
                                              .label_already_have_account
                                              .substring(AppLocalizations.of(
                                                          context)!
                                                      .label_already_have_account
                                                      .lastIndexOf(' ') +
                                                  1),
                                          style: CustomStyles.customTextStyle(
                                              defaultColor:
                                                  AppConstants.themeColor,
                                              isLargeFont: true,
                                              isBold: true),
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
                                  )),
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
                                                  text: AppLocalizations.of(
                                                          context)!
                                                      .label_agree_terms,
                                                  style: CustomStyles
                                                      .customTextStyle(
                                                          isNormalFont: true)),
                                              TextSpan(
                                                text: AppLocalizations.of(
                                                        context)!
                                                    .label_terms_and_condition,
                                                style: CustomStyles
                                                    .customTextStyle(
                                                        defaultColor:
                                                            AppConstants
                                                                .themeColor,
                                                        isNormalFont: true,
                                                        isBold: true,
                                                        isUnderLine: true),
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
                                        ),
                                      )))
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
}
