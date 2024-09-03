class InvoiceListModel1 {
  int? status;
  String? message;
  Body? body;

  InvoiceListModel1({this.status, this.message, this.body});

  InvoiceListModel1.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    body = json['body'] != null ? Body.fromJson(json['body']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = status;
    data['message'] = message;
    if (body != null) {
      data['body'] = body!.toJson();
    }
    return data;
  }
}

class Body {
  Data? data;

  Body({this.data});

  Body.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {

  int? totalCount;
  int? noOfItems;
  int? totalPages;

  Data({ this.totalCount, this.noOfItems, this.totalPages});

  Data.fromJson(Map<String, dynamic> json) {

    totalCount = json['totalCount'];
    noOfItems = json['noOfItems'];
    totalPages = json['totalPages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();

    data['totalCount'] = totalCount;
    data['noOfItems'] = noOfItems;
    data['totalPages'] = totalPages;
    return data;
  }
}

class ResultList {
  int? id;
  String? salesOrderId;
  List<ItemList>? itemList;
  String? creationTime;
  String? updatedOn;
  int? createdBy;
  Null updatedBy;
  Null approvedBy;

  Null payments;
  String? executionStatus;

  double? salesOrderValue;
  double? totalCollectedPayment;
  double? totalReturnSkuValue;
  double? difference;

  String? vehicleNumber;
  Null docs;
  Null locationList;
  Object? currentLocation;

  String? salesOrderPaymentStatus;

  ResultList({this.id, this.salesOrderId, this.itemList, this.creationTime, this.updatedOn, this.createdBy, this.updatedBy, this.approvedBy,  this.payments, this.executionStatus,  this.salesOrderValue, this.totalCollectedPayment, this.totalReturnSkuValue, this.difference, this.vehicleNumber, this.docs, this.locationList, this.currentLocation, this.salesOrderPaymentStatus});

  ResultList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    salesOrderId = json['salesOrderId'];
    if (json['itemList'] != null) {
      itemList = <ItemList>[];
      json['itemList'].forEach((v) { itemList!.add(ItemList.fromJson(v)); });
    }
    creationTime = json['creationTime'];
    updatedOn = json['updatedOn'];
    createdBy = json['createdBy'];
    updatedBy = json['updatedBy'];
    approvedBy = json['approvedBy'];
    payments = json['payments'];
    executionStatus = json['executionStatus'];
    salesOrderValue = json['salesOrderValue'];
    totalCollectedPayment = json['totalCollectedPayment'];
    totalReturnSkuValue = json['totalReturnSkuValue'];
    difference = json['difference'];
    vehicleNumber = json['vehicleNumber'];
    docs = json['docs'];
    locationList = json['locationList'];
    currentLocation = json['currentLocation'];
    salesOrderPaymentStatus = json['salesOrderPaymentStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
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

    data['payments'] = payments;
    data['executionStatus'] = executionStatus;

    data['salesOrderValue'] = salesOrderValue;
    data['totalCollectedPayment'] = totalCollectedPayment;
    data['totalReturnSkuValue'] = totalReturnSkuValue;
    data['difference'] = difference;

    data['vehicleNumber'] = vehicleNumber;
    data['docs'] = docs;
    data['locationList'] = locationList;
    data['currentLocation'] = currentLocation;

    data['salesOrderPaymentStatus'] = salesOrderPaymentStatus;
    return data;
  }
}

class ItemList {
  int? id;
  String? updatedOn;
  String? productCode;
  String? productName;
  Null batch;
  Null aging;
  double? unitPrice;
  int? qty;
  double? totalPrice;
  int? delivered;
  int? returned;
  String? status;
  String? creationTime;
  String? returnReason;
  String? action;
  Null updatedByUserDetails;

  ItemList({this.id, this.updatedOn, this.productCode, this.productName, this.batch, this.aging, this.unitPrice, this.qty, this.totalPrice, this.delivered, this.returned, this.status, this.creationTime, this.returnReason, this.action, this.updatedByUserDetails});

  ItemList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    updatedOn = json['updatedOn'];
    productCode = json['productCode'];
    productName = json['productName'];
    batch = json['batch'];
    aging = json['aging'];
    unitPrice = json['unitPrice'];
    qty = json['qty'];
    totalPrice = json['totalPrice'];
    delivered = json['delivered'];
    returned = json['returned'];
    status = json['status'];
    creationTime = json['creationTime'];
    returnReason = json['returnReason'];
    action = json['action'];
    updatedByUserDetails = json['updatedByUserDetails'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['updatedOn'] = updatedOn;
    data['productCode'] = productCode;
    data['productName'] = productName;
    data['batch'] = batch;
    data['aging'] = aging;
    data['unitPrice'] = unitPrice;
    data['qty'] = qty;
    data['totalPrice'] = totalPrice;
    data['delivered'] = delivered;
    data['returned'] = returned;
    data['status'] = status;
    data['creationTime'] = creationTime;
    data['returnReason'] = returnReason;
    data['action'] = action;
    data['updatedByUserDetails'] = updatedByUserDetails;
    return data;
  }
}


