import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsProvider extends ChangeNotifier {
  static SettingsProvider of(BuildContext context, [bool listen = true]) {
    return Provider.of(context, listen: listen);
  }

  bool undo = true;
  bool eraser = false;
  bool colors = false;

  update({
    bool? undo,
    bool? eraser,
    bool? colors,
  }) {
    this.undo = undo ?? this.undo;
    this.eraser = eraser ?? this.eraser;
    this.colors = colors ?? this.colors;
    notifyListeners();
  }
}
