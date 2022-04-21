import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reyo/constants/routes.dart';
import 'package:reyo/constants/theme_colors.dart';
import 'package:reyo/providers/state_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = DataPointProvider.of(context);
    final values = provider.all;

    final currentUser = FirebaseAuth.instance.currentUser;
    final title = currentUser?.email ?? 'Complex Figure Test';

    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding: EdgeInsets.all(8),
          child: Text(title),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 24),
            child: IconButton(
              icon: Icon(Icons.settings, size: 40),
              onPressed: () {
                Navigator.pushNamed(context, Routes.settings);
              },
            ),
          ),
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
        children: List.generate(values.length, (index) {
          final e = values[index];
          return TestListTile(
            title: formatDateTime(e.start),
            image: e.image,
            onTap: () {
              provider.currentIndex = index;
              Navigator.pushNamed(context, Routes.review);
            },
          );
        }),
      ),
      // body: ListView(
      //   padding: EdgeInsets.all(24),
      //   children: [
      //     HomeListTile(
      //       icon: Icons.play_arrow,
      //       title: 'Start test',
      //       onTap: () {
      //         Navigator.pushNamed(context, Routes.test);
      //       },
      //     ),
      //     HomeListTile(
      //       icon: Icons.library_books,
      //       title: 'Review test',
      //       onTap: () {
      //         Navigator.pushNamed(context, Routes.reviews);
      //       },
      //     ),
      //     HomeListTile(
      //       icon: Icons.settings,
      //       title: 'Settings',
      //       onTap: () {
      //         Navigator.pushNamed(context, Routes.settings);
      //       },
      //     ),
      //   ],
      // ),
    );
  }
}

String formatDateTime(DateTime e) {
  final year = e.year;
  final month = '${e.month}'.padLeft(2, '0');
  final day = '${e.day}'.padLeft(2, '0');
  final hours = '${e.hour}'.padLeft(2, '0');
  final minutes = '${e.minute}'.padLeft(2, '0');
  return '$day/$month/$year $hours:$minutes';
}

class TestListTile extends StatelessWidget {
  const TestListTile({
    Key? key,
    required this.title,
    this.image,
    this.onTap,
  }) : super(key: key);

  final String title;
  final String? image;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 24),
        padding: EdgeInsets.all(24),
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
        child: Row(
          children: [
            Container(
              width: 100,
              height: 100,
              margin: EdgeInsets.only(right: 16),
              alignment: Alignment.center,
              child: Visibility(
                visible: image != null,
                child: Image.network(image ?? ''),
                replacement: Text('no preview'),
              ),
            ),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeListTile extends StatelessWidget {
  const HomeListTile({
    Key? key,
    required this.icon,
    required this.title,
    this.onTap,
  }) : super(key: key);

  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 24),
        padding: EdgeInsets.all(56),
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
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Icon(
              icon,
              size: 40,
            ),
          ],
        ),
      ),
    );
  }
}
