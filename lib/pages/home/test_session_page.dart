import 'package:flutter/material.dart';
import 'package:reyo/components/bottom_sheet/bottom_sheet_confirm_negative.dart';
import 'package:reyo/components/primary_button.dart';
import 'package:reyo/constants/routes.dart';
import 'package:reyo/models/test_session.dart';
import 'package:reyo/pages/home/test_review_page.dart';
import 'package:reyo/providers/complex_figure_test_provider.dart';
import 'package:reyo/providers/test_session_provider.dart';

class TestSessionPage extends StatelessWidget {
  const TestSessionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final argument = ModalRoute.of(context)?.settings.arguments as TestSession;
    final value = argument;
    final providerA = TestSessionProvider.of(context);

    final providerB = ComplexFigureTestProvider.of(context);
    final values =
        providerB.all.where((e) => value.testIds.contains(e.id)).toList();

    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding: EdgeInsets.all(8),
          child: Text('${value.name}'),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 24),
            child: PrimaryButton.red(
              text: 'Delete',
              onPressed: () {
                showConfirmNegativeView(
                  context,
                  title: 'Delete test session',
                  onConfirm: () async {
                    await providerA.delete(value.id);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          )
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(24),
        children: List.generate(values.length, (index) {
          final e = values[index];

          return Container(
            margin: EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(25),
                  blurRadius: 15,
                )
              ],
            ),
            child: ListTile(
              contentPadding: EdgeInsets.all(24),
              leading: Container(
                width: 100,
                height: 100,
                margin: EdgeInsets.only(right: 16),
                alignment: Alignment.center,
                child: Visibility(
                  visible: e.image != null,
                  child: Image.network(e.image ?? ''),
                  replacement: Text('no preview'),
                ),
              ),
              title: Text(
                formatDate(e.start),
                style: TextStyle(fontSize: 24),
              ),
              onTap: () {
                Navigator.pushNamed(context, Routes.review, arguments: e);
              },
            ),
          );
        }),
      ),
    );
  }
}
