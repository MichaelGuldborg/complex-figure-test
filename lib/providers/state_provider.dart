import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:reyo/models/data_point.dart';
import 'package:reyo/providers/crud_notifier.dart';
import 'package:reyo/services/data_point_service.dart';

class DataPointProvider extends CrudNotifier<DataPoint> {
  DataPointProvider() : super(DataPointService());

  static DataPointProvider of(BuildContext context, {bool listen = true}) {
    return Provider.of(context, listen: listen);
  }

  int currentIndex = 0;

  DataPoint get current {
    if (all.length <= currentIndex) {
      return DataPoint(id: '', start: DateTime.now(), end: DateTime.now());
    }
    return all[currentIndex];
  }

  Future createWithImage(Picture picture, DataPoint value) async {
    final response = await service.create(value);
    if (response == null) return;

    final image = await picture.toImage(value.width, value.height);
    final bytes = await image.toByteData(format: ImageByteFormat.png);
    final data = bytes?.buffer.asUint8List();
    await updateImage(response.id, data);
  }

  Future updateImage(String id, Uint8List? image) async {
    if(image == null) return;
    final url = await DataPointService.uploadImage('$id.jpg', image);
    await update(id, {'image': url});
  }
}
