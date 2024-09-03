class StorageModal {
  num? status;
  String? message;
  Body? body;

  StorageModal({this.status, this.message, this.body});

  StorageModal.fromJson(Map<String, dynamic> json) {
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
  PurchaseOrderList? purchaseOrderList;

  Body({this.purchaseOrderList});

  Body.fromJson(Map<String, dynamic> json) {
    purchaseOrderList = json['purchaseOrderList'] != null
        ? PurchaseOrderList.fromJson(json['purchaseOrderList'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (purchaseOrderList != null) {
      data['purchaseOrderList'] = purchaseOrderList!.toJson();
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
        resultList!.add(ResultList.fromJson(v));
      });
    }
    totalCount = json['totalCount'];
    noOfItems = json['noOfItems'];
    totalPages = json['totalPages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (resultList != null) {
      data['resultList'] = resultList!.map((v) => v.toJson()).toList();
    }
    data['totalCount'] = totalCount;
    data['noOfItems'] = noOfItems;
    data['totalPages'] = totalPages;
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

  ResultList(
      {this.id,
      this.poId,
      this.assignedUser,
      this.dateOfDelivery,
      this.status,
      this.updatedOn,
      this.createdOn,
      this.userId,
      this.itemList});

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
  num? id;
  String? productCode;
  num? qty;
  String? type;
  BinMaster? binMaster;
  String? status;
  String? batch;
  // List<num>? aging;
  // Category? category;
  SkuDetails? skuDetails;

  ItemList(
      {this.id,
      this.productCode,
      this.qty,
      this.type,
      this.binMaster,
      this.status,
      this.batch,
      // this.aging,
      // this.category,
      this.skuDetails});

  ItemList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productCode = json['productCode'];
    qty = json['qty'];
    type = json['type'];
    binMaster = json['binMaster'] != null
        ? BinMaster.fromJson(json['binMaster'])
        : null;
    status = json['status'];
    batch = json['batch'];
    // aging = json['aging'].cast<num>();
    // category = json['category'] != null
    //     ? new Category.fromJson(json['category'])
    //     : null;
    skuDetails = json['skuDetails'] != null
        ? SkuDetails.fromJson(json['skuDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['productCode'] = productCode;
    data['qty'] = qty;
    data['type'] = type;
    if (binMaster != null) {
      data['binMaster'] = binMaster!.toJson();
    }
    data['status'] = status;
    data['batch'] = batch;
    // data['aging'] = this.aging;
    // if (this.category != null) {
    //   data['category'] = this.category!.toJson();
    // }
    if (skuDetails != null) {
      data['skuDetails'] = skuDetails!.toJson();
    }
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['binName'] = binName;
    data['binLocation'] = binLocation;
    data['warehouse'] = warehouse;
    data['binCapacity'] = binCapacity;
    data['binVolume'] = binVolume;
    data['productCode'] = productCode;
    data['barCodeId'] = barCodeId;
    data['createdOn'] = createdOn;
    data['updatedOn'] = updatedOn;
    data['length'] = length;
    data['heigth'] = heigth;
    data['width'] = width;
    return data;
  }
}

class Category {
  num? id;
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
  num? id;
  String? name;
  num? createdOn;
  num? updatedOn;
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

class SkuDetails {
  num? id;
  String? name;
  String? code;
  // Null? color;
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
      // this.color,
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
    // color = json['color'];
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['code'] = code;
    // data['color'] = this.color;
    data['height'] = height;
    data['width'] = width;
    data['length'] = length;
    data['value'] = value;
    data['barCodeId'] = barCodeId;
    data['weight'] = weight;
    data['volume'] = volume;
    data['createdOn'] = createdOn;
    data['updatedOn'] = updatedOn;
    return data;
  }
}
