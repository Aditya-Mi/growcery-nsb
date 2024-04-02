import 'package:flutter/material.dart';
import 'package:grocery_app/core/constants/colors.dart';

class CustomTextStyle {
  static TextStyle appBarTextStyle() {
    return const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: dark,
    );
  }

  static TextStyle boldTextStyleDark({required double fontSize}) {
    return const TextStyle(
      fontWeight: FontWeight.bold,
      color: dark,
    );
  }

  static TextStyle boldTextStyleDark12() {
    return const TextStyle(
        fontWeight: FontWeight.bold, color: dark, fontSize: 12);
  }

  static TextStyle boldTextStyleBlack({required double fontSize}) {
    return const TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );
  }

  static TextStyle boldTextStyleBlack12() {
    return const TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.black,
      fontSize: 12,
    );
  }

  static TextStyle boldTextStyleBlack46({required double fontSize}) {
    return TextStyle(
      fontWeight: FontWeight.bold,
      color: blackWith46Opacity,
    );
  }

  static TextStyle boldTextStyleBlack4612() {
    return TextStyle(
      fontWeight: FontWeight.bold,
      color: blackWith46Opacity,
      fontSize: 12,
    );
  }

  static TextStyle mediumTextStyle(
      {required double fontSize, required Color color}) {
    return TextStyle(
        fontWeight: FontWeight.w500, fontSize: fontSize, color: color);
  }

  static TextStyle mediumTextStyleDark({required double fontSize}) {
    return TextStyle(
        fontWeight: FontWeight.w500, fontSize: fontSize, color: dark);
  }

  static TextStyle mediumTextStylePrimaryColor({required double fontSize}) {
    return TextStyle(
        fontWeight: FontWeight.w500, fontSize: fontSize, color: primaryColor);
  }
}
