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

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final _controller = PainterController()
    ..backgroundColor = Colors.white
    ..drawColor = Colors.black
    ..thickness = 4.0;

  bool showImage = false;
  final List<MouseEvent> events = [];

  @override
  Widget build(BuildContext context) {
    final config = ConfigProvider.of(context).test;
    final provider = StateProvider.of(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Visibility(
              visible: !showImage,
              child: buildView(config),
              replacement: ComplexFigureImage(),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Row(
                children: [
                  DrawActionButton(
                    visible: config.enableUndo,
                    margin: EdgeInsets.only(bottom: 16, right: 16),
                    backgroundColor: ThemeColors.borderGrey,
                    onTap: () => _controller.undo(),
                    child: Icon(Icons.undo, color: Colors.black),
                  ),
                  DrawActionButton(
                    visible: config.enableEraser,
                    margin: EdgeInsets.only(bottom: 16, right: 16),
                    backgroundColor: ThemeColors.borderGrey,
                    onTap: () => setState(() {
                      final isEraseMode = _controller.eraseMode;
                      _controller.thickness = isEraseMode ? 4.0 : 24.0;
                      _controller.eraseMode = !isEraseMode;
                    }),
                    child: Icon(
                      _controller.eraseMode ? Icons.draw : FontAwesome.eraser,
                      color: Colors.black,
                    ),
                  ),
                  DrawActionButton(
                    visible: config.enableImagePreview,
                    margin: EdgeInsets.only(bottom: 16, right: 16),
                    backgroundColor: ThemeColors.green,
                    onTap: () => setState(() => showImage = !showImage),
                    child: Icon(
                      showImage ? Icons.draw : Icons.image,
                      color: Colors.white,
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
                onTap: () {
                  final details = _controller.createPicture();
                  provider.data = DataPoint(
                    width: details.width,
                    height: details.height,
                    events: events,
                    strokes: events
                        .where((e) => e.type == MouseEventType.PAN_END)
                        .length,
                  );
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildView(TestConfig config) {
    final paintView = PaintView(
      controller: _controller,
      onPanStart: (details) {
        events.add(MouseEvent(
          type: MouseEventType.PAN_START,
          duration: details.sourceTimeStamp,
          position: details.localPosition,
          device: details.kind,
        ));
      },
      onPanUpdate: (details) {
        events.add(MouseEvent(
          type: MouseEventType.PAN_UPDATE,
          duration: details.sourceTimeStamp,
          position: details.localPosition,
          delta: details.delta,
        ));
      },
      onPanEnd: (details) {
        events.add(MouseEvent(
          type: MouseEventType.PAN_END,
          position: events.last.position,
        ));
      },
    );

    if (config.enableSplitScreen) {
      return Column(
        children: [
          Text('Reference image'),
          Expanded(child: ComplexFigureImage()),
          Divider(color: Colors.black, thickness: 2),
          Text('Drawing space'),
          Expanded(child: paintView),
        ],
      );
    }
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
