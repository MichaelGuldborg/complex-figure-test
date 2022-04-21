import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:reyo/pages/auth/loading_overlay.dart';

class BaseAuthPage extends StatelessWidget {
  final Widget child;
  final Widget bottom;
  final bool loading;
  final VoidCallback? onTitleTap;

  const BaseAuthPage({
    Key? key,
    required this.child,
    required this.bottom,
    this.loading = false,
    this.onTitleTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      loading: loading,
      child: Scaffold(
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 100, bottom: 30),
              alignment: Alignment.bottomCenter,
              child: FlutterLogo(),
            ),
            Expanded(
              child: child,
            ),
            SafeArea(
              top: false,
              bottom: true,
              child: Container(
                margin: EdgeInsets.only(bottom: 20),
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: bottom,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
