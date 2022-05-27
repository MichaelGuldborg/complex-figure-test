import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reyo/components/primary_button.dart';
import 'package:reyo/constants/theme_colors.dart';
import 'package:reyo/models/test_session.dart';
import 'package:reyo/pages/test/test_draw_page.dart';
import 'package:reyo/pages/test/test_register_page.dart';
import 'package:reyo/providers/complex_figure_test_provider.dart';
import 'package:reyo/providers/test_session_provider.dart';
import 'package:reyo/services/flutter_message.dart';

class TestFlowPage extends StatefulWidget {
  const TestFlowPage({Key? key}) : super(key: key);

  @override
  State<TestFlowPage> createState() => _TestFlowPageState();
}

class _TestFlowPageState extends State<TestFlowPage> {
  TestSession? session;
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
    final currentUser = FirebaseAuth.instance.currentUser!;
    final providerA = TestSessionProvider.of(context);
    final providerB = ComplexFigureTestProvider.of(context);

    return Scaffold(
      appBar: AppBar(),
      extendBodyBehindAppBar: true,
      body: IndexedStack(
        index: index,
        children: [
          TestRegisterPage(
            onNextPress: (request) async {
              session = await providerA.create(TestSession(
                id: '${providerA.all.length}',
                uid: currentUser.uid,
                name: request.name,
                birthDate: request.birthDate,
                sex: request.sex,
                education: request.education,
                start: DateTime.now(),
                testIds: [],
              ));
              _next();
            },
          ),
          TestDrawPage(
            onNextPress: (request) async {
              request.type = 'copy';
              final value = await providerB.createWithImage(request);
              if (value == null) return showError('Something went wrong');
              session?.testIds.add(value.id);
              providerA.update(session?.id, session?.toMap());
              _next();
            },
          ),
          TestInfoPage(
            onNextPress: () => _next(),
          ),
          TestDrawPage(
            onNextPress: (request) async {
              request.type = 'immediate-recall';
              final value = await providerB.createWithImage(request);
              if (value == null) return showError('Something went wrong');
              session?.testIds.add(value.id);
              providerA.update(session?.id, session?.toMap());
              _next();
            },
          ),
          TestInfoPage(
            onNextPress: () => _next(),
          ),
          TestDrawPage(
            onNextPress: (request) async {
              request.type = 'delayed-recall';
              final value = await providerB.createWithImage(request);
              if (value == null) return showError('Something went wrong');
              session?.testIds.add(value.id);
              providerA.update(session?.id, session?.toMap());
              _next();
            },
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
