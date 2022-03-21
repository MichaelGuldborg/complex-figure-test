

import 'package:flutter/material.dart';
import 'package:painter/painter.dart';
import 'package:reyo/constants/assets.dart';
import 'package:reyo/constants/routes.dart';
import 'package:reyo/constants/theme_colors.dart';
import 'package:reyo/models/gesture.dart';

class DrawPage extends StatefulWidget {
  const DrawPage({Key? key}) : super(key: key);

  static PainterController _newController() {
    final controller = PainterController();
    controller.backgroundColor = Colors.white;
    controller.thickness = 4.0;
    return controller;
  }

  @override
  State<DrawPage> createState() => _DrawPageState();
}

class _DrawPageState extends State<DrawPage> {
  final _controller = DrawPage._newController();
  final List<Gesture> gestures = [];

  bool showImage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Visibility(
              visible: !showImage,
              child: Painter(
                _controller,
                onPanStart: (details) {
                  gestures.add(Gesture(
                    type: GestureType.START,
                    duration: details.sourceTimeStamp,
                    position: details.localPosition,
                    device: details.kind,
                  ));
                },
                onPanUpdate: (details) {
                  gestures.add(Gesture(
                    type: GestureType.MOVE,
                    duration: details.sourceTimeStamp,
                    position: details.localPosition,
                    delta: details.delta,
                  ));
                },
                onPanEnd: (details) {
                  gestures.add(Gesture(
                    type: GestureType.END,
                    position: gestures.last.position,
                  ));
                },
              ),
              replacement: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(24),
                child: Image.asset(Assets.figure1),
              ),
            ),
            Positioned(
              bottom: 16,
              right: 16 + 56 + 16,
              child: Button(
                onTap: () => _controller.undo(),
                backgroundColor: ThemeColors.borderGrey,
                child: Icon(Icons.undo, color: Colors.black),
              ),
            ),
            Positioned(
              bottom: 16,
              right: 16,
              child: Button(
                backgroundColor: ThemeColors.green,
                onTap: () => setState(() => showImage = !showImage),
                child: Icon(showImage ? Icons.edit : Icons.image, color: Colors.white),
              ),
            ),
            Positioned(
              top: 16,
              right: 16,
              child: Button(
                backgroundColor: ThemeColors.red,
                child: Icon(Icons.stop, color: Colors.white),
                onTap: () {
                  Navigator.pushNamed(context, Routes.result, arguments: gestures);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Button extends StatelessWidget {
  const Button({
    Key? key,
    required this.onTap,
    required this.backgroundColor,
    required this.child,
  }) : super(key: key);

  final VoidCallback onTap;
  final Color backgroundColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(100),
          boxShadow: const [
            BoxShadow(
              color: Color(0x19000000),
              offset: Offset(0, 2),
              blurRadius: 10,
              spreadRadius: 0,
            )
          ],
        ),
        child: child,
      ),
    );
  }
}
