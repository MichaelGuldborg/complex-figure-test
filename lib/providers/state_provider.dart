import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:reyo/models/data_point.dart';
import 'package:reyo/pages/paint/paint_history.dart';
import 'package:reyo/pages/paint/picture_details.dart';



class StateProvider extends ChangeNotifier {
  static StateProvider of(BuildContext context, [bool listen = true]) {
    return Provider.of(context, listen: listen);
  }

  DataPoint data = DataPoint(width: 0, height: 0);

}
