class CreatePayment_Model {
  String? status;
  String? message;
  Body? body;

  CreatePayment_Model({this.status, this.message, this.body});

  CreatePayment_Model.fromJson(Map<String, dynamic> json) {
    status = json['status'].toString();
    message = json['message'];
    body = json['body'] != null ? new Body.fromJson(json['body']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status.toString();
    data['message'] = this.message;
    if (this.body != null) {
      data['body'] = this.body!.toJson();
    }
    return data;
  }
}

class Body {
  List<Data>? data;

  Body({this.data});

  Body.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  String? creationTime;
  String? paymentType;
  String? value;
  String? paymentRemark;
  String? paymentDate;
  String? chequeType;
  String? status;

  Data({
    this.id,
    this.creationTime,
    this.paymentType,
    this.value,
    this.paymentRemark,
    this.paymentDate,
    this.chequeType,
    this.status,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    creationTime = json['creationTime'];
    paymentType = json['paymentType'];
    value = json['value'].toString();
    paymentRemark = json['paymentRemark'];
    paymentDate = json['paymentDate'];
    chequeType = json['chequeType'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['creationTime'] = this.creationTime;
    data['paymentType'] = this.paymentType;
    data['value'] = this.value.toString();
    data['paymentRemark'] = this.paymentRemark;
    data['paymentDate'] = this.paymentDate;
    data['chequeType'] = this.chequeType;
    data['status'] = this.status;

    return data;
  }
}
