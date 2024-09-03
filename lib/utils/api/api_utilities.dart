part of parsel_exchange_apis;

class APIUtilities {
  static const flavor = String.fromEnvironment('flavor', defaultValue: "prod");

  static const isProd = flavor == 'prod';

  static const String _baseUrl9090 =
      'https://web.parsel.in/security/'; //New 9090

  static const String liveServer = 'https://web.parsel.in/firebasecall/';
  //////////////////////////////////////////////////////////////////////////

  static String staticBaseUrl = liveServer;

  ///Auth
  static const String loginUrl = _baseUrl9090 + 'auth/signin'; //_baseUrl9090
  static const String signUpUrl = '';

  ///Pending Orders
  static String getUserById = _baseUrl9090 + 'user/getUserById';

  static String getOrdersCount = staticBaseUrl + 'sales-order/getCount/';

  static String getGroupByUserId =
      staticBaseUrl + 'sales-order/getGroupByUserId/';

  static String updateGroupIdDetails =
      staticBaseUrl + 'sales-order/updateGroupIdDetails/';

  static String getSalesOrderListByStatus =
      staticBaseUrl + 'sales-order/getSalesOrderListByStatus';

  static String updateSalesOrder =
      staticBaseUrl + 'sales-order/updateSalesOrder';

  static String salesOrder = staticBaseUrl + 'sales-order/';

  static String uploadDocs = staticBaseUrl + 'sales-order/uploadDocs/';

  static String updateAddress = staticBaseUrl + 'updateaddress/';

  static String updateDistanceTravel = staticBaseUrl + 'updatedisttravel/';

  static String truckLoad = staticBaseUrl + 'sales-order/truck_load/';
}
