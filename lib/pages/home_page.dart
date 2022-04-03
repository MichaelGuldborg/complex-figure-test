import 'package:flutter/material.dart';
import 'package:reyo/constants/routes.dart';
import 'package:reyo/providers/config_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final config = ConfigProvider.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'Complex Figure Test',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 32),
        children: [
          HomeListHeader(title: 'Administration'),
          HomeListTile(
            title: 'Split screen',
            onTap: () {
              config.updateTest(enableSplitScreen: true);
              Navigator.pushNamed(context, Routes.test);
            },
          ),
          HomeListTile(
            title: 'Image preview',
            onTap: () {
              config.updateTest(enableImagePreview: true);
              Navigator.pushNamed(context, Routes.test);
            },
          ),
          HomeListTile(
            title: 'Allow eraser',
            onTap: () {
              config.updateTest(enableEraser: true);
              Navigator.pushNamed(context, Routes.test);
            },
          ),
          HomeListTile(
            title: 'Undo button',
            onTap: () {
              config.updateTest(enableUndo: true);
              Navigator.pushNamed(context, Routes.test);
            },
          ),
          // HomeListTile(
          //   title: 'UI flow',
          //   onTap: () {},
          // ),
          HomeListHeader(title: 'Evaluation'),
          HomeListTile(
              title: 'Video playback',
              onTap: () {
                // config.updateReview(sliderMode: SliderMode.TIME);
                config.updateReview(sliderMode: SliderMode.STROKES);
                Navigator.pushNamed(context, Routes.review);
              }),
          HomeListTile(
            title: 'Color splits',
            onTap: () {
              config.updateReview(
                colorMode: ColorMode.SPLIT,
                colors: [Colors.red, Colors.blue],
              );
              Navigator.pushNamed(context, Routes.review);
            },
          ),
          HomeListTile(
            title: 'Color gradient',
            onTap: () {
              config.updateReview(
                colorMode: ColorMode.GRADIENT,
                colors: rainbow,
              );
              Navigator.pushNamed(context, Routes.review);
            },
          ),
        ],
      ),
    );
  }
}

final rainbow = [
  Colors.red,
  Colors.orange,
  Colors.yellow,
  Colors.green,
  Colors.blue,
  Colors.purple,
];

class HomeListHeader extends StatelessWidget {
  final String title;

  const HomeListHeader({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16, bottom: 16),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class HomeListTile extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;

  const HomeListTile({
    Key? key,
    required this.title,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
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
          title: Text(title),
        ),
      ),
    );
  }
}
