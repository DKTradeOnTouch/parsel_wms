import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/in_progress/model/get_sales_order_list_by_status_model.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/payment/model/update_sales_order_item_list.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/return_orders/provider/return_orders_provider.dart';
import 'package:parsel_flutter/utils/exception/exception_utilities.dart';
import 'package:provider/provider.dart';

class OrderReviewProvider extends ChangeNotifier {
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

  String _selectedReturnReason = 'Select Reason for Return';
  String get selectedReturnReason => _selectedReturnReason;
  set selectedReturnReason(String val) {
    _selectedReturnReason = val;
    notifyListeners();
  }

  Either<ResultList, Exception> _resultList = Right(NoDataFoundException());
  Either<ResultList, Exception> get resultList => _resultList;
  set resultList(Either<ResultList, Exception> val) {
    _resultList = val;
    notifyListeners();
  }

  Future<void> updateResultList({required ResultList list}) async {
    resultList = Left(list);

    for (int i = 0; i < resultList.left.subResultList.length; i++) {
      for (int j = 0;
          j < resultList.left.subResultList[i].itemList.length;
          j++) {
        resultList.left.subResultList[i].itemList[j].itemNameController =
            TextEditingController(
                text: resultList.left.subResultList[i].itemList[j].productName);
        resultList.left.subResultList[i].itemList[j].returnItemQtyController =
            TextEditingController(
                text:
                    '${resultList.left.subResultList[i].itemList[j].returned}');
        resultList.left.subResultList[i].itemList[j].totalQtyController =
            TextEditingController(
                text: '${resultList.left.subResultList[i].itemList[j].qty}');
        resultList.left.subResultList[i].itemList[j].selectedReturnReason =
            resultList.left.subResultList[i].itemList[j].returnReason ??
                'Select Reason for Return';
      }
    }
  }

  Future<void> updateReturnReason(
      {bool updateAll = false,
      required String productCode,
      required String returnReason}) async {
    for (int i = 0;
        i < resultList.left.subResultList[currentPage].itemList.length;
        i++) {
      if (updateAll) {
        resultList.left.subResultList[currentPage].itemList[i]
            .selectedReturnReason = returnReason;
        resultList.left.subResultList[currentPage].itemList[i]
                .returnItemQtyController!.text =
            resultList.left.subResultList[currentPage].itemList[i]
                .totalQtyController!.text;
        notifyListeners();
      } else {
        if (resultList
                .left.subResultList[currentPage].itemList[i].productCode ==
            productCode) {
          resultList.left.subResultList[currentPage].itemList[i]
              .selectedReturnReason = returnReason;

          notifyListeners();
          break;
        }
      }
    }
  }

  Future<void> updateReturnedItemList(BuildContext context) async {
    ReturnOrdersProvider returnOrdersProvider =
        Provider.of(context, listen: false);
    returnOrdersProvider.returnedItemList = [];
    for (int i = 0; i < resultList.left.subResultList.length; i++) {
      resultList.left.subResultList[i].returnItemsList = [];
      for (int j = 0;
          j < resultList.left.subResultList[i].itemList.length;
          j++) {
        if (int.parse(resultList.left.subResultList[i].itemList[j]
                .returnItemQtyController!.text) !=
            0) {
          resultList.left.subResultList[i].returnItemsList
              .add(resultList.left.subResultList[i].itemList[j]);
          returnOrdersProvider.returnedItemList
              .add(resultList.left.subResultList[i].itemList[j]);
        }
      }
    }
  }

  List<UpdateSalesOrderItemResponse> _salesOrderItemList = [];
  List<UpdateSalesOrderItemResponse> get salesOrderItemList =>
      _salesOrderItemList;
  set salesOrderItemList(List<UpdateSalesOrderItemResponse> val) {
    _salesOrderItemList = val;
    notifyListeners();
  }

  Future<void> updateSalesOrderItemList() async {
    salesOrderItemList = [];
    for (int i = 0;
        i < resultList.left.subResultList[currentPage].itemList.length;
        i++) {
      UpdateSalesOrderItemResponse updateSalesOrderItemResponse =
          UpdateSalesOrderItemResponse(
              delivered:
                  (resultList.left.subResultList[currentPage].itemList[i].qty -
                      int.parse(resultList.left.subResultList[currentPage]
                          .itemList[i].returnItemQtyController!.text)),
              productCode: resultList
                  .left.subResultList[currentPage].itemList[i].productCode,
              qty: resultList.left.subResultList[currentPage].itemList[i].qty,
              returnReason: resultList.left.subResultList[currentPage]
                  .itemList[i].selectedReturnReason,
              returned: int.parse(resultList.left.subResultList[currentPage]
                  .itemList[i].returnItemQtyController!.text));
      salesOrderItemList.add(updateSalesOrderItemResponse);
    }
  }
}
