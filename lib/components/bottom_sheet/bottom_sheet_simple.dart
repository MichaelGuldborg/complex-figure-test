import 'package:flutter/material.dart';
import 'package:reyo/components/bottom_sheet/bottom_sheet_base.dart';

class BottomSheetSimple extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final Widget? child;
  final List<Widget> actions;
  final EdgeInsets padding;

  const BottomSheetSimple({
    Key? key,
    this.title,
    this.subtitle,
    this.child,
    this.actions = const [],
    this.padding = const EdgeInsets.all(20),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomSheetBase(
      padding: EdgeInsets.zero,
      child: Container(
        padding: padding,
        child: Column(
          children: [
            Visibility(
              visible: title != null,
              child: Container(
                margin: EdgeInsets.only(top: 20, bottom: 20),
                alignment: Alignment.center,
                child: Text(
                  title ?? '',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                ),
              ),
            ),
            Visibility(
              visible: subtitle != null,
              child: Container(
                margin: EdgeInsets.only(bottom: 30),
                alignment: Alignment.center,
                child: Text(
                  subtitle ?? '',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    height: 1.4,
                  ),
                ),
              ),
            ),
            child ?? SizedBox.shrink(),
            Visibility(
              visible: actions.isNotEmpty,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: List.generate(actions.length, (index) => index).expand<Widget>((index) {
                  if (index == actions.length - 1) {
                    return [Expanded(child: actions[index])];
                  }
                  return [
                    Expanded(child: actions[index]),
                    SizedBox(width: padding.right),
                  ];
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
