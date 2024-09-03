class RouteOptimizedModal {
  num? status;
  String? message;
  Body? body;

  RouteOptimizedModal({this.status, this.message, this.body});

  RouteOptimizedModal.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    body = json['body'] != null ? new Body.fromJson(json['body']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (body != null) {
      data['body'] = body!.toJson();
    }
    return data;
  }
}

class Body {
  List<Data>? data;

  Body({this.data});

  Body.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  num? id;
  String? salesOrderId;
  List<ItemList>? itemList;
  String? creationTime;
  String? updatedOn;
  num? createdBy;
  Null updatedBy;
  Null approvedBy;
  Store? store;
  Null payments;
  String? executionStatus;
  Routes? routes;
  double? salesOrderValue;
  num? totalCollectedPayment;
  num? totalReturnSkuValue;
  double? difference;
  GroupId? groupId;
  String? vehicleNumber;
  Null locationList;
  Null currentLocation;
  Null userDetails;
  Assignments? assignments;
  String? salesOrderPaymentStatus;
  num? temperature;

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
      this.routes,
      this.salesOrderValue,
      this.totalCollectedPayment,
      this.totalReturnSkuValue,
      this.difference,
      this.groupId,
      this.vehicleNumber,
      this.locationList,
      this.currentLocation,
      this.userDetails,
      this.assignments,
      this.salesOrderPaymentStatus,
      this.temperature});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    salesOrderId = json['salesOrderId'];
    if (json['itemList'] != null) {
      itemList = <ItemList>[];
      json['itemList'].forEach((v) {
        itemList!.add(new ItemList.fromJson(v));
      });
    }
    creationTime = json['creationTime'];
    updatedOn = json['updatedOn'];
    createdBy = json['createdBy'];
    updatedBy = json['updatedBy'];
    approvedBy = json['approvedBy'];
    store = json['store'] != null ? new Store.fromJson(json['store']) : null;
    payments = json['payments'];
    executionStatus = json['executionStatus'];
    routes =
        json['routes'] != null ? new Routes.fromJson(json['routes']) : null;
    salesOrderValue = json['salesOrderValue'];
    totalCollectedPayment = json['totalCollectedPayment'];
    totalReturnSkuValue = json['totalReturnSkuValue'];
    difference = json['difference'];
    groupId =
        json['groupId'] != null ? new GroupId.fromJson(json['groupId']) : null;
    vehicleNumber = json['vehicleNumber'];
    locationList = json['locationList'];
    currentLocation = json['currentLocation'];
    userDetails = json['userDetails'];
    assignments = json['assignments'] != null
        ? new Assignments.fromJson(json['assignments'])
        : null;
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
    if (routes != null) {
      data['routes'] = routes!.toJson();
    }
    data['salesOrderValue'] = salesOrderValue;
    data['totalCollectedPayment'] = totalCollectedPayment;
    data['totalReturnSkuValue'] = totalReturnSkuValue;
    data['difference'] = difference;
    if (groupId != null) {
      data['groupId'] = groupId!.toJson();
    }
    data['vehicleNumber'] = vehicleNumber;
    data['locationList'] = locationList;
    data['currentLocation'] = currentLocation;
    data['userDetails'] = userDetails;
    if (assignments != null) {
      data['assignments'] = assignments!.toJson();
    }
    data['salesOrderPaymentStatus'] = salesOrderPaymentStatus;
    data['temperature'] = temperature;
    return data;
  }
}

class ItemList {
  num? id;
  Null updatedOn;
  String? productCode;
  String? productName;
  Null batch;
  Null aging;
  double? unitPrice;
  num? qty;
  double? totalPrice;
  num? delivered;
  num? returned;
  String? status;
  String? creationTime;
  String? returnReason;
  String? action;
  String? returnInfo;
  Null updatedByUserDetails;

  ItemList(
      {this.id,
      this.updatedOn,
      this.productCode,
      this.productName,
      this.batch,
      this.aging,
      this.unitPrice,
      this.qty,
      this.totalPrice,
      this.delivered,
      this.returned,
      this.status,
      this.creationTime,
      this.returnReason,
      this.action,
      this.returnInfo,
      this.updatedByUserDetails});

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
    returnInfo = json['returnInfo'];
    updatedByUserDetails = json['updatedByUserDetails'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
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
    data['returnInfo'] = returnInfo;
    data['updatedByUserDetails'] = updatedByUserDetails;
    return data;
  }
}

class Store {
  num? id;
  String? storeName;
  String? storeAddress;
  String? phoneNumber;
  double? longitude;
  double? latitude;

  Store(
      {this.id,
      this.storeName,
      this.storeAddress,
      this.phoneNumber,
      this.longitude,
      this.latitude});

  Store.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    storeName = json['storeName'];
    storeAddress = json['storeAddress'];
    phoneNumber = json['phoneNumber'];
    longitude = json['longitude'];
    latitude = json['latitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['storeName'] = storeName;
    data['storeAddress'] = storeAddress;
    data['phoneNumber'] = phoneNumber;
    data['longitude'] = longitude;
    data['latitude'] = latitude;
    return data;
  }
}

class Routes {
  num? id;
  String? routeName;

  Routes({this.id, this.routeName});

  Routes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    routeName = json['routeName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['routeName'] = routeName;
    return data;
  }
}

class GroupId {
  num? id;
  String? vehicleNo;
  num? collectedCash;
  String? status;
  num? openingBalance;
  Null debitToUserId;
  Null debitToUserDetails;
  Null createdByUserDetails;
  num? noOfBoxes;
  num? temperature;
  List<String>? optimizedRouteForSO;

  GroupId(
      {this.id,
      this.vehicleNo,
      this.collectedCash,
      this.status,
      this.openingBalance,
      this.debitToUserId,
      this.debitToUserDetails,
      this.createdByUserDetails,
      this.noOfBoxes,
      this.temperature,
      this.optimizedRouteForSO});

  GroupId.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vehicleNo = json['vehicleNo'];
    collectedCash = json['collectedCash'];
    status = json['status'];
    openingBalance = json['openingBalance'];
    debitToUserId = json['debitToUserId'];
    debitToUserDetails = json['debitToUserDetails'];
    createdByUserDetails = json['createdByUserDetails'];
    noOfBoxes = json['noOfBoxes'];
    temperature = json['temperature'];
    optimizedRouteForSO = json['optimizedRouteForSO'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['vehicleNo'] = vehicleNo;
    data['collectedCash'] = collectedCash;
    data['status'] = status;
    data['openingBalance'] = openingBalance;
    data['debitToUserId'] = debitToUserId;
    data['debitToUserDetails'] = debitToUserDetails;
    data['createdByUserDetails'] = createdByUserDetails;
    data['noOfBoxes'] = noOfBoxes;
    data['temperature'] = temperature;
    data['optimizedRouteForSO'] = optimizedRouteForSO;
    return data;
  }
}

class Assignments {
  InGroup? inGroup;
  InGroup? onGoing;

  Assignments({this.inGroup, this.onGoing});

  Assignments.fromJson(Map<String, dynamic> json) {
    inGroup = json['in_group'] != null
        ? new InGroup.fromJson(json['in_group'])
        : null;
    onGoing = json['on_going'] != null
        ? new InGroup.fromJson(json['on_going'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (inGroup != null) {
      data['in_group'] = inGroup!.toJson();
    }
    if (onGoing != null) {
      data['on_going'] = onGoing!.toJson();
    }
    return data;
  }
}

class InGroup {
  String? userId;
  String? timestamp;

  InGroup({this.userId, this.timestamp});

  InGroup.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['timestamp'] = timestamp;
    return data;
  }
}
