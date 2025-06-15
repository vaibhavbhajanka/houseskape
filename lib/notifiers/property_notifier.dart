import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:houseskape/model/property_model.dart';

class PropertyNotifier with ChangeNotifier {
  List<Property> _propertyList = [];
  late Property _currentProperty;
  List<Property> _allPropertyList = [];

  UnmodifiableListView<Property> get propertyList =>
      UnmodifiableListView(_propertyList);
  UnmodifiableListView<Property> get allPropertyList =>
      UnmodifiableListView(_allPropertyList);

  Property get currentProperty => _currentProperty;

  set propertyList(List<Property> propertyList) {
    _propertyList = propertyList;
    notifyListeners();
  }

  set allPropertyList(List<Property> allPropertyList) {
    _allPropertyList = allPropertyList;
    notifyListeners();
  }

  set currentProperty(Property property) {
    _currentProperty = property;
    notifyListeners();
  }

  void addProperty(Property property) {
    _propertyList.insert(0, property);
    notifyListeners();
  }

  void addAllProperty(Property property) {
    _allPropertyList.insert(0, property);
    notifyListeners();
  }

  void updateProperty(Property property) {
    final index = _propertyList.indexWhere((p) => p.id == property.id);
    if (index != -1) {
      _propertyList[index] = property;
      notifyListeners();
    }
  }
}
