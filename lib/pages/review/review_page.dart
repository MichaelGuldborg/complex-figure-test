import 'package:flutter/material.dart';
import 'package:reyo/pages/review/data_point_view.dart';
import 'package:reyo/providers/config_provider.dart';
import 'package:reyo/providers/state_provider.dart';

class ReviewPage extends StatefulWidget {
  ReviewPage({Key? key}) : super(key: key);

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  int stroke = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final provider = StateProvider.of(context);
    stroke = provider.data.strokes;
  }

  @override
  Widget build(BuildContext context) {
    final config = ConfigProvider.of(context).review;
    final provider = StateProvider.of(context);
    final data = provider.data;

    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          DataPointView(
            data: data,
            stroke: stroke,
            colorMode: config.colorMode,
            colors: config.colors,
          ),
          Visibility(
            visible: config.sliderMode == SliderMode.STROKES,
            child: Slider(
              min: 0,
              max: data.strokes.toDouble(),
              value: stroke.toDouble(),
              onChanged: (i) => setState(() {
                stroke = i.floor();
              }),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _info('Strokes: ${data.strokes}'),
                _info('Start: ${data.start?.toString()}'),
                _info('End: ${data.start?.toString()}'),
              ],
            ),
          )
        ],
      ),
    );
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
