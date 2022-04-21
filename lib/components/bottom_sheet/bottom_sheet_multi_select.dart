import 'package:flutter/material.dart';
import 'package:reyo/components/bottom_sheet/bottom_sheet_simple.dart';
import 'package:reyo/components/primary_button.dart';
import 'package:reyo/constants/assets.dart';
import 'package:reyo/constants/theme_colors.dart';

class MultiSelectOption {
  final String key;
  final String name;
  bool value;
  final bool disabled;
  final VoidCallback? onTap;

  MultiSelectOption({
    required this.key,
    required this.name,
    this.value = false,
    this.disabled = false,
    this.onTap,
  });
}

class BottomSheetMultiSelect extends StatefulWidget {
  final List<MultiSelectOption> options;
  final void Function(List<MultiSelectOption> options) onConfirm;

  const BottomSheetMultiSelect({
    Key? key,
    required this.options,
    required this.onConfirm,
  }) : super(key: key);

  @override
  State<BottomSheetMultiSelect> createState() => _BottomSheetMultiSelectState();
}

class _BottomSheetMultiSelectState extends State<BottomSheetMultiSelect> {
  late List<MultiSelectOption> options = widget.options;

  @override
  Widget build(BuildContext context) {
    return BottomSheetSimple(
      child: Container(
        constraints: BoxConstraints(maxHeight: 260),
        child: SingleChildScrollView(
          child: Column(
            children: List.generate(widget.options.length, (index) {
              final option = options[index];
              return GestureDetector(
                onTap: () {
                  if (option.onTap != null) option.onTap!();
                  if (option.disabled) return;
                  setState(() => option.value = !option.value);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  margin: EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: ThemeColors.borderGrey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 12),
                        width: 24,
                        height: 24,
                        // child: Visibility(
                        //   visible: !option.disabled,
                        //   replacement: Image.asset(Assets.checkboxDisabled),
                        //   child: Image.asset(
                        //     option.value ? Assets.checkboxFilled : Assets.checkbox,
                        //   ),
                        // ),
                      ),
                      Text(
                        option.name,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
      actions: [
        PrimaryButton.grey(
          text: 'Annuller',
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        PrimaryButton(
          text: 'OK',
          onPressed: () {
            widget.onConfirm(options);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
