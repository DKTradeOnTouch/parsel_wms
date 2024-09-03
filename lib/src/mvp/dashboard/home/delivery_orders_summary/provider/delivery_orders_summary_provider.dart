import 'package:flutter/material.dart';

class DeliveryOrdersSummaryProvider extends ChangeNotifier {
  bool _isDriverArrived = false;
  bool get isDriverArrived => _isDriverArrived;
  set isDriverArrived(bool val) {
    _isDriverArrived = val;
    notifyListeners();
  }

  int _currentPage = 0;
  int get currentPage => _currentPage;
  set currentPage(int val) {
    _currentPage = val;
    notifyListeners();
  }
}
