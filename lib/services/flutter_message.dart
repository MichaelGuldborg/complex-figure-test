import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:reyo/constants/theme_colors.dart';

class FlutterMessage {
  static final _instance = FlutterMessage();

  static FlutterMessage get instance => _instance;

  final Duration durationMessage = Duration(seconds: 4);

  void Function()? cancelLoading;

  void setLoading(bool loading) {
    if (loading) {
      if(cancelLoading != null) return;
      cancelLoading = BotToast.showCustomLoading(toastBuilder: (_) {
        return Center(child: CircularProgressIndicator());
      });
    } else {
      if (cancelLoading != null) cancelLoading!();
      cancelLoading = null;
    }
  }

  Future<T> showLoading<T>(Future<T> future) async {
    final cancelLoading = BotToast.showCustomLoading(toastBuilder: (_) {
      return Center(child: CircularProgressIndicator());
    });
    final result = await future;
    cancelLoading();
    return result;
  }

  void showSuccess(String? text) {
    if (text == null || text.isEmpty) return;
    BotToast.showCustomNotification(
      duration: durationMessage,
      toastBuilder: (cancel) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          width: double.maxFinite,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: ThemeColors.lightGreen,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: ThemeColors.darkGreen,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        );
      },
    );
  }

  void showError(String? text) {
    if (text == null || text.isEmpty) return;
    BotToast.showCustomNotification(
      duration: durationMessage,
      toastBuilder: (cancel) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          width: double.maxFinite,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: ThemeColors.lightRed,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: ThemeColors.darkRed,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        );
      },
    );
  }

  void showMessage(String? text) {
    if (text == null || text.isEmpty) return;
    BotToast.showCustomNotification(
      duration: durationMessage,
      toastBuilder: (cancel) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          width: double.maxFinite,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: ThemeColors.lightBlue,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: ThemeColors.darkBlue,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        );
      },
    );
  }
}

void showSuccess(String? text) {
  return FlutterMessage.instance.showSuccess(text);
}

void showError(String? text) {
  return FlutterMessage.instance.showError(text);
}

void showMessage(String? text) {
  return FlutterMessage.instance.showMessage(text);
}
