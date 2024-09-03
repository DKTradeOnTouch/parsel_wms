import 'package:flutter/material.dart';

class ChangePasswordProvider extends ChangeNotifier {
  bool _isOldPassVisible = true;
  bool get isOldPassVisible => _isOldPassVisible;
  set isOldPassVisible(bool val) {
    _isOldPassVisible = val;
    notifyListeners();
  }

  bool _isNewPassVisible = true;
  bool get isNewPassVisible => _isNewPassVisible;
  set isNewPassVisible(bool val) {
    _isNewPassVisible = val;
    notifyListeners();
  }

  bool _isConfirmPassVisible = true;
  bool get isConfirmPassVisible => _isConfirmPassVisible;
  set isConfirmPassVisible(bool val) {
    _isConfirmPassVisible = val;
    notifyListeners();
  }
}
