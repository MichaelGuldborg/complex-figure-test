import 'package:flutter/material.dart';

class DrawActionButton extends StatelessWidget {
  const DrawActionButton({
    Key? key,
    required this.onTap,
    required this.child,
    required this.backgroundColor,
    this.margin = EdgeInsets.zero,
    this.visible = true,
  }) : super(key: key);

  final VoidCallback onTap;
  final Widget child;
  final Color backgroundColor;
  final bool visible;
  final EdgeInsets margin;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 56,
          height: 56,
          margin: margin,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(100),
            boxShadow: const [
              BoxShadow(
                color: Color(0x19000000),
                offset: Offset(0, 2),
                blurRadius: 10,
                spreadRadius: 0,
              )
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
