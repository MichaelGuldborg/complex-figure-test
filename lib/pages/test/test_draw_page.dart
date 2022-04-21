import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:reyo/components/button.dart';
import 'package:reyo/constants/assets.dart';
import 'package:reyo/constants/theme_colors.dart';
import 'package:reyo/models/data_point.dart';
import 'package:reyo/models/mouse_event.dart';
import 'package:reyo/pages/paint/paint_view.dart';
import 'package:reyo/providers/config_provider.dart';
import 'package:reyo/providers/state_provider.dart';

class TestDrawPage extends StatefulWidget {
  final VoidCallback? onNextPress;

  const TestDrawPage({
    Key? key,
    this.onNextPress,
  }) : super(key: key);

  @override
  State<TestDrawPage> createState() => _TestDrawPageState();
}

class _TestDrawPageState extends State<TestDrawPage> {
  final _controller = PainterController()
    ..backgroundColor = Colors.white
    ..drawColor = Colors.black
    ..thickness = 4.0;

  final List<MouseEvent> events = [];

  @override
  Widget build(BuildContext context) {
    final settings = SettingsProvider.of(context);
    final provider = DataPointProvider.of(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            buildView(settings),
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
                      // TODO TRACK UNDO
                      _controller.undo();
                    },
                    child: Icon(Icons.undo, color: Colors.black),
                  ),
                  DrawActionButton(
                    visible: settings.eraser,
                    margin: EdgeInsets.only(bottom: 16, right: 16),
                    backgroundColor: ThemeColors.borderGrey,
                    onTap: () {
                      // TODO TRACK ERASER
                      setState(() {
                        final isEraseMode = _controller.eraseMode;
                        _controller.thickness = isEraseMode ? 4.0 : 24.0;
                        _controller.eraseMode = !isEraseMode;
                      });
                    },
                    child: Icon(
                      _controller.eraseMode ? Icons.draw : FontAwesome.eraser,
                      color: Colors.black,
                    ),
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
                  final details = _controller.createPicture();
                  provider.createWithImage(
                    details.picture,
                    DataPoint(
                      id: '${provider.all.length}',
                      start: events.first.timestamp,
                      end: events.last.timestamp,
                      width: details.width,
                      height: details.height,
                      events: events,
                    ),
                  );

                  if (widget.onNextPress != null) {
                    widget.onNextPress!();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildView(SettingsProvider config) {
    final paintView = PaintView(
      controller: _controller,
      onPanStart: (details) {
        events.add(MouseEvent(
          type: MouseEventType.PAN_START,
          timestamp: DateTime.now(),
          duration: details.sourceTimeStamp,
          position: details.localPosition,
          device: details.kind,
        ));
      },
      onPanUpdate: (details) {
        events.add(MouseEvent(
          type: MouseEventType.PAN_UPDATE,
          timestamp: DateTime.now(),
          duration: details.sourceTimeStamp,
          position: details.localPosition,
          delta: details.delta,
        ));
      },
      onPanEnd: (details) {
        events.add(MouseEvent(
          type: MouseEventType.PAN_END,
          timestamp: DateTime.now(),
          position: events.last.position,
        ));
      },
    );

    return paintView;
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
