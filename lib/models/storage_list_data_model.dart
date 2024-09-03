// To parse this JSON data, do
//
//     final storageListData = storageListDataFromJson(jsonString);

import 'dart:convert';

StorageListData storageListDataFromJson(String str) =>
    StorageListData.fromJson(json.decode(str));

String storageListDataToJson(StorageListData data) =>
    json.encode(data.toJson());

class StorageListData {
  final bool status;
  final String message;
  final List<StorageData> storageData;

  StorageListData({
    required this.status,
    required this.message,
    required this.storageData,
  });

  StorageListData copyWith({
    bool? status,
    String? message,
    List<StorageData>? storageData,
  }) =>
      StorageListData(
        status: status ?? this.status,
        message: message ?? this.message,
        storageData: storageData ?? this.storageData,
      );

  factory StorageListData.fromJson(Map<String, dynamic> json) =>
      StorageListData(
        status: json["status"],
        message: json["message"],
        storageData: json.containsKey('data')
            ? List<StorageData>.from(
                json["data"].map((x) => StorageData.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(storageData.map((x) => x.toJson())),
      };
}

class StorageData {
  final String worker;
  final String userId;
  final String skus;
  final String productId;
  final String poId;
  final String fromZone;
  final String fromRow;
  final String fromRack;
  final String toZone;
  final String toRow;
  final String toRack;

  StorageData({
    required this.worker,
    required this.userId,
    required this.skus,
    required this.productId,
    required this.poId,
    required this.fromZone,
    required this.fromRow,
    required this.fromRack,
    required this.toZone,
    required this.toRow,
    required this.toRack,
  });

  StorageData copyWith({
    String? worker,
    String? userId,
    String? skus,
    String? productId,
    String? poId,
    String? fromZone,
    String? fromRow,
    String? fromRack,
    String? toZone,
    String? toRow,
    String? toRack,
  }) =>
      StorageData(
        worker: worker ?? this.worker,
        userId: userId ?? this.userId,
        skus: skus ?? this.skus,
        productId: productId ?? this.productId,
        poId: poId ?? this.poId,
        fromZone: fromZone ?? this.fromZone,
        fromRow: fromRow ?? this.fromRow,
        fromRack: fromRack ?? this.fromRack,
        toZone: toZone ?? this.toZone,
        toRow: toRow ?? this.toRow,
        toRack: toRack ?? this.toRack,
      );

  factory StorageData.fromJson(Map<String, dynamic> json) => StorageData(
        worker: json["worker"],
        userId: json["user_id"],
        skus: json["skus"],
        productId: json["product_id"],
        poId: json["po_id"],
        fromZone: json["from_zone"],
        fromRow: json["from_row"],
        fromRack: json["from_rack"],
        toZone: json["to_zone"],
        toRow: json["to_row"],
        toRack: json["to_rack"],
      );

  Map<String, dynamic> toJson() => {
        "worker": worker,
        "user_id": userId,
        "skus": skus,
        "product_id": productId,
        "po_id": poId,
        "from_zone": fromZone,
        "from_row": fromRow,
        "from_rack": fromRack,
        "to_zone": toZone,
        "to_row": toRow,
        "to_rack": toRack,
      };
}
