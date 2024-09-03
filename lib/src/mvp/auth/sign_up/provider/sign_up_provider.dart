import 'package:flutter/material.dart';

class SignUpProvider extends ChangeNotifier {
  bool _isVisible = true;
  bool get isVisible => _isVisible;
  set isVisible(bool val) {
    _isVisible = val;
    notifyListeners();
  }

  bool _isAgreedToTermsAndPrivacy = true;
  bool get isAgreedToTermsAndPrivacy => _isAgreedToTermsAndPrivacy;
  set isAgreedToTermsAndPrivacy(bool val) {
    _isAgreedToTermsAndPrivacy = val;
    notifyListeners();
  }
}
