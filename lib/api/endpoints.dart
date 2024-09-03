// ignore_for_file: constant_identifier_names

const flavor = String.fromEnvironment('flavor', defaultValue: "prod");

const isProd = flavor == 'prod';
//
//
//const isProd = flavor == 'staging';

class EndPoints {
  //STAGING

  static const String BASE_URL =
      'http://${isProd ? "web" : "backend"}.parsel.in:9090/';

  static const String BASE2_URL =
      'http://${isProd ? "web" : "backend"}.parsel.in:9091/';

  //////////////////////////////////////////////////////////////////////////
  ///Python

  static const String liveServer = 'http://139.5.189.63:8000/';

  //////////////////////////////////////////////////////////////////////////

  static const String FORGOTPASSWORD = BASE_URL + 'api/auth/forget/password';

  static const String LOGIN = BASE_URL + 'api/auth/signin';

//COUNT API
  static const String countAPINEW = /*BASE2_URL*/
      liveServer + 'sales-order/getCount/';

  static const String GetUserById = BASE_URL + 'api/user/getUserById/';
  static const String PURCHASE_ORDER = BASE2_URL +
      'purchaseorder/getPurchaseOrders?pageNo=0&pageSize=20&status=SORTING';
  static const String INWARD_ORDER_LIST =
      BASE2_URL + 'purchaseorder/getPurchaseOrders';
  static const String storage_ORDER_LIST =
      BASE2_URL + 'purchaseorder/getPurchaseOrders';
  static const String SKU_CLASSIFICATION =
      BASE2_URL + 'purchaseorder/executeSkuClassification';
  static const String PERFORM_ACTION =
      BASE2_URL + 'purchaseorder/performAction';

  static const String executeStorage =
      BASE2_URL + 'purchaseorder/executeStorage';

  static const String performActionOnSalesOrder =
      BASE2_URL + 'sales-order/performActionOnSalesOrder';

  static const String routeCordinate = BASE2_URL + 'routeCordinate/create';

//BIN MASTER
  static const String binMaster =
      BASE2_URL + '/binMaster/getRecords?pageNo=0&pageSize=10';

  static const String LocationDropDown =
      BASE2_URL + 'binMaster/getRecords?pageNo=0&pageSize=10';
//sales-order/updateGroupIdDetails
  static const String updateGroupIdDetails =
      liveServer + 'sales-order/updateGroupIdDetails';
//ticket 111
  //Fetch List of Sales Orders in Pending
  static const String getSalesOrderByCreationDateAndRoute =
      BASE2_URL + 'sales-order/getSalesOrderByCreationDateAndRoute';
  //ticket 112
  //Fetch list of Sales Orders assigned to a Delivery Driver
  //ticket 113
//Count of Sales Order in Pending Status

  static const String getSalesOrderListByStatus =
      liveServer + 'sales-order/getSalesOrderListByStatus/';

// Get Route Optimized List..
  static const String getRouteOptimisedSalesOrder =
      BASE2_URL + 'sales-order/optimisedSalesOrder';

  static const String getSalesOrderSKUList =
      liveServer + 'sales-order/getGroupByUserId';

  static const String getGroupByUserId =
      liveServer + 'sales-order/getGroupByUserId';

  static const String PerformAction = BASE2_URL + 'purchaseorder/performAction';
  //ticket getOrderedQuantityToDeliveryDriver
  static const String getOrderedQuantityToDeliveryDriver =
      BASE2_URL + 'sales-order/getOrderedQuantityToDeliveryDriver';

  //PICKING LIST
  static const String getPickingList =
      BASE2_URL + 'sales-order/getSalesOrderListByStatus/';

  //ticket 127 pickedUpQuantity
  static const String pickedUpQuantity =
      BASE2_URL + 'sales-order/pickedUpQuantity';

//ticket 128 confirmGroupOrder
  static const String confirmGroupOrder =
      BASE2_URL + 'sales-order/confirmGroupOrder';
//ticket 129
//sales-order/saveOpeningBalanceOrder
  static const String saveOpeningBalanceOrder =
      BASE2_URL + 'sales-order/saveOpeningBalanceOrder';
  //130
  // /delivery/summary?driverid=<driverid>&orderId=<orderId>
  static const String dispatchsummary = BASE2_URL + 'sales-order/summary';
//ticket 136 payments
  static const String payments = BASE2_URL + 'sales-order';
//ticket 134
//sales-order/saveOpeningBalanceOrder
  static const String updateDeliverySummaryStatus =
      BASE2_URL + 'sales-order/updateDeliverySummaryStatus';
//134
//getDeliverySummary
  static const String getDeliverySummary =
      BASE2_URL + 'sales-order/getDeliverySummary';

  //CREATE PAYMENT
  static const String createPayment = liveServer + 'sales-order/';

//ReturnSOData
  static const String returnSoData = BASE2_URL + 'sales-order/orderSummary';
  static const String locationcreate = BASE2_URL + 'location/create';
  static const String uploadDocs = liveServer + 'sales-order/uploadDocs';
  //getsales order bu id
  static const String GetSalesorderbyID =
      BASE2_URL + 'sales-order/getSalesOrderById';

  static const String startTrip = liveServer + 'sales-order/updateSalesOrder';
  static const String updateSalesorderbyID =
      liveServer + 'sales-order/updateSalesOrder';
  static const String clientConfiguration =
      liveServer + 'client/configuration/0/';
}
