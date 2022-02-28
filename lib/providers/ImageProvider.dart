import 'package:flutter/material.dart';

class MyImageProvider extends ChangeNotifier{
  var _myImage;

  dynamic get myImage => _myImage;


  set myImage(dynamic value) {
    _myImage = value;
    notifyListeners();
  }


}