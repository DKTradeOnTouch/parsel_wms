class UpdateSalesOrderMODAL {
  int? status;
  String? message;
  Body? body;

  UpdateSalesOrderMODAL({this.status, this.message, this.body});

  UpdateSalesOrderMODAL.fromJson(Map<String, dynamic> json) {
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
  String? executionStatus;
  List<ItemList>? itemList;

  Body({this.executionStatus, this.itemList});

  Body.fromJson(Map<String, dynamic> json) {
    executionStatus = json['executionStatus'];
    if (json['itemList'] != null) {
      itemList = <ItemList>[];
      json['itemList'].forEach((v) {
        itemList!.add(new ItemList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['executionStatus'] = this.executionStatus;
    if (this.itemList != null) {
      data['itemList'] = this.itemList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ItemList {
  String? productCode;
  int? qty;
  int? delivered;
  int? returned;
  String? returnReason;

  ItemList(
      {this.productCode,
      this.qty,
      this.delivered,
      this.returned,
      this.returnReason});

  ItemList.fromJson(Map<String, dynamic> json) {
    productCode = json['productCode'];
    qty = json['qty'];
    delivered = json['delivered'];
    returned = json['returned'];
    returnReason = json['returnReason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productCode'] = this.productCode;
    data['qty'] = this.qty;
    data['delivered'] = this.delivered;
    data['returned'] = this.returned;
    data['returnReason'] = this.returnReason;
    return data;
  }
}