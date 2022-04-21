import 'package:flutter/material.dart';
import 'package:reyo/components/primary_button.dart';
import 'package:reyo/constants/theme_colors.dart';
import 'package:reyo/pages/test/test_draw_page.dart';
import 'package:reyo/pages/test/test_register_page.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  int index = 0;

  _next() {
    if (index < 6) {
      setState(() => index += 1);
      return;
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      extendBodyBehindAppBar: true,
      body: IndexedStack(
        index: index,
        children: [
          TestRegisterPage(
            onNextPress: (request) {
              // TODO save info
              _next();
            },
          ),
          TestDrawPage(
            onNextPress: () => _next(),
          ),
          TestInfoPage(
            onNextPress: () => _next(),
          ),
          TestDrawPage(
            onNextPress: () => _next(),
          ),
          TestInfoPage(
            onNextPress: () => _next(),
          ),
          TestDrawPage(
            onNextPress: () => _next(),
          ),
          TestInfoPage(
            onNextPress: () => _next(),
          ),
        ],
      ),
    );
  }
}

class TestInfoPage extends StatefulWidget {
  final VoidCallback? onNextPress;

  const TestInfoPage({
    Key? key,
    required this.onNextPress,
  }) : super(key: key);

  @override
  State<TestInfoPage> createState() => _TestInfoPageState();
}

class _TestInfoPageState extends State<TestInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 32),
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                  color: ThemeColors.green.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(100)),
              child: Icon(
                Icons.check,
                color: ThemeColors.green,
                size: 80,
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 12),
              child: Text(
                'Thank you',
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 32),
              child: Text(
                'Your drawing has been saved',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            PrimaryButton(
              text: 'Next',
              onPressed: widget.onNextPress,
            ),
          ],
        ),
      ),
    );
  }
}

String toMinuteSeconds(Duration? duration) {
  if (duration == null) return '';
  final millis = duration.inMilliseconds;
  final minutes = (millis / 60000).floor();
  final seconds = ((millis % 60000) / 1000).floor();
  return '${toDigit(minutes)}:${toDigit(seconds)}';
}

String toDigit(int d) {
  return '$d'.padLeft(2, '0');
}
