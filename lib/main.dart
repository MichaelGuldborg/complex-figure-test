import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reyo/constants/routes.dart';
import 'package:reyo/constants/theme.dart';
import 'package:reyo/pages/home_page.dart';
import 'package:reyo/pages/review/review_list_page.dart';
import 'package:reyo/pages/review/review_page.dart';
import 'package:reyo/pages/settings_page.dart';
import 'package:reyo/pages/test/test_page.dart';
import 'package:reyo/providers/config_provider.dart';
import 'package:reyo/providers/state_provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SettingsProvider()),
        ChangeNotifierProvider(create: (context) => DataPointProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Rey Osterrieth complex figure test',
        theme: theme,
        initialRoute: Routes.home,
        routes: {
          Routes.home: (context) => HomePage(),
          Routes.test: (context) => TestPage(),
          Routes.reviews: (context) => ReviewListPage(),
          Routes.review: (context) => ReviewPage(),
          Routes.settings: (context) => SettingsPage(),
        },
      ),
    );
  }
}
