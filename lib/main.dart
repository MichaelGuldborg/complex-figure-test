import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reyo/constants/routes.dart';
import 'package:reyo/constants/theme.dart';
import 'package:reyo/pages/auth/RegisterPage.dart';
import 'package:reyo/pages/auth/SplashPage.dart';
import 'package:reyo/pages/auth/forgot_password_page.dart';
import 'package:reyo/pages/auth/login_page.dart';
import 'package:reyo/pages/home/home_page.dart';
import 'package:reyo/pages/home/test_session_page.dart';
import 'package:reyo/pages/home/test_review_page.dart';
import 'package:reyo/pages/settings_page.dart';
import 'package:reyo/pages/test/test_flow_page.dart';
import 'package:reyo/providers/config_provider.dart';
import 'package:reyo/providers/complex_figure_test_provider.dart';
import 'package:reyo/providers/test_session_provider.dart';

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
        ChangeNotifierProvider(create: (context) => TestSessionProvider()),
        ChangeNotifierProvider(create: (context) => ComplexFigureTestProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Rey Osterrieth complex figure test',
        theme: theme,
        initialRoute: Routes.splash,
        routes: {
          Routes.splash: (context) => SplashPage(),
          Routes.login: (context) => LoginPage(),
          Routes.register: (context) => RegisterPage(),
          Routes.forgotPassword: (context) => ForgotPasswordPage(),
          Routes.home: (context) => HomePage(),
          Routes.session: (context) => TestSessionPage(),
          Routes.review: (context) => TestReviewPage(),
          Routes.test: (context) => TestFlowPage(),
        },
        builder: BotToastInit(),
        navigatorObservers: [BotToastNavigatorObserver()],
      ),
    );
  }
}
