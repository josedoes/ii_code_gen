import 'package:flutter/material.dart';

class BaseColors {
  static Color blue = Color(0xff2B3EEE);
  static Color lightBlue = const Color(0xff5ABCFF);
  static Color lightPurple = const Color(0xffE8EAFD);
  static Color lightBlue2 = const Color(0xff00BFFB);
  static Color offBlack = Color(0xff292A35);
  static Color black = Colors.black;
  static Color white = Color(0xffFFFFFF);
  static Color offWhite = Color(0xffFFFBFC);

  static Color green = Color(0xff5DB45B);
  static Color pink = Colors.pinkAccent;
  static Color lightGrey1 = Color(0xffDBDBDD);
  static Color lightGrey = Color(0xff9E9EA5);
  static Color purple = Color(0xff9747FF);
  static Color grey = Color(0xff9C9CA9);

  static Color darkGrey = Color(0xff3D3F53);
  static Color darkGrey2 = Color(0xff656779);
  static Color red = Color(0xffE84B36);

  static Color cardGreen = Color(0xFF40913F);
  static Color cardGreenAccent = Color(0xFF5DC95C);

  static Color monitorUserMsgColor = Color(0xFF3D3F53);
}

Color get colorPrimary => BaseColors.blue;

Color get white => BaseColors.white;

Color get black => BaseColors.offBlack;

Color get background => BaseColors.white;

Color get positive => BaseColors.green;

Color get colorDrawerBackground => BaseColors.offBlack;

Color get colorOnDrawerSurface => BaseColors.darkGrey;

Color get colorOnDrawerText => BaseColors.white;

Color get colorBackground => white;

Color get colorErrorRed => BaseColors.red;

Color get colorOnPrimary => BaseColors.white;
