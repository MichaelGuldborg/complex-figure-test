import 'package:flutter/material.dart';
import 'package:reyo/constants/routes.dart';
import 'package:reyo/constants/theme.dart';
import 'package:reyo/pages/draw_page.dart';
import 'package:reyo/pages/result_page.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rey Osterrieth complex figure test',
      theme: theme,
      initialRoute: Routes.home,
      routes: {
        Routes.home: (context) => DrawPage(),
        Routes.result: (context) => ResultPage(),
      },
    );
  }
}
