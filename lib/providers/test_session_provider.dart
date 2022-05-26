import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:reyo/models/test_session.dart';
import 'package:reyo/providers/crud_notifier.dart';
import 'package:reyo/services/test_session_service.dart';

final service = TestSessionService();

class TestSessionProvider extends CrudNotifier<TestSession> {
  TestSessionProvider() : super(service);

  static TestSessionProvider of(BuildContext context, {bool listen = true}) {
    return Provider.of(context, listen: listen);
  }

}
