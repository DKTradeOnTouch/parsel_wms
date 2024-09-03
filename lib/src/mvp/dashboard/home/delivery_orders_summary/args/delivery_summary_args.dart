import 'package:parsel_flutter/src/mvp/dashboard/home/in_progress/model/get_sales_order_list_by_status_model.dart';
import 'package:parsel_flutter/utils/utils.dart';

class DeliverySummaryArgs {
  ResultList resultList;
  int noOfItems;
  int timestamp;
  NavigateFrom navigateFrom;

  DeliverySummaryArgs(
      {required this.resultList,
      required this.timestamp,
      required this.noOfItems,
      required this.navigateFrom});
}
