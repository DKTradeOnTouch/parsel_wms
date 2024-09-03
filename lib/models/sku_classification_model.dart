class SkuClassificationModel {
  int? status;
  String? message;
  Body? body;

  SkuClassificationModel({this.status, this.message, this.body});

  SkuClassificationModel.fromJson(Map<String, dynamic> json) {
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
      this.itemList});

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
    return data;
  }
}

class ItemList {
  int? id;
  String? productCode;
  int? qty;
  String? type;
  // Null? binMaster;
  String? status;
  String? batch;
  // List<int>? aging;
  Category? category;

  ItemList(
      {this.id,
      this.productCode,
      this.qty,
      this.type,
      // this.binMaster,
      this.status,
      this.batch,
      // this.aging,
      this.category});

  ItemList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productCode = json['productCode'];
    qty = json['qty'];
    type = json['type'];
    // binMaster = json['binMaster'];
    status = json['status'];
    batch = json['batch'];
    // aging = json['aging'].cast<int>();
    category = json['category'] != null
        ? Category.fromJson(json['category'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['productCode'] = productCode;
    data['qty'] = qty;
    data['type'] = type;
    // data['binMaster'] = this.binMaster;
    data['status'] = status;
    data['batch'] = batch;
    // data['aging'] = this.aging;
    if (category != null) {
      data['category'] = category!.toJson();
    }
    return data;
  }
}

class Category {
  int? id;
  String? name;
  List<SubCategoryList>? subCategoryList;
  Null createdOn;
  Null updatedOn;
  bool? escalation;

  Category(
      {this.id,
      this.name,
      this.subCategoryList,
      this.createdOn,
      this.updatedOn,
      this.escalation});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['subCategoryList'] != null) {
      subCategoryList = <SubCategoryList>[];
      json['subCategoryList'].forEach((v) {
        subCategoryList!.add(SubCategoryList.fromJson(v));
      });
    }
    createdOn = json['createdOn'];
    updatedOn = json['updatedOn'];
    escalation = json['escalation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    if (subCategoryList != null) {
      data['subCategoryList'] =
          subCategoryList!.map((v) => v.toJson()).toList();
    }
    data['createdOn'] = createdOn;
    data['updatedOn'] = updatedOn;
    data['escalation'] = escalation;
    return data;
  }
}

class SubCategoryList {
  int? id;
  String? name;
  int? createdOn;
  int? updatedOn;
  bool? escalation;

  SubCategoryList(
      {this.id, this.name, this.createdOn, this.updatedOn, this.escalation});

  SubCategoryList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdOn = json['createdOn'];
    updatedOn = json['updatedOn'];
    escalation = json['escalation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['createdOn'] = createdOn;
    data['updatedOn'] = updatedOn;
    data['escalation'] = escalation;
    return data;
  }
}
