class AddpickupQty {
  int? id;
  List<SalesOrders>? salesOrders;
  OrderedQuantities? orderedQuantities;
  OrderedQuantities? pickedQuantities;
  int? deliveryDriverId;
  String? creationTime;
  String? updatedOn;

  AddpickupQty(
      {this.id,
        this.salesOrders,
        this.orderedQuantities,
        this.pickedQuantities,
        this.deliveryDriverId,
        this.creationTime,
        this.updatedOn});

  AddpickupQty.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['salesOrders'] != null) {
      salesOrders = <SalesOrders>[];
      json['salesOrders'].forEach((v) {
        salesOrders!.add(new SalesOrders.fromJson(v));
      });
    }
    orderedQuantities = json['orderedQuantities'] != null
        ? new OrderedQuantities.fromJson(json['orderedQuantities'])
        : null;
    pickedQuantities = json['pickedQuantities'] != null
        ? new OrderedQuantities.fromJson(json['pickedQuantities'])
        : null;
    deliveryDriverId = json['deliveryDriverId'];
    creationTime = json['creationTime'];
    updatedOn = json['updatedOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.salesOrders != null) {
      data['salesOrders'] = this.salesOrders!.map((v) => v.toJson()).toList();
    }
    if (this.orderedQuantities != null) {
      data['orderedQuantities'] = this.orderedQuantities!.toJson();
    }
    if (this.pickedQuantities != null) {
      data['pickedQuantities'] = this.pickedQuantities!.toJson();
    }
    data['deliveryDriverId'] = this.deliveryDriverId;
    data['creationTime'] = this.creationTime;
    data['updatedOn'] = this.updatedOn;
    return data;
  }
}

class SalesOrders {
  int? id;
  String? salesOrderId;
  List<ItemList>? itemList;
  int? worker;
  String? creationTime;
  String? updatedOn;
  int? createdBy;
  Store? store;
  String? executionStatus;
  int? salesOrderValue;
  int? deliveryDriver;

  SalesOrders(
      {this.id,
        this.salesOrderId,
        this.itemList,
        this.worker,
        this.creationTime,
        this.updatedOn,
        this.createdBy,
        this.store,
        this.executionStatus,
        this.salesOrderValue,
        this.deliveryDriver});

  SalesOrders.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    salesOrderId = json['salesOrderId'];
    if (json['itemList'] != null) {
      itemList = <ItemList>[];
      json['itemList'].forEach((v) {
        itemList!.add(new ItemList.fromJson(v));
      });
    }
    worker = json['worker'];
    creationTime = json['creationTime'];
    updatedOn = json['updatedOn'];
    createdBy = json['createdBy'];
    store = json['store'] != null ? new Store.fromJson(json['store']) : null;
    executionStatus = json['executionStatus'];
    salesOrderValue = json['salesOrderValue'];
    deliveryDriver = json['deliveryDriver'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['salesOrderId'] = this.salesOrderId;
    if (this.itemList != null) {
      data['itemList'] = this.itemList!.map((v) => v.toJson()).toList();
    }
    data['worker'] = this.worker;
    data['creationTime'] = this.creationTime;
    data['updatedOn'] = this.updatedOn;
    data['createdBy'] = this.createdBy;
    if (this.store != null) {
      data['store'] = this.store!.toJson();
    }
    data['executionStatus'] = this.executionStatus;
    data['salesOrderValue'] = this.salesOrderValue;
    data['deliveryDriver'] = this.deliveryDriver;
    return data;
  }
}

class ItemList {
  int? id;
  String? productCode;
  String? productName;
  String? batch;
  String? aging;
  int? unitPrice;
  int? qty;
  int? totalPrice;
  String? creationTime;

  ItemList(
      {this.id,
        this.productCode,
        this.productName,
        this.batch,
        this.aging,
        this.unitPrice,
        this.qty,
        this.totalPrice,
        this.creationTime});

  ItemList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productCode = json['productCode'];
    productName = json['productName'];
    batch = json['batch'];
    aging = json['aging'];
    unitPrice = json['unitPrice'];
    qty = json['qty'];
    totalPrice = json['totalPrice'];
    creationTime = json['creationTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['productCode'] = this.productCode;
    data['productName'] = this.productName;
    data['batch'] = this.batch;
    data['aging'] = this.aging;
    data['unitPrice'] = this.unitPrice;
    data['qty'] = this.qty;
    data['totalPrice'] = this.totalPrice;
    data['creationTime'] = this.creationTime;
    return data;
  }
}

class Store {
  int? id;
  String? storeName;
  String? storeAddress;
  int? createdOn;
  int? updatedOn;
  Warehouse? warehouse;

  Store(
      {this.id,
        this.storeName,
        this.storeAddress,
        this.createdOn,
        this.updatedOn,
        this.warehouse});

  Store.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    storeName = json['storeName'];
    storeAddress = json['storeAddress'];
    createdOn = json['createdOn'];
    updatedOn = json['updatedOn'];
    warehouse = json['warehouse'] != null
        ? new Warehouse.fromJson(json['warehouse'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['storeName'] = this.storeName;
    data['storeAddress'] = this.storeAddress;
    data['createdOn'] = this.createdOn;
    data['updatedOn'] = this.updatedOn;
    if (this.warehouse != null) {
      data['warehouse'] = this.warehouse!.toJson();
    }
    return data;
  }
}

class Warehouse {
  int? id;
  String? warehouseId;
  String? wareHouseName;
  String? city;
  int? updatedOn;
  int? createdOn;

  Warehouse(
      {this.id,
        this.warehouseId,
        this.wareHouseName,
        this.city,
        this.updatedOn,
        this.createdOn});

  Warehouse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    warehouseId = json['warehouseId'];
    wareHouseName = json['wareHouseName'];
    city = json['city'];
    updatedOn = json['updatedOn'];
    createdOn = json['createdOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['warehouseId'] = this.warehouseId;
    data['wareHouseName'] = this.wareHouseName;
    data['city'] = this.city;
    data['updatedOn'] = this.updatedOn;
    data['createdOn'] = this.createdOn;
    return data;
  }
}

class OrderedQuantities {
  int? fM6T5;
  int? fM2L2;

  OrderedQuantities({this.fM6T5, this.fM2L2});

  OrderedQuantities.fromJson(Map<String, dynamic> json) {
    fM6T5 = json['FM6T5'];
    fM2L2 = json['FM2L2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['FM6T5'] = this.fM6T5;
    data['FM2L2'] = this.fM2L2;
    return data;
  }
}
