import 'package:flutter/material.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/in_progress/model/get_sales_order_list_by_status_model.dart';

class ReturnOrdersProvider extends ChangeNotifier {
  List<ResultList> _searchReturnOrdersList = [];
  List<ResultList> get searchReturnOrdersList => _searchReturnOrdersList;
  set searchReturnOrdersList(List<ResultList> val) {
    _searchReturnOrdersList = val;
    notifyListeners();
  }

  List<ItemList> _returnedItemList = [];
  List<ItemList> get returnedItemList => _returnedItemList;
  set returnedItemList(List<ItemList> val) {
    _returnedItemList = val;
    notifyListeners();
  }

  void searchReturnOrders(
      {required String val, required List<ResultList> resultList}) {
    val = val.toLowerCase().trim();

    searchReturnOrdersList.clear();
    if (val.isNotEmpty) {
      for (int i = 0; i < resultList.length; i++) {
        List<ItemList> returnItemsList = [];
        if (resultList[i].returnItemsList.isNotEmpty) {
          print("resultList[i].id --> ${resultList[i].id}");
          for (int j = 0; j < resultList[i].returnItemsList.length; j++) {
            ItemList currentItem = resultList[i].returnItemsList[j];

            if (currentItem.productName.toLowerCase().contains(val) ||
                '${currentItem.id}'.contains(val) ||
                currentItem.selectedReturnReason.toLowerCase().contains(val)) {
              returnItemsList.add(currentItem);
            }
          }

          if (returnItemsList.isNotEmpty) {
            searchReturnOrdersList
                .add(resultList[i].copyWith(returnItemsList: returnItemsList));
          }
        }
      }
    }

    notifyListeners();
  }
}
