import 'package:flutter/material.dart';

class FontSizeController with ChangeNotifier {
  double _fontSize;

  FontSizeController(this._fontSize);

  double get fontSize => _fontSize;

  void setFontSize(double newSize) {
    _fontSize = newSize;
    notifyListeners();
  }
}
