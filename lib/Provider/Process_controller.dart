import 'package:flutter/cupertino.dart';

import '../models/InvoiceList_model.dart';


class ProcessController extends ChangeNotifier {
   int totalCount=0;
  List<ResultList>? salesOrders=[];
  List<ItemList> itemlist=[];
  //add resultlist

  void setsalesorder( List<ResultList>? setsalesOrder){
    salesOrders?.addAll(setsalesOrder!);
    notifyListeners();
  }
  get SalesOrdersList =>salesOrders;

void settotalCount( int totalcnt){
  totalCount=totalcnt;
  notifyListeners();
}
get gettotalCount =>totalCount;

//item sku

}
