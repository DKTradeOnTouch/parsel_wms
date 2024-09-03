// To parse this JSON data, do
//
//     final despatchSummaryItem = despatchSummaryItemFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

DespatchSummaryItem despatchSummaryItemFromJson(String str) =>
    DespatchSummaryItem.fromJson(json.decode(str));

String despatchSummaryItemToJson(DespatchSummaryItem data) =>
    json.encode(data.toJson());

class DespatchSummaryItem {
  final String value;
  final String title;

  DespatchSummaryItem({
    required this.value,
    required this.title,
  });

  factory DespatchSummaryItem.fromJson(Map<String, dynamic> json) =>
      DespatchSummaryItem(
        value: json["value"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "value": value,
        "title": title,
      };
}
