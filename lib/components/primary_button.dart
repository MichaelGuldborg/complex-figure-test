import 'package:flutter/material.dart';
import 'package:reyo/constants/theme_colors.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color color;
  final Color textColor;
  final bool disabled;

  const PrimaryButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.color = ThemeColors.blue,
    this.textColor = Colors.white,
    this.disabled = false,
  }) : super(key: key);

  static Widget green({
    required text,
    required onPressed,
  }) {
    return PrimaryButton(
      text: text,
      onPressed: onPressed,
      color: ThemeColors.green,
      textColor: Colors.white,
    );
  }

  static Widget grey({
    required text,
    required onPressed,
  }) {
    return PrimaryButton(
      text: text,
      onPressed: onPressed,
      color: ThemeColors.lightGrey,
      textColor: Colors.black,
    );
  }

  static Widget red({
    required text,
    required onPressed,
  }) {
    return PrimaryButton(
      text: text,
      onPressed: onPressed,
      color: ThemeColors.lightRed,
      textColor: ThemeColors.darkRed,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 17),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      color: color,
      focusColor: color,
      hoverColor: color,
      highlightColor: color.withOpacity(0.4),
      splashColor: Colors.white.withOpacity(0.4),
      disabledColor: color.withOpacity(0.6),
      elevation: 0,
      onPressed: disabled ? null : onPressed,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 15,
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
