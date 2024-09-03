// To parse this JSON data, do
//
//     final getSkuGroupByUserIdModel = getSkuGroupByUserIdModelFromJson(jsonString);

import 'dart:convert';

GetSkuGroupByUserIdModel getSkuGroupByUserIdModelFromJson(String str) =>
    GetSkuGroupByUserIdModel.fromJson(json.decode(str));

String getSkuGroupByUserIdModelToJson(GetSkuGroupByUserIdModel data) =>
    json.encode(data.toJson());

class GetSkuGroupByUserIdModel {
  final bool status;
  final String message;
  final GetSkuGroupBody body;

  GetSkuGroupByUserIdModel({
    required this.status,
    required this.message,
    required this.body,
  });

  GetSkuGroupByUserIdModel copyWith({
    bool? status,
    String? message,
    GetSkuGroupBody? body,
  }) =>
      GetSkuGroupByUserIdModel(
        status: status ?? this.status,
        message: message ?? this.message,
        body: body ?? this.body,
      );

  factory GetSkuGroupByUserIdModel.fromJson(Map<String, dynamic> json) =>
      GetSkuGroupByUserIdModel(
        status: json["status"],
        message: json["message"],
        body: GetSkuGroupBody.fromJson(json["body"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "body": body.toJson(),
      };
}

class GetSkuGroupBody {
  final GetSkuGroupData data;

  GetSkuGroupBody({
    required this.data,
  });

  GetSkuGroupBody copyWith({
    GetSkuGroupData? data,
  }) =>
      GetSkuGroupBody(
        data: data ?? this.data,
      );

  factory GetSkuGroupBody.fromJson(Map<String, dynamic> json) =>
      GetSkuGroupBody(
        data: GetSkuGroupData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class GetSkuGroupData {
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
  final List<SkuDetail> skuDetails;
  final ExtraInfo extraInfo;
  final UserDetails userDetails;
  GetSkuGroupData({
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

  GetSkuGroupData copyWith({
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
    List<SkuDetail>? skuDetails,
    ExtraInfo? extraInfo,
    UserDetails? userDetails,
  }) =>
      GetSkuGroupData(
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

  factory GetSkuGroupData.fromJson(Map<String, dynamic> json) =>
      GetSkuGroupData(
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
        skuDetails: List<SkuDetail>.from(
            json["sku_details"].map((x) => SkuDetail.fromJson(x))),
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

class SkuDetail {
  final String skuName;
  int qty;
  final double totalPrice;
  final double unitPrice;
  bool isItemSelected;

  SkuDetail({
    required this.skuName,
    required this.qty,
    required this.totalPrice,
    required this.unitPrice,
    this.isItemSelected = false,
  });

  SkuDetail copyWith({
    String? skuName,
    int? qty,
    double? totalPrice,
    double? unitPrice,
  }) =>
      SkuDetail(
        skuName: skuName ?? this.skuName,
        qty: qty ?? this.qty,
        totalPrice: totalPrice ?? this.totalPrice,
        unitPrice: unitPrice ?? this.unitPrice,
      );

  factory SkuDetail.fromJson(Map<String, dynamic> json) => SkuDetail(
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
