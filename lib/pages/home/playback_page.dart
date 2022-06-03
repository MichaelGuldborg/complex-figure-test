import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:reyo/components/info_box.dart';
import 'package:reyo/models/complex_figure_test.dart';
import 'package:reyo/pages/home/path_painter.dart';
import 'package:reyo/providers/complex_figure_test_provider.dart';

final colors = [
  Colors.red,
  Colors.yellow,
  Colors.green,
  Colors.blue,
];

class PlaybackPage extends StatefulWidget {
  const PlaybackPage({Key? key}) : super(key: key);

  @override
  State<PlaybackPage> createState() => _PlaybackPageState();
}

class _PlaybackPageState extends State<PlaybackPage> {
  double _maxTime = 0;
  double _time = 0;
  double speed = 1;
  bool enableColor = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final argument =
        ModalRoute.of(context)?.settings.arguments as ComplexFigureTest;
    _maxTime = argument.duration.toDouble();
    _time = argument.duration.toDouble();
  }

  Timer? _timer;

  _play() {
    // stop player
    _timer?.cancel();

    // reset player
    if (_maxTime - _time <= 1) {
      setState(() => _time = 0);
    }

    // start player
    _timer = Timer.periodic(Duration(milliseconds: 1), (t) {
      final nextTime = _time + (speed * 1000);
      if (nextTime < _maxTime) {
        setState(() => _time = nextTime);
      } else if (_time < _maxTime) {
        setState(() => _time = _maxTime);
      } else {
        setState(() => _timer?.cancel());
      }
    });
  }

  _pause() => setState(() => _timer?.cancel());

  get _isPlaying => _timer?.isActive ?? false;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final argument =
        ModalRoute.of(context)?.settings.arguments as ComplexFigureTest;
    final provider = ComplexFigureTestProvider.of(context);
    final value = provider.get(argument.id)!;

    return Scaffold(
      appBar: AppBar(
        title: Text('Test playback'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 8),
                        child: MaterialButton(
                          onPressed: () {},
                          child: InfoBox(
                            title: 'Accuracy',
                            subtitle: '${value.accuracy}',
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 8),
                        child: MaterialButton(
                          onPressed: () {},
                          child: InfoBox(
                            title: 'Strategy',
                            subtitle: '${value.strategy}',
                          ),
                        ),
                      ),
                      MaterialButton(
                        onPressed: () {},
                        child: InfoBox(
                          title: 'Notes',
                          subtitle: '${value.notes}',
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      InfoBox(
                        title: 'Date',
                        subtitle: formatDate(value.start),
                      ),
                      InfoBox(
                        title: 'Time',
                        subtitle: formatDateTime(value.start),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              child: CustomPaint(
                size: Size(
                  value.width.toDouble() * 0.5,
                  value.height.toDouble() * 0.5,
                ),
                painter: StrokePainter(
                  selectMode: false,
                  strokes: value.toStrokes(
                    scale: 0.5,
                    time: _time,
                    colors: enableColor ? colors : [],
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 24, right: 16),
              height: 8,
              decoration: BoxDecoration(
                gradient: enableColor ? LinearGradient(colors: colors) : null,
              ),
            ),
            Slider(
              min: 0,
              max: value.duration.toDouble(),
              value: _time,
              onChanged: (e) {
                _timer?.cancel();
                setState(() => _time = e);
              },
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 16),
                    child: IconButton(
                      icon: Icon(_isPlaying
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded),
                      iconSize: 40,
                      onPressed: _isPlaying ? _pause : _play,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 16),
                    child: MaterialButton(
                      onPressed: () => setState(() => speed = 1),
                      padding: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 8,
                      ),
                      child: Text(
                        'x${speed.floor()}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 16),
                    child: IconButton(
                      icon: Icon(Icons.remove),
                      iconSize: 40,
                      onPressed: () =>
                          setState(() => speed = max(1, speed - 1)),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 16),
                    child: IconButton(
                      icon: Icon(Icons.add),
                      iconSize: 40,
                      onPressed: () =>
                          setState(() => speed = min(99, speed + 1)),
                    ),
                  ),
                  Expanded(child: SizedBox.shrink()),
                  Container(
                    margin: EdgeInsets.only(right: 16),
                    child: IconButton(
                      icon: Icon(enableColor
                          ? Icons.color_lens
                          : Icons.color_lens_outlined),
                      iconSize: 40,
                      onPressed: () {
                        setState(() => enableColor = !enableColor);
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      '${formatTime(_time)} / ${formatTime(value.duration.toDouble())}',
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String formatTime(double t) {
    final minutes = (t / 60000000).floor().toString();
    final remainder = (t % 60000000);
    final seconds = (remainder / 1000000).ceil().toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  String formatDateTime(DateTime e) {
    final hours = '${e.hour}'.padLeft(2, '0');
    final minutes = '${e.minute}'.padLeft(2, '0');
    return '$hours:$minutes';
  }
}

String formatDate(DateTime? date) {
  if (date == null) return '';
  final year = date.year;
  final month = '${date.month}'.padLeft(2, '0');
  final day = '${date.day}'.padLeft(2, '0');
  return '$day/$month/$year';
}
