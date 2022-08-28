import 'package:flutter/material.dart';
import 'package:flutter_sample/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomStyles {

  static late  BuildContext? context;
  static bool isInitialize=false;
  static void setContext(BuildContext context1){
    if(isInitialize==false) {
      context=context1;
      isInitialize=true;
    }
  }


  static TextStyle normalTextStyle({Color defaultColor = CustomColors.blackColor,
    bool isBold = false,
    bool isUnderLine = false,
    double fontSize = 14}){
    return Theme.of(context!).textTheme.bodyText2!;
  }

  static TextStyle customTextStyle(
      {Color defaultColor = CustomColors.blackColor,
      bool isBold = false,
      bool isUnderLine = false,
      double fontSize = 14}) {

    return  Theme.of(context!).textTheme.bodyText2!.copyWith(color: defaultColor);
    return TextStyle(
        color: defaultColor,
        fontSize: fontSize.h,
        fontWeight: isBold == true ? FontWeight.bold : FontWeight.normal,
        decoration: isUnderLine == true
            ? TextDecoration.underline
            : TextDecoration.none);
  }


  static ButtonStyle themeBigFilledRoundedCornerButtonStyle(
      {bool fullWidth = false, int minWidth = 200,double minimumHeight=45,Color defaultColor=CustomColors.themeColor,Color onPressColor=CustomColors.themeColor}) {
    return ButtonStyle(
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          side: BorderSide.none,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.pressed)) {
            return onPressColor;
          } else {
            return defaultColor;
          }
        },
      ),
      textStyle: MaterialStateProperty.resolveWith<TextStyle>((Set<MaterialState> states) {
        return  Theme.of(context!).textTheme.button!.copyWith(color: defaultColor);
      }),
      minimumSize:
      MaterialStateProperty.resolveWith<Size>((Set<MaterialState> states) {
        return Size(
            fullWidth ? double.infinity :  minWidth.toDouble(),
            minimumHeight);
      }),

    );
  }

}
