import 'dart:math';

import 'package:flutter/material.dart';
import 'package:reyo/components/button.dart';
import 'package:reyo/constants/assets.dart';
import 'package:reyo/constants/theme_colors.dart';
import 'package:reyo/models/complex_figure_test.dart';
import 'package:reyo/models/mouse_event.dart';
import 'package:reyo/pages/home/path_painter.dart';
import 'package:reyo/pages/paint/paint_view.dart';
import 'package:reyo/providers/config_provider.dart';

class TestDrawPage extends StatefulWidget {
  final Function(ComplexFigureTest value) onNextPress;

  const TestDrawPage({
    Key? key,
    required this.onNextPress,
  }) : super(key: key);

  @override
  State<TestDrawPage> createState() => _TestDrawPageState();
}

class _TestDrawPageState extends State<TestDrawPage> {

  final _controller = PainterController();
  final List<MouseEvent> events = [];

  void addEvent(MouseEvent event) {
    setState(() => events.add(event));
  }

  @override
  Widget build(BuildContext context) {
    final settings = SettingsProvider.of(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            GestureDetector(
              onPanStart: (details) {
                addEvent(MouseEvent(
                  type: MouseEventType.PAN_START,
                  timestamp: DateTime.now(),
                  duration: details.sourceTimeStamp,
                  position: details.localPosition,
                  device: details.kind,
                ));
              },
              onPanUpdate: (details) {
                addEvent(MouseEvent(
                  type: MouseEventType.PAN_UPDATE,
                  timestamp: DateTime.now(),
                  duration: details.sourceTimeStamp,
                  position: details.localPosition,
                  delta: details.delta,
                ));
              },
              onPanEnd: (details) {
                addEvent(MouseEvent(
                  type: MouseEventType.PAN_END,
                  timestamp: DateTime.now(),
                  position: events.last.position,
                ));
              },
              child: CustomPaint(
                size: Size(
                  double.infinity,
                  double.infinity,
                ),
                painter: StrokePainter(
                  selectMode: false,
                  strokes: createStrokes(events),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Row(
                children: [
                  DrawActionButton(
                    visible: settings.undo,
                    margin: EdgeInsets.only(bottom: 16, right: 16),
                    backgroundColor: ThemeColors.borderGrey,
                    onTap: () {
                      events.add(MouseEvent(
                        type: MouseEventType.UNDO,
                        position: events.last.position,
                        timestamp: DateTime.now(),
                      ));
                    },
                    child: Icon(Icons.undo, color: Colors.black),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: DrawActionButton(
                margin: EdgeInsets.only(top: 16, right: 16),
                backgroundColor: ThemeColors.red,
                child: Icon(Icons.stop, color: Colors.white),
                onTap: () async {
                  // TODO: enable thumbnail
                  final details = _controller.createPicture();
                  widget.onNextPress(ComplexFigureTest(
                    id: '${Random().nextInt(100000)}',
                    start: events.first.timestamp,
                    end: events.last.timestamp,
                    width: details.width,
                    height: details.height,
                    events: events,
                    imageFile: details.picture,
                  ));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ComplexFigureImage extends StatelessWidget {
  const ComplexFigureImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(24),
      child: Image.asset(Assets.figure1),
    );
  }
}
