import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:reyo/providers/config_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settings = SettingsProvider.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'Settings',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: GridView.count(
        crossAxisCount: 3,
        childAspectRatio: (10 / 6),
        shrinkWrap: true,
        padding: EdgeInsets.all(24),
        crossAxisSpacing: 24,
        mainAxisSpacing: 24,
        children: [
          GridItemToggle(
            icon: FontAwesome.eraser,
            title: 'Eraser',
            subtitle:
                'Allow user to switch to an eraser during the test administration',
            value: settings.eraser,
            onChange: (v) => settings.update(eraser: v),
          ),
          GridItemToggle(
            icon: Icons.undo,
            title: 'Undo',
            subtitle: 'Allow user to undo the last stroke',
            value: settings.undo,
            onChange: (v) => settings.update(undo: v),
          ),
          // GridItemToggle(
          //   icon: Icons.color_lens,
          //   title: 'Colors',
          //   subtitle: 'Use the colors "red", "yellow", "green" to indicate the relative time of the stroke',
          //   value: settings.colors,
          //   onChange: (v) => settings.update(colors: v),
          // ),
        ],
      ),
    );
  }
}

class GridItemToggle extends StatelessWidget {
  const GridItemToggle({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChange,
  }) : super(key: key);

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final Function(bool b) onChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, boxShadow: const [
        BoxShadow(
          color: Color(0x19000000),
          offset: Offset(0, 2),
          blurRadius: 10,
          spreadRadius: 0,
        ),
      ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 16),
                  child: Icon(icon),
                ),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Switch(
                  value: value,
                  onChanged: onChange,
                ),
              ],
            ),
          ),
          Text(
            subtitle,
          )
        ],
      ),
    );
  }
}
