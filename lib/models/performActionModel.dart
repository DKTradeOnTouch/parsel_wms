class PerformActionModel {
  int? status;
  String? message;
  Body? body;

  PerformActionModel({this.status, this.message, this.body});

  PerformActionModel.fromJson(Map<String, dynamic> json) {
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
  PurchaseOrder? purchaseOrder;

  Body({this.purchaseOrder});

  Body.fromJson(Map<String, dynamic> json) {
    purchaseOrder = json['purchaseOrder'] != null
        ? PurchaseOrder.fromJson(json['purchaseOrder'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (purchaseOrder != null) {
      data['purchaseOrder'] = purchaseOrder!.toJson();
    }
    return data;
  }
}

class PurchaseOrder {
  int? id;
  String? poId;
  String? assignedUser;
  List<int>? dateOfDelivery;
  String? status;
  Null createdBy;
  int? updatedOn;
  int? createdOn;
  int? userId;
  List<ItemList>? itemList;
  Null assignedUserDetail;

  PurchaseOrder(
      {this.id,
      this.poId,
      this.assignedUser,
      this.dateOfDelivery,
      this.status,
      this.createdBy,
      this.updatedOn,
      this.createdOn,
      this.userId,
      this.itemList,
      this.assignedUserDetail});

  PurchaseOrder.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    poId = json['poId'];
    assignedUser = json['assignedUser'];
    dateOfDelivery = json['dateOfDelivery'].cast<int>();
    status = json['status'];
    createdBy = json['createdBy'];
    updatedOn = json['updatedOn'];
    createdOn = json['createdOn'];
    userId = json['userId'];
    if (json['itemList'] != null) {
      itemList = <ItemList>[];
      json['itemList'].forEach((v) {
        itemList!.add(ItemList.fromJson(v));
      });
    }
    assignedUserDetail = json['assignedUserDetail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['poId'] = poId;
    data['assignedUser'] = assignedUser;
    data['dateOfDelivery'] = dateOfDelivery;
    data['status'] = status;
    data['createdBy'] = createdBy;
    data['updatedOn'] = updatedOn;
    data['createdOn'] = createdOn;
    data['userId'] = userId;
    if (itemList != null) {
      data['itemList'] = itemList!.map((v) => v.toJson()).toList();
    }
    data['assignedUserDetail'] = assignedUserDetail;
    return data;
  }
}

class ItemList {
  int? id;
  String? productCode;
  int? qty;
  String? type;
  Null binMaster;
  Null classification;
  String? status;
  String? batch;
  List<int>? aging;
  Null category;
  Null skuDetails;

  ItemList(
      {this.id,
      this.productCode,
      this.qty,
      this.type,
      this.binMaster,
      this.classification,
      this.status,
      this.batch,
      this.aging,
      this.category,
      this.skuDetails});

  ItemList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productCode = json['productCode'];
    qty = json['qty'];
    type = json['type'];
    binMaster = json['binMaster'];
    classification = json['classification'];
    status = json['status'];
    batch = json['batch'];
    aging = json['aging'].cast<int>();
    category = json['category'];
    skuDetails = json['skuDetails'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['productCode'] = productCode;
    data['qty'] = qty;
    data['type'] = type;
    data['binMaster'] = binMaster;
    data['classification'] = classification;
    data['status'] = status;
    data['batch'] = batch;
    data['aging'] = aging;
    data['category'] = category;
    data['skuDetails'] = skuDetails;
    return data;
  }
}