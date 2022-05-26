import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:reyo/models/complex_figure_test.dart';
import 'package:reyo/providers/crud_notifier.dart';
import 'package:reyo/services/complex_figure_test_service.dart';

final service = ComplexFigureTestService();

class ComplexFigureTestProvider extends CrudNotifier<ComplexFigureTest> {
  ComplexFigureTestProvider() : super(service);

  static ComplexFigureTestProvider of(BuildContext context,
      {bool listen = true}) {
    return Provider.of(context, listen: listen);
  }

  Future<ComplexFigureTest?> createWithImage(ComplexFigureTest value) async {
    final response = await service.create(value);
    if (response == null) return response;

    final picture = value.imageFile;
    if (picture == null) return response;
    final image = await picture.toImage(value.width, value.height);
    final bytes = await image.toByteData(format: ImageByteFormat.png);
    final data = bytes?.buffer.asUint8List();
    updateImage(response.id, data); // skip await
    return response;
  }

  Future updateImage(String id, Uint8List? image) async {
    if (image == null) return;
    final url = await ComplexFigureTestService.uploadImage('$id.jpg', image);
    await update(id, {'image': url});
  }
}
