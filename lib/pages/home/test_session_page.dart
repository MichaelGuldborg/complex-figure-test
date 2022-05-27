import 'package:flutter/material.dart';
import 'package:reyo/components/bottom_sheet/bottom_sheet_confirm_negative.dart';
import 'package:reyo/components/info_box.dart';
import 'package:reyo/components/primary_button.dart';
import 'package:reyo/constants/routes.dart';
import 'package:reyo/models/test_session.dart';
import 'package:reyo/providers/complex_figure_test_provider.dart';
import 'package:reyo/providers/test_session_provider.dart';

String toAge(DateTime? date) {
  if (date == null) return '';
  final now = DateTime.now();
  final nowMillis = now.millisecondsSinceEpoch;
  final millis = date.millisecondsSinceEpoch;
  final diff = nowMillis - millis;
  return (diff / 31557600000).floor().toString();
}

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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InfoBox(title: 'Name', subtitle: '${value.name}'),
                // InfoBox(title: 'BirthDate', subtitle: formatDate(value.birthDate)),
                InfoBox(title: 'Age', subtitle: toAge(value.birthDate)),
                InfoBox(title: 'Sex', subtitle: '${value.sex}'),
                InfoBox(title: 'Education', subtitle: '${value.education}'),
              ],
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              childAspectRatio: 1,
              shrinkWrap: true,
              padding: EdgeInsets.all(24),
              crossAxisSpacing: 32,
              mainAxisSpacing: 32,
              children: List.generate(values.length, (index) {
                final e = values[index];
                final title =
                    ['Copy', 'Immediate recall', 'Delayed recall'][index];
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, Routes.review, arguments: e);
                  },
                  child: Container(
                    padding: EdgeInsets.all(24),
                    decoration:
                        BoxDecoration(color: Colors.white, boxShadow: const [
                      BoxShadow(
                        color: Color(0x19000000),
                        offset: Offset(0, 2),
                        blurRadius: 10,
                        spreadRadius: 0,
                      ),
                    ]),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            child: Visibility(
                              visible: e.image != null,
                              child: Image.network(e.image ?? ''),
                              replacement: Text('no preview'),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'Accuracy:',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '26/36',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              'Strategy:',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '22/36',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        // Text(
                        //   'Not scored',
                        //   style: TextStyle(
                        //     fontSize: 18,
                        //     fontWeight: FontWeight.w600,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
          // Expanded(
          //   child: ListView(
          //     padding: EdgeInsets.all(24),
          //     children: List.generate(values.length, (index) {
          //       final e = values[index];
          //
          //       return Container(
          //         margin: EdgeInsets.only(bottom: 24),
          //         decoration: BoxDecoration(
          //           borderRadius: BorderRadius.circular(4),
          //           color: Colors.white,
          //           boxShadow: [
          //             BoxShadow(
          //               color: Colors.black.withAlpha(25),
          //               blurRadius: 15,
          //             )
          //           ],
          //         ),
          //         child: ListTile(
          //           contentPadding: EdgeInsets.all(24),
          //           leading: Container(
          //             width: 100,
          //             height: 100,
          //             margin: EdgeInsets.only(right: 16),
          //             alignment: Alignment.center,
          //             child: Visibility(
          //               visible: e.image != null,
          //               child: Image.network(e.image ?? ''),
          //               replacement: Text('no preview'),
          //             ),
          //           ),
          //           title: Text(
          //             formatDate(e.start),
          //             style: TextStyle(fontSize: 24),
          //           ),
          //           onTap: () {
          //             Navigator.pushNamed(context, Routes.review, arguments: e);
          //           },
          //         ),
          //       );
          //     }),
          //   ),
          // ),
        ],
      ),
    );
  }
}
