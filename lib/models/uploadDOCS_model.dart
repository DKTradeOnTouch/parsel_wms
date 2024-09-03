class UploadDocs {
  int? status;
  String? message;
  Body? body;

  UploadDocs({this.status, this.message, this.body});

  UploadDocs.fromJson(Map<String, dynamic> json) {
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
  SalesOrderDetail? salesOrderDetail;

  Body({this.salesOrderDetail});

  Body.fromJson(Map<String, dynamic> json) {
    salesOrderDetail = json['salesOrderDetail'] != null
        ? SalesOrderDetail.fromJson(json['salesOrderDetail'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (salesOrderDetail != null) {
      data['salesOrderDetail'] = salesOrderDetail!.toJson();
    }
    return data;
  }
}

class SalesOrderDetail {
  int? id;
  String? salesOrderId;
  List<ItemList>? itemList;
  Null assignedWorker;
  List<int>? creationTime;
  List<int>? updatedOn;
  int? createdBy;
  Null approvedBy;
  Store? store;
  List<Null>? salesOrderPayments;
  String? executionStatus;
  int? salesOrderValue;
  Null groupId;
  Null deliveryDriver;
  Null vehicleNumber;
  Docs? docs;
  Null action;
  Null locationList;

  SalesOrderDetail(
      {this.id,
      this.salesOrderId,
      this.itemList,
      this.assignedWorker,
      this.creationTime,
      this.updatedOn,
      this.createdBy,
      this.approvedBy,
      this.store,
      this.salesOrderPayments,
      this.executionStatus,
      this.salesOrderValue,
      this.groupId,
      this.deliveryDriver,
      this.vehicleNumber,
      this.docs,
      this.action,
      this.locationList});

  SalesOrderDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    salesOrderId = json['salesOrderId'];
    if (json['itemList'] != null) {
      itemList = <ItemList>[];
      json['itemList'].forEach((v) {
        itemList!.add(ItemList.fromJson(v));
      });
    }
    assignedWorker = json['assignedWorker'];
    creationTime = json['creationTime'].cast<int>();
    updatedOn = json['updatedOn'].cast<int>();
    createdBy = json['createdBy'];
    approvedBy = json['approvedBy'];
    store = json['store'] != null ? Store.fromJson(json['store']) : null;
    // if (json['salesOrderPayments'] != null) {
    //   salesOrderPayments = <Null>[];
    //   json['salesOrderPayments'].forEach((v) {
    //     salesOrderPayments!.add(new Null.fromJson(v));
    //   });
    // }
    executionStatus = json['executionStatus'];
    salesOrderValue = json['salesOrderValue'];
    groupId = json['groupId'];
    deliveryDriver = json['deliveryDriver'];
    vehicleNumber = json['vehicleNumber'];
    docs = json['docs'] != null ? Docs.fromJson(json['docs']) : null;
    action = json['action'];
    locationList = json['locationList'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['salesOrderId'] = salesOrderId;
    if (itemList != null) {
      data['itemList'] = itemList!.map((v) => v.toJson()).toList();
    }
    data['assignedWorker'] = assignedWorker;
    data['creationTime'] = creationTime;
    data['updatedOn'] = updatedOn;
    data['createdBy'] = createdBy;
    data['approvedBy'] = approvedBy;
    if (store != null) {
      data['store'] = store!.toJson();
    }
    // if (this.salesOrderPayments != null) {
    //   data['salesOrderPayments'] =
    //       this.salesOrderPayments!.map((v) => v.toJson()).toList();
    // }
    data['executionStatus'] = executionStatus;
    data['salesOrderValue'] = salesOrderValue;
    data['groupId'] = groupId;
    data['deliveryDriver'] = deliveryDriver;
    data['vehicleNumber'] = vehicleNumber;
    if (docs != null) {
      data['docs'] = docs!.toJson();
    }
    data['action'] = action;
    data['locationList'] = locationList;
    return data;
  }
}

class ItemList {
  int? id;
  Null updatedOn;
  String? productCode;
  String? productName;
  String? batch;
  List<int>? aging;
  int? unitPrice;
  int? qty;
  int? totalPrice;
  int? delivered;
  int? returned;
  int? noOfBoxes;
  int? temperature;
  Null status;
  List<int>? creationTime;

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
      this.noOfBoxes,
      this.temperature,
      this.status,
      this.creationTime});

  ItemList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    updatedOn = json['updatedOn'];
    productCode = json['productCode'];
    productName = json['productName'];
    batch = json['batch'];
    aging = json['aging'].cast<int>();
    unitPrice = json['unitPrice'];
    qty = json['qty'];
    totalPrice = json['totalPrice'];
    delivered = json['delivered'];
    returned = json['returned'];
    noOfBoxes = json['noOfBoxes'];
    temperature = json['temperature'];
    status = json['status'];
    creationTime = json['creationTime'].cast<int>();
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
    data['noOfBoxes'] = noOfBoxes;
    data['temperature'] = temperature;
    data['status'] = status;
    data['creationTime'] = creationTime;
    return data;
  }
}

class Store {
  int? id;
  String? storeName;
  String? storeAddress;
  Null phoneNumber;
  int? createdOn;
  int? updatedOn;
  Warehouse? warehouse;

  Store(
      {this.id,
      this.storeName,
      this.storeAddress,
      this.phoneNumber,
      this.createdOn,
      this.updatedOn,
      this.warehouse});

  Store.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    storeName = json['storeName'];
    storeAddress = json['storeAddress'];
    phoneNumber = json['phoneNumber'];
    createdOn = json['createdOn'];
    updatedOn = json['updatedOn'];
    warehouse = json['warehouse'] != null
        ? Warehouse.fromJson(json['warehouse'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['storeName'] = storeName;
    data['storeAddress'] = storeAddress;
    data['phoneNumber'] = phoneNumber;
    data['createdOn'] = createdOn;
    data['updatedOn'] = updatedOn;
    if (warehouse != null) {
      data['warehouse'] = warehouse!.toJson();
    }
    return data;
  }
}

class Warehouse {
  int? id;
  String? warehouseId;
  String? wareHouseName;
  String? city;
  Null createdBy;
  int? updatedOn;
  int? createdOn;

  Warehouse(
      {this.id,
      this.warehouseId,
      this.wareHouseName,
      this.city,
      this.createdBy,
      this.updatedOn,
      this.createdOn});

  Warehouse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    warehouseId = json['warehouseId'];
    wareHouseName = json['wareHouseName'];
    city = json['city'];
    createdBy = json['createdBy'];
    updatedOn = json['updatedOn'];
    createdOn = json['createdOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['warehouseId'] = warehouseId;
    data['wareHouseName'] = wareHouseName;
    data['city'] = city;
    data['createdBy'] = createdBy;
    data['updatedOn'] = updatedOn;
    data['createdOn'] = createdOn;
    return data;
  }
}

class Docs {
  List<String>? images;
  String? pdf;
  Signature? signature;

  Docs({this.images, this.pdf, this.signature});

  Docs.fromJson(Map<String, dynamic> json) {
    images = json['images'].cast<String>();
    pdf = json['pdf'];
    signature = json['signature'] != null
        ? Signature.fromJson(json['signature'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['images'] = images;
    data['pdf'] = pdf;
    if (signature != null) {
      data['signature'] = signature!.toJson();
    }
    return data;
  }
}

class Signature {
  String? image;
  String? name;

  Signature({this.image, this.name});

  Signature.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = image;
    data['name'] = name;
    return data;
  }
}