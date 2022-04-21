import 'package:flutter/material.dart';

class ThemeColors {
  static const button = blue;
  static const black = Colors.black;

  // static const primary = Color(0xff7B74C8);
  // static const primaryLight = Color(0xff8186E3);
  static const primary = blue;
  static const primaryDark = darkBlue;
  static const primaryLight = lightBlue;
  static const secondary = ThemeColors.offWhite;

  static const backgroundGradient = LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    colors: [primaryDark, primaryLight],
  );
  static const whiteGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Colors.white, ThemeColors.backgroundGrey],
  );
  static const boxShadow = [
    BoxShadow(
      color: Color(0x29171933),
      offset: Offset(0, 0),
      blurRadius: 20,
    )
  ];

  // custom colors
  static const offWhite = Color(0xfff9fafb);
  static const lightGrey = Color(0xfff3f5f7);
  static const backgroundGrey = Color(0xffE4E6EB);
  static const borderGrey = Color(0xffdfe1e6);
  static const shadowGrey = Color(0x29171933);
  static const textGrey = Color(0xff8D949F); // rgb 107 107 107
  static const darkGrey = Color(0xff6a7e91);

  // static const blue = Color(0xff0053cf);
  static const blue = Color(0xff0073ef);
  static const darkBlue = Color(0xff003380);
  static const lightBlue = Color(0xffe0edff);

  static const green = Color(0xff00a387);
  static const darkGreen = Color(0xff00705d);
  static const lightGreen = Color(0xffe0f5f1);

  static const yellow = Color(0xffffac00);
  static const darkYellow = Color(0xffcc8a00);
  static const lightYellow = Color(0xffffeecc);

  static const red = Color(0xffe90421);
  static const darkRed = Color(0xff970215);
  static const lightRed = Color(0xfffbdfe3);

}
