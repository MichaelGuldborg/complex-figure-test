import 'dart:ui';

import 'package:flutter/material.dart' hide Image;
import 'package:reyo/pages/paint/paint_history.dart';
import 'package:reyo/pages/paint/path_painter.dart';
import 'package:reyo/pages/paint/picture_details.dart';

class PaintView extends StatefulWidget {
  final PainterController controller;
  final GestureDragStartCallback? onPanStart;
  final GestureDragUpdateCallback? onPanUpdate;
  final GestureDragEndCallback? onPanEnd;

  PaintView({
    required this.controller,
    this.onPanStart,
    this.onPanUpdate,
    this.onPanEnd,
  }) : super(key: ValueKey<PainterController>(controller));

  @override
  _PaintViewState createState() => _PaintViewState();
}

class _PaintViewState extends State<PaintView> {
  @override
  void initState() {
    super.initState();
    widget.controller._widgetSize = () {
      return context.size ?? const Size(0, 0);
    };
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: GestureDetector(
        onPanStart: _onPanStart,
        onPanUpdate: _onPanUpdate,
        onPanEnd: _onPanEnd,
        child: ClipRect(
          child: CustomPaint(
            willChange: true,
            painter: PathPainter(widget.controller._pathHistory,
                repaint: widget.controller),
          ),
        ),
      ),
    );
  }

  void _onPanStart(DragStartDetails start) {
    if(widget.onPanStart != null) widget.onPanStart!(start);
    Offset pos = (context.findRenderObject() as RenderBox)
        .globalToLocal(start.globalPosition);
    widget.controller._pathHistory.add(pos);
    widget.controller._notifyListeners();
  }

  void _onPanUpdate(DragUpdateDetails update) {
    if(widget.onPanUpdate != null) widget.onPanUpdate!(update);
    Offset pos = (context.findRenderObject() as RenderBox)
        .globalToLocal(update.globalPosition);
    widget.controller._pathHistory.update(pos);
    widget.controller._notifyListeners();
  }

  void _onPanEnd(DragEndDetails end) {
    if(widget.onPanEnd != null) widget.onPanEnd!(end);
    widget.controller._pathHistory.end();
    widget.controller._notifyListeners();
  }
}

class PainterController extends ChangeNotifier {
  Color _drawColor = Color.fromARGB(255, 0, 0, 0);
  Color _backgroundColor = Color.fromARGB(255, 255, 255, 255);
  bool _eraseMode = false;

  double _thickness = 1.0;
  final PaintHistory _pathHistory;
  ValueGetter<Size>? _widgetSize;

  /// Creates a new instance for the use in a [Painter] widget.
  PainterController() : _pathHistory = PaintHistory();

  /// Returns the path history
  PaintHistory get pathHistory => _pathHistory;

  /// Returns true if the the [PainterController] is currently in erase mode,
  /// false otherwise.
  bool get eraseMode => _eraseMode;

  /// If set to true, erase mode is enabled, until this is called again with
  /// false to disable erase mode.
  set eraseMode(bool enabled) {
    _eraseMode = enabled;
    _updatePaint();
  }

  /// Retrieves the current draw color.
  Color get drawColor => _drawColor;

  /// Sets the draw color.
  set drawColor(Color color) {
    _drawColor = color;
    _updatePaint();
  }

  /// Retrieves the current background color.
  Color get backgroundColor => _backgroundColor;

  /// Updates the background color.
  set backgroundColor(Color color) {
    _backgroundColor = color;
    _updatePaint();
  }

  /// Returns the current thickness that is used for drawing.
  double get thickness => _thickness;

  /// Sets the draw thickness..
  set thickness(double t) {
    _thickness = t;
    _updatePaint();
  }

  void _updatePaint() {
    Paint paint = Paint();
    if (_eraseMode) {
      paint.blendMode = BlendMode.clear;
      paint.color = Color.fromARGB(0, 255, 0, 0);
    } else {
      paint.color = drawColor;
      paint.blendMode = BlendMode.srcOver;
    }
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = thickness;
    _pathHistory.currentPaint = paint;
    notifyListeners();
  }

  /// Undoes the last drawing action (but not a background color change).
  /// If the picture is already finished, this is a no-op and does nothing.
  void undo() {
    _pathHistory.undo();
    notifyListeners();
  }

  void _notifyListeners() {
    notifyListeners();
  }

  /// Deletes all drawing actions, but does not affect the background.
  /// If the picture is already finished, this is a no-op and does nothing.
  void clear() {
    _pathHistory.clear();
    notifyListeners();
  }

  PictureDetails createPicture() {
    if (_widgetSize == null) {
      throw StateError(
          'Called finish on a PainterController that was not connected to a widget yet!');
    }
    final size = _widgetSize!();
    if (size.isEmpty) {
      throw StateError('Tried to render a picture with an invalid size!');
    }

    PictureRecorder recorder = PictureRecorder();
    Canvas canvas = Canvas(recorder);
    _pathHistory.draw(canvas, size);
    final picture = recorder.endRecording();
    return PictureDetails(picture, size.width.floor(), size.height.floor());
  }
}
