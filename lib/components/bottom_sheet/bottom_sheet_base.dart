import 'package:flutter/material.dart';

class BottomSheetBase extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;

  const BottomSheetBase({
    Key? key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(10),
              ),
            ),
            child: SafeArea(
              child: Container(
                padding: padding,
                child: child,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
