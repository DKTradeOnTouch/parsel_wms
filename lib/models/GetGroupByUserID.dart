// To parse this JSON data, do
//
//     final GetGroupByUserIDModel = GetGroupByUserIDModelFromJson(jsonString);

import 'dart:convert';

GetGroupByUserIDModel getGroupByUserIDModelFromJson(String str) =>
    GetGroupByUserIDModel.fromJson(json.decode(str));

String getGroupByUserIDModelToJson(GetGroupByUserIDModel data) => json.encode(data.toJson());

class GetGroupByUserIDModel {
  final bool status;
  final String message;
  final Body body;

  GetGroupByUserIDModel({
    required this.status,
    required this.message,
    required this.body,
  });

  GetGroupByUserIDModel copyWith({
    bool? status,
    String? message,
    Body? body,
  }) =>
      GetGroupByUserIDModel(
        status: status ?? this.status,
        message: message ?? this.message,
        body: body ?? this.body,
      );

  factory GetGroupByUserIDModel.fromJson(Map<String, dynamic> json) => GetGroupByUserIDModel(
        status: json["status"],
        message: json["message"],
        body: Body.fromJson(json["body"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "body": body.toJson(),
      };
}

class Body {
  final Data data;

  Body({
    required this.data,
  });

  Body copyWith({
    Data? data,
  }) =>
      Body(
        data: data ?? this.data,
      );

  factory Body.fromJson(Map<String, dynamic> json) => Body(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class Data {
  final int id;
  final double collectedCash;
  final double collectedChange;
  final String createdByUser;
  final DateTime createdTime;
  final dynamic debitToUserId;
  final String docs;
  final int noOfBoxes;
  final int openingBalance;
  final String optimizedRouteForso;
  final String route;
  final String status;
  final double temperature;
  final DateTime updatedOn;
  final String userId;
  final String vehicleNo;
  final dynamic closingBalance;
  final Map<String, int> orderedQuantities;
  final Map<String, int> pickedQuantities;
  final List<SkuDetails> skuDetails;
  final ExtraInfo extraInfo;
  final UserDetails userDetails;

  Data({
    required this.id,
    required this.collectedCash,
    required this.collectedChange,
    required this.createdByUser,
    required this.createdTime,
    required this.debitToUserId,
    required this.docs,
    required this.noOfBoxes,
    required this.openingBalance,
    required this.optimizedRouteForso,
    required this.route,
    required this.status,
    required this.temperature,
    required this.updatedOn,
    required this.userId,
    required this.vehicleNo,
    required this.closingBalance,
    required this.orderedQuantities,
    required this.pickedQuantities,
    required this.skuDetails,
    required this.extraInfo,
    required this.userDetails,
  });

  Data copyWith({
    int? id,
    double? collectedCash,
    double? collectedChange,
    String? createdByUser,
    DateTime? createdTime,
    dynamic debitToUserId,
    String? docs,
    int? noOfBoxes,
    int? openingBalance,
    String? optimizedRouteForso,
    String? route,
    String? status,
    double? temperature,
    DateTime? updatedOn,
    String? userId,
    String? vehicleNo,
    dynamic closingBalance,
    Map<String, int>? orderedQuantities,
    Map<String, int>? pickedQuantities,
    List<SkuDetails>? skuDetails,
    ExtraInfo? extraInfo,
    UserDetails? userDetails,
  }) =>
      Data(
        id: id ?? this.id,
        collectedCash: collectedCash ?? this.collectedCash,
        collectedChange: collectedChange ?? this.collectedChange,
        createdByUser: createdByUser ?? this.createdByUser,
        createdTime: createdTime ?? this.createdTime,
        debitToUserId: debitToUserId ?? this.debitToUserId,
        docs: docs ?? this.docs,
        noOfBoxes: noOfBoxes ?? this.noOfBoxes,
        openingBalance: openingBalance ?? this.openingBalance,
        optimizedRouteForso: optimizedRouteForso ?? this.optimizedRouteForso,
        route: route ?? this.route,
        status: status ?? this.status,
        temperature: temperature ?? this.temperature,
        updatedOn: updatedOn ?? this.updatedOn,
        userId: userId ?? this.userId,
        vehicleNo: vehicleNo ?? this.vehicleNo,
        closingBalance: closingBalance ?? this.closingBalance,
        orderedQuantities: orderedQuantities ?? this.orderedQuantities,
        pickedQuantities: pickedQuantities ?? this.pickedQuantities,
        skuDetails: skuDetails ?? this.skuDetails,
        extraInfo: extraInfo ?? this.extraInfo,
        userDetails: userDetails ?? this.userDetails,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        collectedCash: json["collected_cash"],
        collectedChange: json["collected_change"],
        createdByUser: json["created_by_user"],
        createdTime: DateTime.parse(json["created_time"]),
        debitToUserId: json["debit_to_user_id"],
        docs: json["docs"],
        noOfBoxes: json["no_of_boxes"],
        openingBalance: json["opening_balance"],
        optimizedRouteForso: json["optimized_route_forso"],
        route: json["route"],
        status: json["status"],
        temperature: json["temperature"],
        updatedOn: DateTime.parse(json["updated_on"]),
        userId: json["user_id"],
        vehicleNo: json["vehicle_no"],
        closingBalance: json["closing_balance"],
        orderedQuantities: Map.from(json["ordered_quantities"])
            .map((k, v) => MapEntry<String, int>(k, v)),
        pickedQuantities: Map.from(json["picked_quantities"])
            .map((k, v) => MapEntry<String, int>(k, v)),
        skuDetails: List<SkuDetails>.from(
            json["sku_details"].map((x) => SkuDetails.fromJson(x))),
        extraInfo: ExtraInfo.fromJson(json["extra_info"]),
        userDetails: UserDetails.fromJson(json["user_details"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "collected_cash": collectedCash,
        "collected_change": collectedChange,
        "created_by_user": createdByUser,
        "created_time": createdTime.toIso8601String(),
        "debit_to_user_id": debitToUserId,
        "docs": docs,
        "no_of_boxes": noOfBoxes,
        "opening_balance": openingBalance,
        "optimized_route_forso": optimizedRouteForso,
        "route": route,
        "status": status,
        "temperature": temperature,
        "updated_on": updatedOn.toIso8601String(),
        "user_id": userId,
        "vehicle_no": vehicleNo,
        "closing_balance": closingBalance,
        "ordered_quantities": Map.from(orderedQuantities)
            .map((k, v) => MapEntry<String, dynamic>(k, v)),
        "picked_quantities": Map.from(pickedQuantities)
            .map((k, v) => MapEntry<String, dynamic>(k, v)),
        "sku_details": List<dynamic>.from(skuDetails.map((x) => x.toJson())),
        "extra_info": extraInfo.toJson(),
        "user_details": userDetails.toJson(),
      };
}

class ExtraInfo {
  final int salesOrderCount;

  ExtraInfo({
    required this.salesOrderCount,
  });

  ExtraInfo copyWith({
    int? salesOrderCount,
  }) =>
      ExtraInfo(
        salesOrderCount: salesOrderCount ?? this.salesOrderCount,
      );

  factory ExtraInfo.fromJson(Map<String, dynamic> json) => ExtraInfo(
        salesOrderCount: json["salesOrderCount"],
      );

  Map<String, dynamic> toJson() => {
        "salesOrderCount": salesOrderCount,
      };
}

class SkuDetails {
  final String skuName;
  final int qty;
  final double totalPrice;
  final double unitPrice;

  SkuDetails({
    required this.skuName,
    required this.qty,
    required this.totalPrice,
    required this.unitPrice,
  });

  SkuDetails copyWith({
    String? skuName,
    int? qty,
    double? totalPrice,
    double? unitPrice,
  }) =>
      SkuDetails(
        skuName: skuName ?? this.skuName,
        qty: qty ?? this.qty,
        totalPrice: totalPrice ?? this.totalPrice,
        unitPrice: unitPrice ?? this.unitPrice,
      );

  factory SkuDetails.fromJson(Map<String, dynamic> json) => SkuDetails(
        skuName: json["sku_name"],
        qty: json["qty"],
        totalPrice: json["total_price"]?.toDouble(),
        unitPrice: json["unit_price"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "sku_name": skuName,
        "qty": qty,
        "total_price": totalPrice,
        "unit_price": unitPrice,
      };
}

class UserDetails {
  final String id;
  final String username;

  UserDetails({
    required this.id,
    required this.username,
  });

  UserDetails copyWith({
    String? id,
    String? username,
  }) =>
      UserDetails(
        id: id ?? this.id,
        username: username ?? this.username,
      );

  factory UserDetails.fromJson(Map<String, dynamic> json) => UserDetails(
        id: json["id"],
        username: json["username"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
      };
}
