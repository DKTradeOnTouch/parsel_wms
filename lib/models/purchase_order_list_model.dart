class PurchaseOrderModel {
  String? status;
  String? message;
  Body? body;

  PurchaseOrderModel({this.status, this.message, this.body});

  PurchaseOrderModel.fromJson(Map<String, dynamic> json) {
    status = json['status'].toString();
    message = json['message'];
    body = json['body'] != null ? new Body.fromJson(json['body']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = this.status.toString();
    data['message'] = this.message;
    if (this.body != null) {
      data['body'] = this.body!.toJson();
    }
    return data;
  }
}

class Body {
  PurchaseOrderList? purchaseOrderList;

  Body({this.purchaseOrderList});

  Body.fromJson(Map<String, dynamic> json) {
    purchaseOrderList = json['purchaseOrderList'] != null
        ? new PurchaseOrderList.fromJson(json['purchaseOrderList'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.purchaseOrderList != null) {
      data['purchaseOrderList'] = this.purchaseOrderList!.toJson();
    }
    return data;
  }
}

class PurchaseOrderList {
  List<PurchaseOrderResultList>? resultList;
  int? totalCount;
  int? noOfItems;
  int? totalPages;

  PurchaseOrderList(
      {this.resultList, this.totalCount, this.noOfItems, this.totalPages});

  PurchaseOrderList.fromJson(Map<String, dynamic> json) {
    if (json['resultList'] != null) {
      resultList = <PurchaseOrderResultList>[];
      json['resultList'].forEach((v) {
        resultList!.add(new PurchaseOrderResultList.fromJson(v));
      });
    }
    totalCount = json['totalCount'];
    noOfItems = json['noOfItems'];
    totalPages = json['totalPages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.resultList != null) {
      data['resultList'] = this.resultList!.map((v) => v.toJson()).toList();
    }
    data['totalCount'] = this.totalCount;
    data['noOfItems'] = this.noOfItems;
    data['totalPages'] = this.totalPages;
    return data;
  }
}

class PurchaseOrderResultList {
  String? id;
  String? poId;
  String? assignedUser;
  List<int>? dateOfDelivery;
  String? status;
  int? updatedOn;
  int? createdOn;
  int? userId;
  List<ItemList>? itemList;

  PurchaseOrderResultList({
    this.id,
    this.poId,
    this.assignedUser,
    this.dateOfDelivery,
    this.status,
    this.updatedOn,
    this.createdOn,
    this.userId,
    this.itemList,
  });

  PurchaseOrderResultList.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    poId = json['poId'];
    assignedUser = json['assignedUser'];
    dateOfDelivery = json['dateOfDelivery'].cast<int>();
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
    data['id'] = this.id.toString();
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
  String? id;
  String? productCode;
  int? qty;
  String? type;
  String? status;
  String? batch;

  ItemList({
    this.id,
    this.productCode,
    this.qty,
    this.type,
    this.status,
    this.batch,
  });

  ItemList.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    productCode = json['productCode'];
    qty = json['qty'];
    type = json['type'];
    status = json['status'];
    batch = json['batch'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id.toString();
    data['productCode'] = this.productCode;
    data['qty'] = this.qty;
    data['type'] = this.type;
    data['status'] = this.status;
    data['batch'] = this.batch;

    return data;
  }
}
