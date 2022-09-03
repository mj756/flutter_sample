import 'package:flutter/material.dart';
import 'package:flutter_sample/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomStyles {

   static const int extraSmallFont=10;
   static const int smallFont=12;
   static const int normalFont=14;
   static const int largeFont=16;
   static const int extraLargeFont=18;



  static TextStyle customTextStyle(
      {Color defaultColor = CustomColors.blackColor,
      bool isBold = false,
      bool isUnderLine = false,
      isNormalFont=true,isExtraSmallFont=false,isSmallFont=false,isLargeFont=false,isExtraLargeFont=false}) {

    int fontSize=14;
    if(isExtraSmallFont==true) {
      fontSize=extraSmallFont;
    } else if(isSmallFont==true) {
      fontSize=smallFont;
    } else if(isLargeFont==true) {
      fontSize=largeFont;
    } else if(isExtraLargeFont==true) {
      fontSize=extraLargeFont;
    } else {
      fontSize=normalFont;
    }

    return TextStyle(
        fontFamily: 'Lato',
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
        return  customTextStyle(defaultColor: CustomColors.whiteColor,isLargeFont: true);
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
