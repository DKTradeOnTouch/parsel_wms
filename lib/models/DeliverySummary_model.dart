class DeliverySummary_model {
  String? salesOrderId;
  List<ItemList>? itemList;
  int? status;
  String? message;

  DeliverySummary_model(
      {this.salesOrderId, this.itemList, this.status, this.message});

  DeliverySummary_model.fromJson(Map<String, dynamic> json) {
    salesOrderId = json['salesOrderId'];
    if (json['itemList'] != null) {
      itemList = <ItemList>[];
      json['itemList'].forEach((v) {
        itemList!.add(new ItemList.fromJson(v));
      });
    }
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['salesOrderId'] = this.salesOrderId;
    if (this.itemList != null) {
      data['itemList'] = this.itemList!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}

class ItemList {
  int? delivered;
  int? returned;
  int? noOfBoxes;
  int? temperature;

  ItemList({this.delivered, this.returned, this.noOfBoxes, this.temperature});

  ItemList.fromJson(Map<String, dynamic> json) {
    delivered = json['delivered'];
    returned = json['returned'];
    noOfBoxes = json['noOfBoxes'];
    temperature = json['temperature'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['delivered'] = this.delivered;
    data['returned'] = this.returned;
    data['noOfBoxes'] = this.noOfBoxes;
    data['temperature'] = this.temperature;
    return data;
  }
}
