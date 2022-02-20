import 'package:flutter/material.dart';

class MyGenderProvider with ChangeNotifier {
  var _myValue = -1;

  dynamic get myValue => _myValue;

  set myValue(dynamic value) {
    _myValue = value;
    notifyListeners();
  }

  dynamic initiate(dynamic value) {
    _myValue = value;
  }
}
