class CountPendingModel {
  int? status;
  String? message;
  Body? body;

  CountPendingModel({this.status, this.message, this.body});

  CountPendingModel.fromJson(Map<String, dynamic> json) {
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
  Data? data;

  Body({this.data});

  Body.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? totalCount;
  int? noOfItems;
  int? totalPages;

  Data({this.totalCount, this.noOfItems, this.totalPages});

  Data.fromJson(Map<String, dynamic> json) {
    totalCount = json['totalCount'];
    noOfItems = json['noOfItems'];
    totalPages = json['totalPages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalCount'] = this.totalCount;
    data['noOfItems'] = this.noOfItems;
    data['totalPages'] = this.totalPages;
    return data;
  }
}