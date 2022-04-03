import 'package:flutter/material.dart';
import 'package:reyo/constants/routes.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding: EdgeInsets.all(8),
          child: Text('Complex Figure Test'),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(24),
        children: [
          HomeListTile(
            icon: Icons.play_arrow,
            title: 'Start test',
            onTap: () {
              Navigator.pushNamed(context, Routes.test);
            },
          ),
          HomeListTile(
            icon: Icons.library_books,
            title: 'Review test',
            onTap: () {
              Navigator.pushNamed(context, Routes.reviews);
            },
          ),
          HomeListTile(
            icon: Icons.settings,
            title: 'Settings',
            onTap: () {
              Navigator.pushNamed(context, Routes.settings);
            },
          ),
        ],
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
