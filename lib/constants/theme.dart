import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final ThemeData theme = ThemeData(
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    color: Colors.transparent,
    titleTextStyle: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    centerTitle: false,
    systemOverlayStyle: SystemUiOverlayStyle.light,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.black),
  ),
);
