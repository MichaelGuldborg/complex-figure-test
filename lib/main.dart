import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reyo/constants/routes.dart';
import 'package:reyo/constants/theme.dart';
import 'package:reyo/pages/home_page.dart';
import 'package:reyo/pages/review/review_page.dart';
import 'package:reyo/pages/test/test_page.dart';
import 'package:reyo/providers/config_provider.dart';
import 'package:reyo/providers/state_provider.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ConfigProvider()),
        ChangeNotifierProvider(create: (context) => StateProvider()),
      ],
      child: MaterialApp(
        title: 'Rey Osterrieth complex figure test',
        theme: theme,
        initialRoute: Routes.home,
        routes: {
          Routes.home: (context) => HomePage(),
          Routes.test: (context) => TestPage(),
          Routes.review: (context) => ReviewPage(),
        },
      ),
    );
  }
}
