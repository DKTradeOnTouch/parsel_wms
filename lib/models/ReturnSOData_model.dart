class ReturnSODataModel {
  int? status;
  String? message;
  Body? body;

  ReturnSODataModel({this.status, this.message, this.body});

  ReturnSODataModel.fromJson(Map<String, dynamic> json) {
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
  List<ItemList>? itemList;

  Body({this.itemList});

  Body.fromJson(Map<String, dynamic> json) {
    if (json['itemList'] != null) {
      itemList = <ItemList>[];
      json['itemList'].forEach((v) {
        itemList!.add(new ItemList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.itemList != null) {
      data['itemList'] = this.itemList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ItemList {
  String? id;
  String? reason;
  int? returned;

  ItemList({this.id, this.reason, this.returned});

  ItemList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    reason = json['reason'];
    returned = json['returned'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['reason'] = this.reason;
    data['returned'] = this.returned;
    return data;
  }
}