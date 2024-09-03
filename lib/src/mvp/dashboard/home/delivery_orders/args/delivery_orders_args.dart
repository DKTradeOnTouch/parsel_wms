import 'package:parsel_flutter/src/mvp/dashboard/home/in_progress/model/get_sales_order_list_by_status_model.dart';

class DeliveryOrdersArgs {
  ResultList resultList;
  int noOfItems;
  int timestamp;

  DeliveryOrdersArgs(
      {required this.resultList,
      required this.timestamp,
      required this.noOfItems});
}
