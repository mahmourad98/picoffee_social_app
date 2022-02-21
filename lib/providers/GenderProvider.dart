import 'package:flutter/material.dart';

class MyGenderProvider with ChangeNotifier {
  int? _myValue = -1;

  get myValue => _myValue;

  set myValue(value) {
    _myValue = value;
    notifyListeners();
  }

  dynamic initiate(dynamic value) {
    _myValue = value;
  }
}
