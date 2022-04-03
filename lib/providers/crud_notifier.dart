import 'package:flutter/cupertino.dart';
import 'package:reyo/models/identifyable.dart';
import 'package:reyo/services/crud_service.dart';

abstract class ICrudNotifier<T> {
  Future refreshAll();

  Future refresh(String? id);

  Future create(T value);

  Future update(String? id, Map<String, dynamic> value);

  Future delete(String? id);

  List<T> get all;

  T? get(String? id);
}

class CrudNotifier<T extends Identifiable> extends ChangeNotifier
    implements ICrudNotifier<T> {
  final CrudService<T> service;

  CrudNotifier(this.service);

  final List<T> _values = [];

  @override
  List<T> get all {
    if (_values.isEmpty) refreshAll();
    return _values;
  }

  @override
  T? get(String? id) {
    if (id == null) return null;
    final index = _values.indexWhere((e) => e.id == id);
    if (index == -1) return null;
    return _values[index];
  }

  @override
  Future refresh(String? id) async {
    final response = await service.read(id);
    if (response == null) return;
    final index = _values.indexWhere((e) => e.id == id);
    index == -1 ? _values.add(response) : _values[index] = response;
    notifyListeners();
  }

  @override
  Future refreshAll() async {
    final response = await service.readAll();
    if (response.isEmpty) return;
    _values.clear();
    _values.addAll(response);
    notifyListeners();
  }

  @override
  Future create(T value) async {
    final response = await service.create(value);
    if (response == null) return;
    _values.insert(0, value);
    notifyListeners();
    return value;
  }

  @override
  Future delete(String? id) async {
    final response = await service.delete(id);
    if (response == null) return;
    _values.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  @override
  Future update(String? id, Map<String, dynamic> value) async {
    final response = await service.update(id, value);
    if (response == null) return;
    final index = _values.indexWhere((e) => e.id == id);
    index == -1 ? _values.insert(0, response) : _values[index] = response;
    notifyListeners();
    return value;
  }
}
