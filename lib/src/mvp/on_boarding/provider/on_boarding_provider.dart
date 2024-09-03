import 'package:flutter/material.dart';

///On boarding provider
class OnBoardingProvider extends ChangeNotifier {
  int _currentPage = 0;

  ///Getter setter for change current page
  int get currentPage => _currentPage;
  set currentPage(int page) {
    _currentPage = page;
    notifyListeners();
  }
}
