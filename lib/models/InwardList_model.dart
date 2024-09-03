class InwardListModal {
  num? status;
  String? message;
  Body? body;

  InwardListModal({this.status, this.message, this.body});

  InwardListModal.fromJson(Map<String, dynamic> json) {
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
  List<ResultList>? resultList;
  num? totalCount;
  num? noOfItems;
  num? totalPages;

  PurchaseOrderList(
      {this.resultList, this.totalCount, this.noOfItems, this.totalPages});

  PurchaseOrderList.fromJson(Map<String, dynamic> json) {
    if (json['resultList'] != null) {
      resultList = <ResultList>[];
      json['resultList'].forEach((v) {
        resultList!.add(new ResultList.fromJson(v));
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

class ResultList {
  num? id;
  String? poId;
  String? assignedUser;
  List<num>? dateOfDelivery;
  String? status;
  num? updatedOn;
  num? createdOn;
  num? userId;
  List<ItemList>? itemList;
  // Null? assignedUserDetail;

  ResultList({
    this.id,
    this.poId,
    this.assignedUser,
    this.dateOfDelivery,
    this.status,
    this.updatedOn,
    this.createdOn,
    this.userId,
    this.itemList,
    // this.assignedUserDetail
  });

  ResultList.fromJson(Map<String, dynamic> json) {
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
    // assignedUserDetail = json['assignedUserDetail'];
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
    // data['assignedUserDetail'] = this.assignedUserDetail;
    return data;
  }
}

class ItemList {
  num? id;
  String? productCode;
  num? qty;
  String? type;
  String? status;
  SkuDetails? skuDetails;

  ItemList(
      {this.id,
      this.productCode,
      this.qty,
      this.type,
      this.status,
      this.skuDetails});

  ItemList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productCode = json['productCode'];
    qty = json['qty'];
    type = json['type'];
    status = json['status'];
    skuDetails = json['skuDetails'] != null
        ? new SkuDetails.fromJson(json['skuDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['productCode'] = this.productCode;
    data['qty'] = this.qty;
    data['type'] = this.type;
    data['status'] = this.status;
    if (this.skuDetails != null) {
      data['skuDetails'] = this.skuDetails!.toJson();
    }
    return data;
  }
}

class SkuDetails {
  num? id;
  String? name;
  String? code;
  num? height;
  num? width;
  num? length;
  double? value;
  String? barCodeId;
  num? weight;
  num? volume;
  num? createdOn;
  num? updatedOn;

  SkuDetails(
      {this.id,
      this.name,
      this.code,
      this.height,
      this.width,
      this.length,
      this.value,
      this.barCodeId,
      this.weight,
      this.volume,
      this.createdOn,
      this.updatedOn});

  SkuDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    height = json['height'];
    width = json['width'];
    length = json['length'];
    value = json['value'];
    barCodeId = json['barCodeId'];
    weight = json['weight'];
    volume = json['volume'];
    createdOn = json['createdOn'];
    updatedOn = json['updatedOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['code'] = this.code;
    data['height'] = this.height;
    data['width'] = this.width;
    data['length'] = this.length;
    data['value'] = this.value;
    data['barCodeId'] = this.barCodeId;
    data['weight'] = this.weight;
    data['volume'] = this.volume;
    data['createdOn'] = this.createdOn;
    data['updatedOn'] = this.updatedOn;
    return data;
  }
}
