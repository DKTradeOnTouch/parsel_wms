class PickPackPerformActionModal {
  num? status;
  String? message;
  Body? body;

  PickPackPerformActionModal({this.status, this.message, this.body});

  PickPackPerformActionModal.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    body = json['body'] != null ? Body.fromJson(json['body']) : null;
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
  Data? data;

  Body({this.data});

  Body.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
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
  Null routes;
  double? salesOrderValue;
  num? totalCollectedPayment;
  num? totalReturnSkuValue;
  double? difference;
  Null groupId;
  Null vehicleNumber;
  Null docs;
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
      this.docs,
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
    routes = json['routes'];
    salesOrderValue = json['salesOrderValue'];
    totalCollectedPayment = json['totalCollectedPayment'];
    totalReturnSkuValue = json['totalReturnSkuValue'];
    difference = json['difference'];
    groupId = json['groupId'];
    vehicleNumber = json['vehicleNumber'];
    docs = json['docs'];
    locationList = json['locationList'];
    currentLocation = json['currentLocation'];
    userDetails = json['userDetails'];
    assignments = json['assignments'] != null
        ? Assignments.fromJson(json['assignments'])
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
    data['routes'] = routes;
    data['salesOrderValue'] = salesOrderValue;
    data['totalCollectedPayment'] = totalCollectedPayment;
    data['totalReturnSkuValue'] = totalReturnSkuValue;
    data['difference'] = difference;
    data['groupId'] = groupId;
    data['vehicleNumber'] = vehicleNumber;
    data['docs'] = docs;
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
  List<num>? updatedOn;
  String? productCode;
  String? productName;
  String? batch;
  List<num>? aging;
  double? unitPrice;
  num? qty;
  double? totalPrice;
  num? delivered;
  num? returned;
  String? status;
  String? creationTime;
  Null returnReason;
  String? action;
  String? returnInfo;
  UpdatedByUserDetails? updatedByUserDetails;

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
    updatedOn = json['updatedOn'].cast<num>();
    productCode = json['productCode'];
    productName = json['productName'];
    batch = json['batch'];
    aging = json['aging'].cast<num>();
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
    updatedByUserDetails = json['updatedByUserDetails'] != null
        ? UpdatedByUserDetails.fromJson(json['updatedByUserDetails'])
        : null;
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
    if (updatedByUserDetails != null) {
      data['updatedByUserDetails'] = updatedByUserDetails!.toJson();
    }
    return data;
  }
}

class UpdatedByUserDetails {
  String? id;
  String? username;
  String? email;
  List<Roles>? roles;

  UpdatedByUserDetails({this.id, this.username, this.email, this.roles});

  UpdatedByUserDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    if (json['roles'] != null) {
      roles = <Roles>[];
      json['roles'].forEach((v) {
        roles!.add(Roles.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['email'] = email;
    if (roles != null) {
      data['roles'] = roles!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Roles {
  num? id;
  String? name;
  List<Null>? functionList;

  Roles({this.id, this.name, this.functionList});

  Roles.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    // if (json['functionList'] != null) {
    //   functionList = <Null>[];
    //   json['functionList'].forEach((v) {
    //     functionList!.add(new Null.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    // if (this.functionList != null) {
    //   data['functionList'] = this.functionList!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

class Store {
  num? id;
  String? storeName;
  String? storeAddress;
  String? phoneNumber;
  num? longitude;
  num? latitude;

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

class Assignments {
  Picking? picking;
  Picking? packing;

  Assignments({this.picking, this.packing});

  Assignments.fromJson(Map<String, dynamic> json) {
    picking =
        json['picking'] != null ? Picking.fromJson(json['picking']) : null;
    packing =
        json['packing'] != null ? Picking.fromJson(json['packing']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (picking != null) {
      data['picking'] = picking!.toJson();
    }
    if (packing != null) {
      data['packing'] = packing!.toJson();
    }
    return data;
  }
}

class Picking {
  String? userId;
  String? timestamp;

  Picking({this.userId, this.timestamp});

  Picking.fromJson(Map<String, dynamic> json) {
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
