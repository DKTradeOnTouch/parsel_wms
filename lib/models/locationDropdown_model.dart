class LocationDropDownModel {
  Data? data;
  String? message;
  int? status;

  LocationDropDownModel({this.data, this.message, this.status});

  LocationDropDownModel.fromJson(Map<String, dynamic> json) {
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
  List<ResultList>? resultList;
  int? totalCount;
  int? noOfItems;
  int? totalPages;

  Data({this.resultList, this.totalCount, this.noOfItems, this.totalPages});

  Data.fromJson(Map<String, dynamic> json) {
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
  int? id;
  String? binName;
  String? binLocation;
  String? warehouse;
  int? binCapacity;
  int? binVolume;
  String? productCode;
  String? barCodeId;
  int? createdOn;
  int? updatedOn;
  int? length;
  int? heigth;
  int? width;

  ResultList(
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

  ResultList.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['binName'] = this.binName;
    data['binLocation'] = this.binLocation;
    data['warehouse'] = this.warehouse;
    data['binCapacity'] = this.binCapacity;
    data['binVolume'] = this.binVolume;
    data['productCode'] = this.productCode;
    data['barCodeId'] = this.barCodeId;
    data['createdOn'] = this.createdOn;
    data['updatedOn'] = this.updatedOn;
    data['length'] = this.length;
    data['heigth'] = this.heigth;
    data['width'] = this.width;
    return data;
  }
}