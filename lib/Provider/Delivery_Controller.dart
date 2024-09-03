import 'package:flutter/cupertino.dart';
import 'package:parsel_flutter/resource/app_logs.dart';

import '../models/uploadsalesorder_model.dart';

class DeliveryController extends ChangeNotifier {
  int totalDelivered = 0;
  int totalReturned = 0;
  List<ItemList> dpItemList = [];

  void setAllDeliveryItem(List<ItemList>? setUploadItem) {
    appLogs("setUploadItem ---> $setUploadItem");
    dpItemList.clear();
    dpItemList.addAll(setUploadItem!);
    notifyListeners();
  }

  get uploadList => dpItemList;

//item sku
  void updateParticular(ItemList pItemList, int index) {
    if (dpItemList.asMap().containsKey(index)) {
      appLogs('deliveredQty_here-->' + pItemList.delivered.toString());
      dpItemList[index] = pItemList;
      appLogs('deliveredQty_dp-->' + dpItemList[index].delivered.toString());

      notifyListeners();
    }
  }

  void addTotalReturned() {
    totalReturned = 0;
    for (var e in dpItemList) {
      totalReturned += e.returned!;
    }
    notifyListeners();
  }

  void addTotalDeliverd() {
    totalDelivered = 0;
    for (var e in dpItemList) {
      totalDelivered += e.delivered!;
    }
    notifyListeners();
  }

  List<ItemList> get uploadParticularListItem => dpItemList;

  get totalDeliverd => totalDelivered;
  get totalRetured => totalReturned;
}
