import 'package:flutter/material.dart';
import 'package:gplusapp/Helper/Constance.dart';
import 'package:sizer/sizer.dart';

class AppTheme {
  static ThemeData getTheme() {
    Color primaryColor = Constance.primaryColor;
    Color secondaryColor = Constance.secondaryColor;
    final ColorScheme colorScheme = const ColorScheme.light().copyWith(
      primary: primaryColor,
      secondary: secondaryColor,
    );
    final ThemeData base = ThemeData.dark();
    return base.copyWith(
      colorScheme: colorScheme,
      primaryColor: primaryColor,
      buttonColor: primaryColor,
      indicatorColor: Colors.white,
      splashColor: Colors.white24,
      splashFactory: InkRipple.splashFactory,
      accentColor: secondaryColor,
      canvasColor: Colors.white,
      backgroundColor: Colors.grey[850],
      scaffoldBackgroundColor: Colors.black,
      buttonTheme: ButtonThemeData(
        colorScheme: colorScheme,
        textTheme: ButtonTextTheme.primary,
      ),
      // cursorColor: primaryColor,
      textTheme: _buildTextTheme(base.textTheme),
      primaryTextTheme: _buildTextTheme(base.primaryTextTheme),
      accentTextTheme: _buildTextTheme(base.accentTextTheme),
      platform: TargetPlatform.iOS,
    );
  }

  static TextTheme _buildTextTheme(TextTheme base) {
    return base.copyWith(
      headline6: TextStyle(
        color: base.headline6?.color,
        fontSize: 10.sp,
        fontWeight: FontWeight.w500,
        fontFamily: 'Archivo',
      ),
      subtitle1: TextStyle(
        color: base.subtitle1?.color,
        fontSize: 4.sp,
        fontFamily: 'Archivo',
      ),
      subtitle2: TextStyle(
        color: base.subtitle2?.color,
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        fontFamily: 'Archivo',
      ),
      bodyText2: TextStyle(
        color: base.bodyText2?.color,
        fontSize: 12.sp,
        fontFamily: 'Archivo',
      ),
      bodyText1: TextStyle(
        color: base.bodyText1?.color,
        fontSize: 10.sp,
        fontFamily: 'Archivo',
      ),
      button: TextStyle(
          color: base.button?.color,
          fontSize: 10.sp,
          fontFamily: 'Archivo',
          fontWeight: FontWeight.w600),
      caption: TextStyle(
        color: base.caption?.color,
        fontSize: 8.sp,
        fontFamily: 'Archivo',
      ),
      headline4: TextStyle(
        color: base.headline4?.color,
        fontSize: 13.sp,
        fontFamily: 'Archivo',
      ),
      headline3: TextStyle(
        color: base.headline3?.color,
        fontSize: 18.sp,
        fontFamily: 'Archivo',
      ),
      headline2: TextStyle(
        color: base.headline2?.color,
        fontSize: 20.sp,
        fontFamily: 'Archivo',
      ),
      headline1: TextStyle(
        color: base.headline1?.color,
        fontSize: 24.sp,
        fontFamily: 'Archivo',
      ),
      headline5: TextStyle(
        color: base.headline5?.color,
        fontSize: 12.sp,
        fontFamily: 'Archivo',
      ),
      overline: TextStyle(
        color: base.overline?.color,
        fontSize: 6.sp,
        fontFamily: 'Archivo',
      ),
    );
  }
}
