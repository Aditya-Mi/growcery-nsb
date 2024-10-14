import 'package:flutter/material.dart';
import 'package:grocery_app/core/constants/colors.dart';

class CustomTextStyle {
  static TextStyle appBarTextStyle() {
    return boldTextStyleDark(fontSize: 20);
  }

  static TextStyle boldTextStyleDark({required double fontSize}) {
    return boldTextStyle(fontSize: fontSize, color: dark);
  }

  static TextStyle boldTextStyleDark12() {
    return boldTextStyle(color: dark, fontSize: 12);
  }

  static TextStyle boldTextStyleBlack({required double fontSize}) {
    return boldTextStyle(fontSize: fontSize, color: Colors.black);
  }

  static TextStyle boldTextStyleBlack12() {
    return boldTextStyle(fontSize: 12, color: Colors.black);
  }

  static TextStyle boldTextStyleBlack46({required double fontSize}) {
    return boldTextStyle(fontSize: fontSize, color: blackWith46Opacity);
  }

  static TextStyle boldTextStyleBlack4612() {
    return boldTextStyle(color: blackWith46Opacity, fontSize: 12);
  }

  static TextStyle mediumTextStyle(
      {required double fontSize, required Color color}) {
    return TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: fontSize,
      color: color,
    );
  }

  static TextStyle boldTextStyle(
      {required double fontSize, required Color color}) {
    return TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: fontSize,
      color: color,
    );
  }

  static TextStyle mediumTextStyleDark({required double fontSize}) {
    return mediumTextStyle(fontSize: fontSize, color: dark);
  }

  static TextStyle mediumTextStylePrimaryColor({required double fontSize}) {
    return mediumTextStyle(fontSize: fontSize, color: primaryColor);
  }

  static TextStyle boldTextStylePrimaryColor({required double fontSize}) {
    return boldTextStyle(fontSize: fontSize, color: primaryColor);
  }
}
