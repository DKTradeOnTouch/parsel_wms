class ExecuteStorageModal {
  int? status;
  String? message;
  Body? body;

  ExecuteStorageModal({this.status, this.message, this.body});

  ExecuteStorageModal.fromJson(Map<String, dynamic> json) {
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
  int? id;
  String? poId;
  String? assignedUser;
  List<int>? dateOfDelivery;
  String? status;
  // Null? createdBy;
  int? updatedOn;
  int? createdOn;
  int? userId;
  List<ItemList>? itemList;
  // Null? assignedUserDetail;

  PurchaseOrder({
    this.id,
    this.poId,
    this.assignedUser,
    this.dateOfDelivery,
    this.status,
    // this.createdBy,
    this.updatedOn,
    this.createdOn,
    this.userId,
    this.itemList,
    // this.assignedUserDetail
  });

  PurchaseOrder.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    poId = json['poId'];
    assignedUser = json['assignedUser'];
    dateOfDelivery = json['dateOfDelivery'].cast<int>();
    status = json['status'];
    // createdBy = json['createdBy'];
    updatedOn = json['updatedOn'];
    createdOn = json['createdOn'];
    userId = json['userId'];
    if (json['itemList'] != null) {
      itemList = <ItemList>[];
      json['itemList'].forEach((v) {
        itemList!.add(new ItemList.fromJson(v));
      });
    }
    // assignedUserDetail = json['assignedUserDetail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['poId'] = this.poId;
    data['assignedUser'] = this.assignedUser;
    data['dateOfDelivery'] = this.dateOfDelivery;
    data['status'] = this.status;
    // data['createdBy'] = this.createdBy;
    data['updatedOn'] = this.updatedOn;
    data['createdOn'] = this.createdOn;
    data['userId'] = this.userId;
    if (this.itemList != null) {
      data['itemList'] = this.itemList!.map((v) => v.toJson()).toList();
    }
    // data['assignedUserDetail'] = this.assignedUserDetail;
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
  List<int>? aging;
  Category? category;
  // Null? skuDetails;

  ItemList({
    this.id,
    this.productCode,
    this.qty,
    this.type,
    // this.binMaster,
    this.status,
    this.batch,
    this.aging,
    this.category,
    // this.skuDetails
  });

  ItemList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productCode = json['productCode'];
    qty = json['qty'];
    type = json['type'];
    // binMaster = json['binMaster'];
    status = json['status'];
    batch = json['batch'];
    aging = json['aging'].cast<int>();
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
    // skuDetails = json['skuDetails'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['productCode'] = this.productCode;
    data['qty'] = this.qty;
    data['type'] = this.type;
    // data['binMaster'] = this.binMaster;
    data['status'] = this.status;
    data['batch'] = this.batch;
    data['aging'] = this.aging;
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    // data['skuDetails'] = this.skuDetails;
    return data;
  }
}

class Category {
  int? id;
  String? name;
  List<SubCategoryList>? subCategoryList;
  // Null? createdOn;
  // Null? updatedOn;
  bool? escalation;

  Category(
      {this.id,
      this.name,
      this.subCategoryList,
      // this.createdOn,
      // this.updatedOn,
      this.escalation});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['subCategoryList'] != null) {
      subCategoryList = <SubCategoryList>[];
      json['subCategoryList'].forEach((v) {
        subCategoryList!.add(new SubCategoryList.fromJson(v));
      });
    }
    // createdOn = json['createdOn'];
    // updatedOn = json['updatedOn'];
    escalation = json['escalation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.subCategoryList != null) {
      data['subCategoryList'] =
          this.subCategoryList!.map((v) => v.toJson()).toList();
    }
    // data['createdOn'] = this.createdOn;
    // data['updatedOn'] = this.updatedOn;
    data['escalation'] = this.escalation;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['createdOn'] = this.createdOn;
    data['updatedOn'] = this.updatedOn;
    data['escalation'] = this.escalation;
    return data;
  }
}
