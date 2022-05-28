import 'package:flutter/material.dart';
import 'package:reyo/components/bottom_sheet/bottom_sheet_confirm_negative.dart';
import 'package:reyo/components/info_box.dart';
import 'package:reyo/components/primary_button.dart';
import 'package:reyo/constants/routes.dart';
import 'package:reyo/constants/theme_colors.dart';
import 'package:reyo/functions/capitalize.dart';
import 'package:reyo/functions/toAge.dart';
import 'package:reyo/models/complex_figure_test.dart';
import 'package:reyo/models/test_session.dart';
import 'package:reyo/providers/complex_figure_test_provider.dart';
import 'package:reyo/providers/test_session_provider.dart';

class SessionPage extends StatelessWidget {
  const SessionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    final argument = ModalRoute.of(context)?.settings.arguments as TestSession;
    final value = argument;
    final providerA = TestSessionProvider.of(context);

    final providerB = ComplexFigureTestProvider.of(context);
    final values =
        providerB.all.where((e) => value.testIds.contains(e.id)).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Test session'),
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
                InfoBox(title: 'Age', subtitle: toAge(value.birthDate)),
                InfoBox(title: 'Sex', subtitle: '${value.sex}'),
                InfoBox(title: 'Education', subtitle: '${value.education}'),
              ],
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: isPortrait ? 2 : 3,
              childAspectRatio: 3 / 4,
              shrinkWrap: true,
              padding: EdgeInsets.all(24),
              crossAxisSpacing: 32,
              mainAxisSpacing: 32,
              children: List.generate(values.length, (index) {
                final ComplexFigureTest e = values[index];
                return Container(
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            capitalize(e.type?.replaceAll('-', ' ')),
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Visibility(
                            visible: e.accuracy != null,
                            child: Icon(
                              Icons.check,
                              color: ThemeColors.green,
                              size: 40,
                            ),
                          )
                        ],
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
                          children: [
                            Text(
                              'Accuracy:',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              e.accuracy == null ? '-' : '${e.accuracy}/36',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Strategy:',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              e.strategy == null ? '-' : '${e.strategy}/36',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: PrimaryButton(
                              text: 'Playback',
                              onPressed: () {
                                Navigator.pushNamed(context, Routes.playback,
                                    arguments: e);
                              },
                            ),
                          ),
                          Container(width: 16),
                          Expanded(
                            child: PrimaryButton(
                              text: 'Review',
                              onPressed: () {
                                Navigator.pushNamed(context, Routes.review,
                                    arguments: e);
                              },
                            ),
                          ),
                        ],
                      )
                    ],
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
