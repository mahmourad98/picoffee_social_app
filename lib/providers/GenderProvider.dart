import 'package:flutter/material.dart';

class Gender with ChangeNotifier {
  int _isMale = -1;

  int get isMale => this._isMale;

  set isMale(int value) {
    this._isMale = value;
    notifyListeners();
  }
}
