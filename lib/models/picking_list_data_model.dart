// To parse this JSON data, do
//
//     final pickingListDataModel = pickingListDataModelFromJson(jsonString);

import 'dart:convert';

PickingListDataModel pickingListDataModelFromJson(String str) =>
    PickingListDataModel.fromJson(json.decode(str));

String pickingListDataModelToJson(PickingListDataModel data) =>
    json.encode(data.toJson());

class PickingListDataModel {
  final bool status;
  final String message;
  final List<PickingData> pickingData;

  PickingListDataModel({
    required this.status,
    required this.message,
    required this.pickingData,
  });

  PickingListDataModel copyWith({
    bool? status,
    String? message,
    List<PickingData>? pickingData,
  }) =>
      PickingListDataModel(
        status: status ?? this.status,
        message: message ?? this.message,
        pickingData: pickingData ?? this.pickingData,
      );

  factory PickingListDataModel.fromJson(Map<String, dynamic> json) =>
      PickingListDataModel(
        status: json["status"],
        message: json["message"],
        pickingData: json.containsKey('data')
            ? List<PickingData>.from(
                json["data"].map((x) => PickingData.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(pickingData.map((x) => x.toJson())),
      };
}

class PickingData {
  final String worker;
  final String userId;
  final String skus;
  final String productId;
  final String soId;
  final String fromZone;
  final String fromRow;
  final String fromRack;

  PickingData({
    required this.worker,
    required this.userId,
    required this.skus,
    required this.productId,
    required this.soId,
    required this.fromZone,
    required this.fromRow,
    required this.fromRack,
  });

  PickingData copyWith({
    String? worker,
    String? userId,
    String? skus,
    String? productId,
    String? soId,
    String? fromZone,
    String? fromRow,
    String? fromRack,
  }) =>
      PickingData(
        worker: worker ?? this.worker,
        userId: userId ?? this.userId,
        skus: skus ?? this.skus,
        productId: productId ?? this.productId,
        soId: soId ?? this.soId,
        fromZone: fromZone ?? this.fromZone,
        fromRow: fromRow ?? this.fromRow,
        fromRack: fromRack ?? this.fromRack,
      );

  factory PickingData.fromJson(Map<String, dynamic> json) => PickingData(
        worker: json["worker"],
        userId: json["user_id"],
        skus: json["skus"],
        productId: json["product_id"],
        soId: json["so_id"],
        fromZone: json["from_zone"],
        fromRow: json["from_row"],
        fromRack: json["from_rack"],
      );

  Map<String, dynamic> toJson() => {
        "worker": worker,
        "user_id": userId,
        "skus": skus,
        "product_id": productId,
        "so_id": soId,
        "from_zone": fromZone,
        "from_row": fromRow,
        "from_rack": fromRack,
      };
}
