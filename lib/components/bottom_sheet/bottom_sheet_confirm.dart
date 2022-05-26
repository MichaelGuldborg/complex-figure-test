import 'package:flutter/material.dart';
import 'package:reyo/components/bottom_sheet/bottom_sheet_simple.dart';
import 'package:reyo/components/primary_button.dart';

Future<void> showConfirmView(BuildContext context, {
  required String title,
  String? subtitle,
  String? confirmText,
  VoidCallback? onConfirm,
}) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) =>
        BottomSheetConfirm(
          title: title,
          subtitle: subtitle,
          confirmText: confirmText,
          onConfirm: onConfirm,
        ),
  );
}

class BottomSheetConfirm extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final Widget? child;
  final String? confirmText;
  final VoidCallback? onConfirm;

  const BottomSheetConfirm({
    Key? key,
    this.title,
    this.subtitle,
    this.child,
    this.confirmText,
    this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomSheetSimple(
      title: title,
      subtitle: subtitle,
      child: child,
      actions: [
        PrimaryButton.grey(
          text: 'Annuller',
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        PrimaryButton.green(
          text: confirmText ?? 'OK',
          onPressed: () {
            if (onConfirm != null) onConfirm!();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
