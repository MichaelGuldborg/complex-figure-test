import 'dart:async';

import 'package:flutter/material.dart';
import 'package:reyo/components/info_box.dart';
import 'package:reyo/models/complex_figure_test.dart';
import 'package:reyo/pages/home/playback_view.dart';
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

  _play([double millis = 1000]) {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(milliseconds: 1), (t) {
      final nextTime = _time + millis;
      if (nextTime < _maxTime) {
        setState(() => _time = nextTime);
      } else {
        _timer?.cancel();
      }
    });
  }

  _stop() {
    _timer?.cancel();
    setState(() => _time = 0);
  }

  _playFast() => _play(2000);

  _pause() => _timer?.cancel();

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
        title: Text('Review'),
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
                    children: const [
                      InfoBox(
                        title: 'Accuracy',
                        subtitle: '22/36',
                      ),
                      InfoBox(
                        title: 'Strategy',
                        subtitle: '22/36',
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
              child: Container(
                // color: Color(0xfff9f9f9),
                decoration: BoxDecoration(border: Border.all()),
                child: ComplexFigureTestView(
                  data: value,
                  time: _time,
                  scale: 0.5,
                  colors: enableColor ? colors : [],
                ),
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
                      icon: Icon(Icons.stop),
                      iconSize: 40,
                      onPressed: _stop,
                    ),
                  ),
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
                    child: IconButton(
                      icon: Icon(Icons.fast_forward_rounded),
                      iconSize: 40,
                      onPressed: _playFast,
                    ),
                  ),
                  Expanded(child: SizedBox.shrink()),
                  Visibility(
                    visible: enableColor,
                    child: Container(
                      margin: EdgeInsets.only(right: 16),
                      width: 80,
                      height: 16,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(colors: colors)),
                    ),
                  ),
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
