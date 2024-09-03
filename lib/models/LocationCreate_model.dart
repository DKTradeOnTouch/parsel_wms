class LocationCreate_model {
  Data? data;
  String? message;
  int? status;

  LocationCreate_model({this.data, this.message, this.status});

  LocationCreate_model.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}

class Data {
  int? id;
  String? salesOrderId;
  String? deliveryDriverId;
  double? latitude;
  double? longitude;
  String? createdOn;
  List<int>? updatedOn;

  Data(
      {this.id,
        this.salesOrderId,
        this.deliveryDriverId,
        this.latitude,
        this.longitude,
        this.createdOn,
        this.updatedOn});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    salesOrderId = json['salesOrderId'];
    deliveryDriverId = json['deliveryDriverId'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    createdOn = json['createdOn'];
    updatedOn = json['updatedOn'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['salesOrderId'] = this.salesOrderId;
    data['deliveryDriverId'] = this.deliveryDriverId;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['createdOn'] = this.createdOn;
    data['updatedOn'] = this.updatedOn;
    return data;
  }
}
