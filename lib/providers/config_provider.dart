import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TestConfig {
  bool enableUndo = false;
  bool enableEraser = false;
  bool enableImagePreview = false;
  bool enableSplitScreen = false;
}

class ReviewConfig {
  List<Color> colors = [];
  ColorMode colorMode = ColorMode.NONE;
  SliderMode sliderMode = SliderMode.NONE;
}

enum ColorMode {
  NONE,
  SPLIT,
  GRADIENT,
}

enum SliderMode {
  NONE,
  STROKES,
  // TIME,
}

class ConfigProvider extends ChangeNotifier {
  static ConfigProvider of(BuildContext context, [bool listen = true]) {
    return Provider.of(context, listen: listen);
  }

  final test = TestConfig();
  final review = ReviewConfig();

  updateTest({
    bool enableUndo = false,
    bool enableEraser = false,
    bool enableImagePreview = false,
    bool enableSplitScreen = false,
  }) {
    test.enableUndo = enableUndo;
    test.enableEraser = enableEraser;
    test.enableImagePreview = enableImagePreview;
    test.enableSplitScreen = enableSplitScreen;
    notifyListeners();
  }

  updateReview({
    List<Color> colors = const [],
    ColorMode colorMode = ColorMode.NONE,
    SliderMode sliderMode = SliderMode.NONE,
  }) {
    review.colors = colors;
    review.colorMode = colorMode;
    review.sliderMode = sliderMode;
    notifyListeners();
  }
}
