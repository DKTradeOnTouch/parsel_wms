import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/delivered/api/fetch_delivered_order_api.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/in_progress/model/get_sales_order_list_by_status_model.dart';
import 'package:parsel_flutter/utils/utils.dart';

class DeliveredItemProvider extends ChangeNotifier {
  List<ResultList> _deliveredItemsList = [];
  List<ResultList> get deliveredItemsList => _deliveredItemsList;
  set deliveredItemsList(List<ResultList> val) {
    _deliveredItemsList = val;
    notifyListeners();
  }

  List<ResultList> _modifiedInProgressItemsList = [];
  List<ResultList> get modifiedInProgressItemsList =>
      _modifiedInProgressItemsList;
  set modifiedInProgressItemsList(List<ResultList> val) {
    _modifiedInProgressItemsList = val;
    notifyListeners();
  }

  List<ResultList> _searchDeliveredItemsList = [];
  List<ResultList> get searchDeliveredItemsList => _searchDeliveredItemsList;
  set searchDeliveredItemsList(List<ResultList> val) {
    _searchDeliveredItemsList = val;
    notifyListeners();
  }

  Either<GetSalesOrderListByStatusModel, Exception>
      _getSalesOrderListByStatusResponse = Right(NoDataFoundException());
  Either<GetSalesOrderListByStatusModel, Exception>
      get getSalesOrderListByStatusResponse =>
          _getSalesOrderListByStatusResponse;
  set getSalesOrderListByStatusResponse(
      Either<GetSalesOrderListByStatusModel, Exception> val) {
    _getSalesOrderListByStatusResponse = val;
    notifyListeners();
  }

  Future<void> fetchDeliveredSku(BuildContext context) async {
    modifiedInProgressItemsList = [];
    Either<GetSalesOrderListByStatusModel, Exception> apiResponse =
        await fetchDeliveredSkuApi(context);
    getSalesOrderListByStatusResponse = apiResponse;
    if (getSalesOrderListByStatusResponse.isLeft) {
      if (getSalesOrderListByStatusResponse.left.status) {
        deliveredItemsList =
            getSalesOrderListByStatusResponse.left.body.data.resultList;
        List<ResultList> deliveredItemsListCopy = List.from(deliveredItemsList);

        for (int i = 0; i < deliveredItemsListCopy.length; i++) {
          await isListContainResultListElement(
              element: deliveredItemsListCopy[i]);
        }
      }
    } else {}
  }

  Future<bool> isListContainResultListElement(
      {required ResultList element}) async {
    bool isListContains = false;
    if (modifiedInProgressItemsList.isEmpty) {
      element.subResultList = [element];
      modifiedInProgressItemsList.add(element);
    } else {
      for (int i = 0; i < modifiedInProgressItemsList.length; i++) {
        if ((modifiedInProgressItemsList[i].storeName == element.storeName) &&
            (modifiedInProgressItemsList[i].deliveryAddress ==
                element.deliveryAddress)) {
          if (modifiedInProgressItemsList[i].subResultList.isEmpty) {
            print('element --> ${element.storeName}');
            modifiedInProgressItemsList[i].subResultList = [
              modifiedInProgressItemsList[i],
              element,
            ];
          } else {
            List<ResultList> list =
                modifiedInProgressItemsList[i].subResultList;
            list.add(element);
            modifiedInProgressItemsList[i].subResultList = List.from(list);
          }

          isListContains = true;
          break;
        }
      }

      if (!isListContains) {
        element.subResultList = [element];
        modifiedInProgressItemsList.add(element);

        notifyListeners();
      }
    }
    return isListContains;
  }

  void searchOrdersFunction({required String val}) {
    val = val.trim();

    if (val.isEmpty) {
      searchDeliveredItemsList = [];
      return;
    }

    searchDeliveredItemsList = [];

    List<String> keywords = val.toLowerCase().split(' ');

    for (var item in modifiedInProgressItemsList) {
      if (keywords.any((keyword) =>
          item.subResultList.any((e) => e.id.toString().contains(keyword)) ||
          item.subResultList
              .any((e) => e.deliveryAddress.toLowerCase().contains(keyword)) ||
          item.subResultList.any((e) => e.id.toString().contains(keyword)) ||
          item.subResultList
              .any((e) => e.storeName.toLowerCase().contains(keyword)))) {
        searchDeliveredItemsList.add(item);
      }
    }
  }
}
