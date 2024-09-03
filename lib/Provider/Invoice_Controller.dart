import 'dart:io';

import 'package:flutter/cupertino.dart';

import '../models/InvoiceList_model.dart';

class InvoiceController extends ChangeNotifier {
  List<ResultList>? salesOrders = [];
  List<ResultList>? inProgressOrders = [];
  File? file = File("");
  int? noOfBox = 9;
  double? temp = 200;
  //add resultList
  num pendingTotalCount = 0;
  num iNTotalCount = 0;
  num deTotalCount = 0;
  void setSalesOrder(List<ResultList>? setSalesOrder) {
    salesOrders?.addAll(setSalesOrder!);
    notifyListeners();
  }

  get salesOrdersList => salesOrders;

  void setTotalCount(int totalCnt) {
    pendingTotalCount = totalCnt;
    notifyListeners();
  }

  void setINPTotalCount(int totalCnt) {
    iNTotalCount = totalCnt;
    notifyListeners();
  }

  void setDEPtotalCount(int totalNt) {
    deTotalCount = totalNt;
    notifyListeners();
  }

  void setFile(File iFile) {
    file = iFile;
    notifyListeners();
  }

  void setNoOfBox(int nb) {
    noOfBox = nb;
    notifyListeners();
  }

  void setTemp(double tempSet) {
    temp = tempSet;
    notifyListeners();
  }

  get fileData => file;
  get getNOfBox => noOfBox;
  get getTemp => temp;
  get getTotalCount => pendingTotalCount;
  get getINPtotalCount => iNTotalCount;
  get getDEPtotalCount => deTotalCount;
//item sku
}
