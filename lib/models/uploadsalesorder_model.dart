class uploadsalesorder_model {
  String? executionStatus;
  List<ItemList>? itemList;

  uploadsalesorder_model({this.executionStatus, this.itemList});

  uploadsalesorder_model.fromJson(Map<String, dynamic> json) {
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
      this.returnReason = 'Reason 1'});

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
