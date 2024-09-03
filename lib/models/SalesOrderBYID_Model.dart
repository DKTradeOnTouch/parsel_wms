class SalesOrderBYID_Model {
  Data? data;
  String? message;
  int? status;

  SalesOrderBYID_Model({this.data, this.message, this.status});

  SalesOrderBYID_Model.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = message;
    data['status'] = status;
    return data;
  }
}

class Data {
  int? id;
  String? salesOrderId;
  List<ItemList>? itemList;
  String? creationTime;
  String? updatedOn;
  int? createdBy;
  Null updatedBy;
  Null approvedBy;
  Store? store;
  Null payments;
  String? executionStatus;
  double? salesOrderValue;
  double? totalCollectedPayment;
  double? totalReturnSkuValue;
  double? difference;
  String? vehicleNumber;
  // Null? docs;
  List<LocationList>? locationList;
  Object? currentLocation;
  Null userDetails;
  String? salesOrderPaymentStatus;
  double? temperature;

  Data(
      {this.id,
      this.salesOrderId,
      this.itemList,
      this.creationTime,
      this.updatedOn,
      this.createdBy,
      this.updatedBy,
      this.approvedBy,
      this.store,
      this.payments,
      this.executionStatus,
      this.salesOrderValue,
      this.totalCollectedPayment,
      this.totalReturnSkuValue,
      this.difference,
      this.vehicleNumber,
      // this.docs,
      this.locationList,
      this.currentLocation,
      this.userDetails,
      this.salesOrderPaymentStatus,
      this.temperature});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    salesOrderId = json['salesOrderId'];
    if (json['itemList'] != null) {
      itemList = <ItemList>[];
      json['itemList'].forEach((v) {
        itemList!.add(ItemList.fromJson(v));
      });
    }
    creationTime = json['creationTime'];
    updatedOn = json['updatedOn'];
    createdBy = json['createdBy'];
    updatedBy = json['updatedBy'];
    approvedBy = json['approvedBy'];
    store = json['store'] != null ? Store.fromJson(json['store']) : null;
    payments = json['payments'];
    executionStatus = json['executionStatus'];
    // routes = json['routes'] != null ? new Routes.fromJson(json['routes']) : null;
    salesOrderValue = json['salesOrderValue'];
    totalCollectedPayment = json['totalCollectedPayment'];
    totalReturnSkuValue = json['totalReturnSkuValue'];
    difference = json['difference'];
    //  groupId = json['groupId'] != null ? new GroupId.fromJson(json['groupId']) : null;
    vehicleNumber = json['vehicleNumber'];
    // docs = json['docs'];
    if (json['locationList'] != null) {
      locationList = <LocationList>[];
      json['locationList'].forEach((v) {
        locationList!.add(LocationList.fromJson(v));
      });
    }
    currentLocation = json['currentLocation'];
    userDetails = json['userDetails'];
    //  assignments = json['assignments'] != null ? new Assignments.fromJson(json['assignments']) : null;
    salesOrderPaymentStatus = json['salesOrderPaymentStatus'];
    temperature = json['temperature'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['salesOrderId'] = salesOrderId;
    if (itemList != null) {
      data['itemList'] = itemList!.map((v) => v.toJson()).toList();
    }
    data['creationTime'] = creationTime;
    data['updatedOn'] = updatedOn;
    data['createdBy'] = createdBy;
    data['updatedBy'] = updatedBy;
    data['approvedBy'] = approvedBy;
    if (store != null) {
      data['store'] = store!.toJson();
    }
    data['payments'] = payments;
    data['executionStatus'] = executionStatus;

    data['salesOrderValue'] = salesOrderValue;
    data['totalCollectedPayment'] = totalCollectedPayment;
    data['totalReturnSkuValue'] = totalReturnSkuValue;
    data['difference'] = difference;

    data['vehicleNumber'] = vehicleNumber;
    // data['docs'] = this.docs;
    if (locationList != null) {
      data['locationList'] = locationList!.map((v) => v.toJson()).toList();
    }
    data['currentLocation'] = currentLocation;
    data['userDetails'] = userDetails;

    data['salesOrderPaymentStatus'] = salesOrderPaymentStatus;
    data['temperature'] = temperature;
    return data;
  }
}

class ItemList {
  ItemList({
    required this.id,
    required this.updatedOn,
    required this.productCode,
    required this.productName,
    this.batch,
    this.aging,
    required this.unitPrice,
    required this.qty,
    required this.totalPrice,
    required this.delivered,
    required this.returned,
    required this.status,
    required this.creationTime,
    this.returnReason = 'Reason 1',
    required this.action,
    required this.returnInfo,
    this.updatedByUserDetails,
  });

  int id;
  dynamic updatedOn;
  String productCode;
  String productName;
  dynamic batch;
  dynamic aging;
  num unitPrice;
  int qty;
  num totalPrice;
  int delivered;
  int returned;
  String status;
  DateTime creationTime;
  dynamic returnReason;
  String action;
  String returnInfo;
  dynamic updatedByUserDetails;

  factory ItemList.fromJson(Map<String, dynamic> json) => ItemList(
        id: json["id"],
        updatedOn: json["updatedOn"],
        productCode: json["productCode"],
        productName: json["productName"],
        batch: json["batch"],
        aging: json["aging"],
        unitPrice: json["unitPrice"],
        qty: json["qty"],
        totalPrice: json["totalPrice"],
        delivered: json["delivered"],
        returned: json["returned"],
        status: json["status"],
        creationTime: DateTime.parse(json["creationTime"]),
        returnReason: json["returnReason"],
        action: json["action"],
        returnInfo: json["returnInfo"],
        updatedByUserDetails: json["updatedByUserDetails"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "updatedOn": updatedOn,
        "productCode": productCode,
        "productName": productName,
        "batch": batch,
        "aging": aging,
        "unitPrice": unitPrice,
        "qty": qty,
        "totalPrice": totalPrice,
        "delivered": delivered,
        "returned": returned,
        "status": status,
        "creationTime": creationTime.toIso8601String(),
        "returnReason": returnReason,
        "action": action,
        "returnInfo": returnInfo,
        "updatedByUserDetails": updatedByUserDetails,
      };
}

class Store {
  int? id;
  String? storeName;
  String? storeAddress;
  String? phoneNumber;

  Store({this.id, this.storeName, this.storeAddress, this.phoneNumber});

  Store.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    storeName = json['storeName'];
    storeAddress = json['storeAddress'];
    phoneNumber = json['phoneNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['storeName'] = storeName;
    data['storeAddress'] = storeAddress;
    data['phoneNumber'] = phoneNumber;
    return data;
  }
}

class LocationList {
  int? id;
  String? salesOrderId;
  String? deliveryDriverId;
  double? latitude;
  double? longitude;
  String? createdOn;
  List<int>? updatedOn;

  LocationList(
      {this.id,
      this.salesOrderId,
      this.deliveryDriverId,
      this.latitude,
      this.longitude,
      this.createdOn,
      this.updatedOn});

  LocationList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    salesOrderId = json['salesOrderId'];
    deliveryDriverId = json['deliveryDriverId'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    createdOn = json['createdOn'];
    updatedOn = json['updatedOn'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['salesOrderId'] = salesOrderId;
    data['deliveryDriverId'] = deliveryDriverId;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['createdOn'] = createdOn;
    data['updatedOn'] = updatedOn;
    return data;
  }
}
