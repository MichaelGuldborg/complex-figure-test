import 'package:flutter/material.dart';
import 'package:reyo/components/bottom_sheet/bottom_sheet_simple.dart';
import 'package:reyo/components/primary_button.dart';

showBottomSheetTextArea(
  BuildContext context, {
  required Function(String text) onTap,
  String? text,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => BottomSheetTextArea(
      onTap: onTap,
      text: text,
    ),
  );
}

class BottomSheetTextArea extends StatelessWidget {
  BottomSheetTextArea({
    Key? key,
    required this.onTap,
    String? text,
  }) : super(key: key) {
    _text.text = text ?? '';
  }

  final _text = TextEditingController();
  final Function(String text) onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: BottomSheetSimple(
        title: 'Notes',
        child: Container(
          margin: EdgeInsets.only(bottom: 24),
          child: TextField(
            controller: _text,
            minLines: 4,
            maxLines: 8,
            decoration: InputDecoration(
              hintText: 'Write your notes here...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(
                  color: Colors.grey.shade300,
                  width: 1,
                ),
              ),
            ),
          ),
        ),
        actions: [
          PrimaryButton.grey(
              text: 'Cancel', onPressed: () => Navigator.pop(context)),
          PrimaryButton.green(
            text: 'Save',
            onPressed: () {
              onTap(_text.text.trim());
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
