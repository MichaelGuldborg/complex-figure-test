import 'package:flutter/material.dart';
import 'package:reyo/components/bottom_sheet/bottom_sheet_simple.dart';
import 'package:reyo/components/primary_button.dart';

Future<int?> showSelectBottomSheet(
  BuildContext context, {
  required List<String> options,
  String? title,
  String? subtitle,
}) {
  return showModalBottomSheet<int>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) => BottomSheetSelect(
      title: title,
      subtitle: subtitle,
      options: options,
      onSelect: (index) {
        Navigator.pop(context, index);
      },
    ),
  );
}

class BottomSheetSelect extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final List<String> options;
  final void Function(int index) onSelect;

  const BottomSheetSelect({
    Key? key,
    this.title,
    this.subtitle,
    required this.options,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomSheetSimple(
      title: title,
      subtitle: subtitle,
      child: Container(
        constraints: BoxConstraints(maxHeight: 260),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: List.generate(
              options.length,
              (index) {
                final option = options[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 15),
                  child: PrimaryButton.grey(
                    text: option,
                    onPressed: () {
                      onSelect(index);
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
