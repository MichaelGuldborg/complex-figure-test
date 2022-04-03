import 'package:flutter/material.dart';
import 'package:reyo/pages/review/data_point_view.dart';
import 'package:reyo/pages/review/review_list_page.dart';
import 'package:reyo/providers/config_provider.dart';
import 'package:reyo/providers/state_provider.dart';

final colors = [Colors.red, Colors.yellow, Colors.green];

class ReviewPage extends StatefulWidget {
  const ReviewPage({Key? key}) : super(key: key);

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  double _time = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final provider = DataPointProvider.of(context, listen: false);
    _time = provider.current.duration.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final settings = SettingsProvider.of(context);
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
              ],
            ),
          ),
          DataPointView(
            data: data,
            time: _time,
            colors: settings.colors ? colors : [],
          ),
          Slider(
            min: 0,
            max: data.duration.toDouble(),
            value: _time,
            onChanged: (e) => setState(() => _time = e),
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
    );
  }

  String formatTime(double t) {
    final minutes = (t / 60000000).floor().toString();
    final remainder = (t % 60000000);
    final seconds = (remainder / 1000000).ceil().toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Widget _info(String text) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
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
