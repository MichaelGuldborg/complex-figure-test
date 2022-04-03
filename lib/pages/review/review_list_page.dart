import 'package:flutter/material.dart';
import 'package:reyo/constants/routes.dart';
import 'package:reyo/providers/state_provider.dart';

class ReviewListPage extends StatelessWidget {
  const ReviewListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = DataPointProvider.of(context);
    final values = provider.all;

    return Scaffold(
      appBar: AppBar(
        title: Text('All tests'),
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
