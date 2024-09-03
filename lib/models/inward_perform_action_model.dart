class InwardPerformActionModel {
  num? status;
  String? message;
  Body? body;

  InwardPerformActionModel({this.status, this.message, this.body});

  InwardPerformActionModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    body = json['body'] != null ? new Body.fromJson(json['body']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.body != null) {
      data['body'] = this.body!.toJson();
    }
    return data;
  }
}

class Body {
  PurchaseOrder? purchaseOrder;

  Body({this.purchaseOrder});

  Body.fromJson(Map<String, dynamic> json) {
    purchaseOrder = json['purchaseOrder'] != null
        ? new PurchaseOrder.fromJson(json['purchaseOrder'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.purchaseOrder != null) {
      data['purchaseOrder'] = this.purchaseOrder!.toJson();
    }
    return data;
  }
}

class PurchaseOrder {
  num? id;
  String? poId;
  String? assignedUser;
  List<num>? dateOfDelivery;
  String? status;
  num? updatedOn;
  num? createdOn;
  num? userId;
  List<ItemList>? itemList;

  PurchaseOrder(
      {this.id,
      this.poId,
      this.assignedUser,
      this.dateOfDelivery,
      this.status,
      this.updatedOn,
      this.createdOn,
      this.userId,
      this.itemList});

  PurchaseOrder.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    poId = json['poId'];
    assignedUser = json['assignedUser'];
    dateOfDelivery = json['dateOfDelivery'].cast<num>();
    status = json['status'];
    updatedOn = json['updatedOn'];
    createdOn = json['createdOn'];
    userId = json['userId'];
    if (json['itemList'] != null) {
      itemList = <ItemList>[];
      json['itemList'].forEach((v) {
        itemList!.add(new ItemList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['poId'] = this.poId;
    data['assignedUser'] = this.assignedUser;
    data['dateOfDelivery'] = this.dateOfDelivery;
    data['status'] = this.status;
    data['updatedOn'] = this.updatedOn;
    data['createdOn'] = this.createdOn;
    data['userId'] = this.userId;
    if (this.itemList != null) {
      data['itemList'] = this.itemList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ItemList {
  num? id;
  String? productCode;
  num? qty;
  String? type;
  BinMaster? binMaster;
  String? status;
  String? batch;
  List<num>? aging;

  ItemList(
      {this.id,
      this.productCode,
      this.qty,
      this.type,
      this.binMaster,
      this.status,
      this.batch,
      this.aging});

  ItemList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productCode = json['productCode'];
    qty = json['qty'];
    type = json['type'];
    binMaster = json['binMaster'] != null
        ? new BinMaster.fromJson(json['binMaster'])
        : null;
    status = json['status'];
    batch = json['batch'];
    aging = json['aging'].cast<num>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['productCode'] = this.productCode;
    data['qty'] = this.qty;
    data['type'] = this.type;
    if (this.binMaster != null) {
      data['binMaster'] = this.binMaster!.toJson();
    }
    data['status'] = this.status;
    data['batch'] = this.batch;
    data['aging'] = this.aging;
    return data;
  }
}

class BinMaster {
  num? id;
  String? binName;
  String? binLocation;
  String? warehouse;
  num? binCapacity;
  num? binVolume;
  String? productCode;
  String? barCodeId;
  num? createdOn;
  num? updatedOn;
  num? length;
  num? heigth;
  num? width;

  BinMaster(
      {this.id,
      this.binName,
      this.binLocation,
      this.warehouse,
      this.binCapacity,
      this.binVolume,
      this.productCode,
      this.barCodeId,
      this.createdOn,
      this.updatedOn,
      this.length,
      this.heigth,
      this.width});

  BinMaster.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    binName = json['binName'];
    binLocation = json['binLocation'];
    warehouse = json['warehouse'];
    binCapacity = json['binCapacity'];
    binVolume = json['binVolume'];
    productCode = json['productCode'];
    barCodeId = json['barCodeId'];
    createdOn = json['createdOn'];
    updatedOn = json['updatedOn'];
    length = json['length'];
    heigth = json['heigth'];
    width = json['width'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['binName'] = this.binName;
    data['binLocation'] = this.binLocation;
    data['warehouse'] = this.warehouse;
    data['binCapacity'] = this.binCapacity;
    data['binVolume'] = this.binVolume;
    data['productCode'] = this.productCode;
    data['barCodeId'] = this.barCodeId;
    data['createdOn'] = this.createdOn;
    data['updatedOn'] = this.updatedOn;
    data['length'] = this.length;
    data['heigth'] = this.heigth;
    data['width'] = this.width;
    return data;
  }
}