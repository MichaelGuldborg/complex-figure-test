import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reyo/constants/theme_colors.dart';

final ThemeData theme = ThemeData(
  brightness: Brightness.light,
  backgroundColor: Colors.transparent,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    color: Colors.transparent,
    systemOverlayStyle: SystemUiOverlayStyle.light,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.black),
  ),
  inputDecorationTheme: InputDecorationTheme(
    // errorStyle: const TextStyle(
    //   color: Colors.transparent,
    //   height: 0.0,
    // ),
    hintStyle: const TextStyle(
      color: ThemeColors.textGrey,
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 17, vertical: 15),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: const BorderSide(
        color: ThemeColors.borderGrey,
        width: 1,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: const BorderSide(
        color: ThemeColors.borderGrey,
        width: 1,
      ),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: const BorderSide(
        color: ThemeColors.borderGrey,
        width: 1,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: const BorderSide(
        color: ThemeColors.primary,
        width: 1,
      ),
    ),
  ),
);
