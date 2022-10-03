import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'constants.dart';

class CustomStyles {
  static TextStyle customTextStyle(
      {Color defaultColor = blackColor,
      bool isBold = false,
      bool isUnderLine = false,
      isNormalFont = true,
      isExtraSmallFont = false,
      isSmallFont = false,
      isLargeFont = false,
      isExtraLargeFont = false}) {
    int fontSize = 14;
    if (isExtraSmallFont == true) {
      fontSize = extraSmallFont;
    } else if (isSmallFont == true) {
      fontSize = smallFont;
    } else if (isLargeFont == true) {
      fontSize = largeFont;
    } else if (isExtraLargeFont == true) {
      fontSize = extraLargeFont;
    } else {
      fontSize = normalFont;
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

  static ButtonStyle filledRoundedCornerButton(
      {bool fullWidth = false,
      int minWidth = 200,
      double minimumHeight = 45,
      Color defaultColor = themeColor,
      Color onPressColor = themeColor}) {
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
      textStyle: MaterialStateProperty.resolveWith<TextStyle>(
          (Set<MaterialState> states) {
        return customTextStyle(defaultColor: whiteColor, isLargeFont: true);
      }),
      minimumSize:
          MaterialStateProperty.resolveWith<Size>((Set<MaterialState> states) {
        return Size(
            fullWidth ? double.infinity : minWidth.toDouble(), minimumHeight);
      }),
    );
  }
}
