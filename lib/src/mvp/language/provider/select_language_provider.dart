import 'package:flutter/material.dart';

class SelectLanguageProvider extends ChangeNotifier {
  String _selectedLanguage = 'English';
  String get selectedLanguage => _selectedLanguage;
  set selectedLanguage(String val) {
    _selectedLanguage = val;
    notifyListeners();
  }
}
