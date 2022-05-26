import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reyo/components/UserNameAvatar.dart';
import 'package:reyo/components/primary_button.dart';
import 'package:reyo/constants/routes.dart';
import 'package:reyo/constants/theme_colors.dart';
import 'package:reyo/functions/formatDate.dart';
import 'package:reyo/providers/test_session_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = TestSessionProvider.of(context);
    final values = provider.all;

    final currentUser = FirebaseAuth.instance.currentUser;
    final title = currentUser?.email ?? 'Complex Figure Test';

    onLogoutPress() async {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacementNamed(context, Routes.login);
    }

    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding: EdgeInsets.all(8),
          child: Text(title),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 24),
            child: PrimaryButton.grey(
              text: 'Logout',
              onPressed: onLogoutPress,
            ),
          )
        ],
      ),
      floatingActionButton: MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(40)),
        ),
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        color: ThemeColors.primary,
        child: Text(
          'START TEST',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        onPressed: () {
          Navigator.pushNamed(context, Routes.test);
        },
      ),
      body: ListView(
        padding: EdgeInsets.all(24),
        children: List.generate(
          values.length,
          (index) {
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
                leading: UserNameAvatar(
                  name: '${e.name}',
                ),
                title: Text(
                  '${e.name}',
                  style: TextStyle(fontSize: 24),
                ),
                subtitle: Text(
                  formatDateTime(e.start),
                  style: TextStyle(fontSize: 20),
                ),
                onTap: () {
                  Navigator.pushNamed(context, Routes.session, arguments: e);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
