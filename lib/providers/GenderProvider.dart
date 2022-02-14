import 'package:flutter/material.dart';

class Gender with ChangeNotifier {
  bool _isMale = true;

  bool get isMale => this._isMale;

  set isMale(bool value) {
    this._isMale = value;
    notifyListeners();
  }

}