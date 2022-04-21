import 'dart:async';

import 'package:flutter/material.dart';
import 'package:reyo/pages/review/data_point_view.dart';
import 'package:reyo/pages/review/review_list_page.dart';
import 'package:reyo/providers/state_provider.dart';

final colors = [Colors.red, Colors.yellow, Colors.green];

class ReviewPage extends StatefulWidget {
  const ReviewPage({Key? key}) : super(key: key);

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  double _maxTime = 0;
  double _time = 0;
  bool enableColor = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final provider = DataPointProvider.of(context, listen: false);
    _maxTime = provider.current.duration.toDouble();
    _time = provider.current.duration.toDouble();
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

  _playSlow() => _play(500);

  _playFast() => _play(2000);

  _stop() => _timer?.cancel();

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = DataPointProvider.of(context);
    final data = provider.current;

    return Scaffold(
      appBar: AppBar(
        title: Text('Review'),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                InfoBox(
                  title: 'Start',
                  subtitle: formatDateTime(data.start),
                ),
                InfoBox(
                  title: 'End',
                  subtitle: formatDateTime(data.end),
                ),
                InfoBox(
                  title: 'Size',
                  subtitle: '${data.width} / ${data.height}',
                ),
                InfoBox(
                  title: 'Orientation',
                  subtitle: data.orientation ?? 'unknown',
                ),
              ],
            ),
          ),
          Center(
            child: DataPointView(
              data: data,
              time: _time,
              scale: 0.5,
              colors: enableColor ? colors : [],
            ),
          ),
          Slider(
            min: 0,
            max: data.duration.toDouble(),
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
                    icon: Icon(Icons.pause_rounded),
                    iconSize: 40,
                    onPressed: _stop,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 16),
                  child: IconButton(
                    icon: Icon(Icons.play_arrow_rounded),
                    iconSize: 40,
                    onPressed: _play,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 16),
                  child: IconButton(
                    icon: Icon(Icons.slow_motion_video_rounded),
                    iconSize: 40,
                    onPressed: _playSlow,
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
                    decoration:
                        BoxDecoration(gradient: LinearGradient(colors: colors)),
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
                    '${formatTime(_time)} / ${formatTime(data.duration.toDouble())}',
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
    );
  }

  String formatTime(double t) {
    final minutes = (t / 60000000).floor().toString();
    final remainder = (t % 60000000);
    final seconds = (remainder / 1000000).ceil().toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}

class InfoBox extends StatelessWidget {
  const InfoBox({
    Key? key,
    required this.title,
    required this.subtitle,
  }) : super(key: key);
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 16),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 4),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
