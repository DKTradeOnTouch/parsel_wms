// To parse this JSON data, do
//
//     final despatchSummaryDetails = despatchSummaryDetailsFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

DespatchSummaryDetails despatchSummaryDetailsFromJson(String str) =>
    DespatchSummaryDetails.fromJson(json.decode(str));

String despatchSummaryDetailsToJson(DespatchSummaryDetails data) =>
    json.encode(data.toJson());

class DespatchSummaryDetails {
  final String driverName;
  final String managerName;
  final String deliveryTime;
  final String skuQtyCount;
  final String noOfParcel;
  final String deliveryPoint;
  final int skuCount;
  final String temp;
  final String docTime;
  final String photoUrl;

  DespatchSummaryDetails({
    required this.driverName,
    required this.managerName,
    required this.deliveryTime,
    required this.skuQtyCount,
    required this.noOfParcel,
    required this.deliveryPoint,
    required this.skuCount,
    required this.temp,
    required this.docTime,
    required this.photoUrl,
  });

  factory DespatchSummaryDetails.fromJson(Map<String, dynamic> json) =>
      DespatchSummaryDetails(
        driverName: json["driverName"],
        managerName: json["managerName"],
        deliveryTime: json["deliveryTime"],
        skuQtyCount: json["skuQtyCount"],
        noOfParcel: json["noOfParcel"],
        deliveryPoint: json["deliveryPoint"],
        skuCount: json["skuCount"],
        temp: json["temp"],
        docTime: json["docTime"],
        photoUrl: json["photoUrl"],
      );

  Map<String, dynamic> toJson() => {
        "driverName": driverName,
        "managerName": managerName,
        "deliveryTime": deliveryTime,
        "skuQtyCount": skuQtyCount,
        "noOfParcel": noOfParcel,
        "deliveryPoint": deliveryPoint,
        "skuCount": skuCount,
        "temp": temp,
        "docTime": docTime,
        "photoUrl": photoUrl,
      };
}
