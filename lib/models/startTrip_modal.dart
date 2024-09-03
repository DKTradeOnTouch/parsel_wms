class StartTripModal {
  num? status;
  String? message;
  Body? body;

  StartTripModal({this.status, this.message, this.body});

  StartTripModal.fromJson(Map<String, dynamic> json) {
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
  Assignments? assignments;
  String? salesOrderPaymentStatus;
  num? temperature;
  String? deliveryAddress;

  Data(
      {this.id,
      this.salesOrderId,
      this.itemList,
      this.creationTime,
      this.updatedOn,
      this.createdBy,
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
      this.assignments,
      this.salesOrderPaymentStatus,
      this.temperature,
      this.deliveryAddress});

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
    store = json['store'] != null ? Store.fromJson(json['store']) : null;
    payments = json['payments'];
    executionStatus = json['executionStatus'];
    routes =
        json['routes'] != null ? Routes.fromJson(json['routes']) : null;
    salesOrderValue = json['salesOrderValue'];
    totalCollectedPayment = json['totalCollectedPayment'];
    totalReturnSkuValue = json['totalReturnSkuValue'];
    difference = json['difference'];
    groupId =
        json['groupId'] != null ? GroupId.fromJson(json['groupId']) : null;
    vehicleNumber = json['vehicleNumber'];
    assignments = json['assignments'] != null
        ? Assignments.fromJson(json['assignments'])
        : null;
    salesOrderPaymentStatus = json['salesOrderPaymentStatus'];
    temperature = json['temperature'];
    deliveryAddress = json['deliveryAddress'];
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
    if (assignments != null) {
      data['assignments'] = assignments!.toJson();
    }
    data['salesOrderPaymentStatus'] = salesOrderPaymentStatus;
    data['temperature'] = temperature;
    data['deliveryAddress'] = deliveryAddress;
    return data;
  }
}

class ItemList {
  num? id;
  String? productCode;
  String? productName;
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

  ItemList(
      {this.id,
      this.productCode,
      this.productName,
      this.unitPrice,
      this.qty,
      this.totalPrice,
      this.delivered,
      this.returned,
      this.status,
      this.creationTime,
      this.returnReason,
      this.action,
      this.returnInfo});

  ItemList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productCode = json['productCode'];
    productName = json['productName'];
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['productCode'] = productCode;
    data['productName'] = productName;
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
    return data;
  }
}

class Store {
  num? id;
  String? storeName;
  List<AddressList>? addressList;

  Store({this.id, this.storeName, this.addressList});

  Store.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    storeName = json['storeName'];
    if (json['addressList'] != null) {
      addressList = <AddressList>[];
      json['addressList'].forEach((v) {
        addressList!.add(AddressList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['storeName'] = storeName;
    if (addressList != null) {
      data['addressList'] = addressList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AddressList {
  num? id;
  String? address;
  double? longitude;
  double? latitude;

  AddressList({this.id, this.address, this.longitude, this.latitude});

  AddressList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    address = json['address'];
    longitude = json['longitude'];
    latitude = json['latitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['address'] = address;
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
  num? noOfBoxes;
  num? temperature;

  GroupId(
      {this.id,
      this.vehicleNo,
      this.collectedCash,
      this.status,
      this.openingBalance,
      this.noOfBoxes,
      this.temperature});

  GroupId.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vehicleNo = json['vehicleNo'];
    collectedCash = json['collectedCash'];
    status = json['status'];
    openingBalance = json['openingBalance'];
    noOfBoxes = json['noOfBoxes'];
    temperature = json['temperature'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['vehicleNo'] = vehicleNo;
    data['collectedCash'] = collectedCash;
    data['status'] = status;
    data['openingBalance'] = openingBalance;
    data['noOfBoxes'] = noOfBoxes;
    data['temperature'] = temperature;
    return data;
  }
}

class Assignments {
  InGroup? inGroup;
  InGroup? arrived;
  InGroup? onGoing;

  Assignments({this.inGroup, this.arrived, this.onGoing});

  Assignments.fromJson(Map<String, dynamic> json) {
    inGroup = json['in_group'] != null
        ? InGroup.fromJson(json['in_group'])
        : null;
    arrived =
        json['arrived'] != null ? InGroup.fromJson(json['arrived']) : null;
    onGoing = json['on_going'] != null
        ? InGroup.fromJson(json['on_going'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (inGroup != null) {
      data['in_group'] = inGroup!.toJson();
    }
    if (arrived != null) {
      data['arrived'] = arrived!.toJson();
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
