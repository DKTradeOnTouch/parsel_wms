// To parse this JSON data, do
//
//     final parselBaseModel = parselBaseModelFromJson(jsonString);

import 'dart:convert';

ParselBaseModel parselBaseModelFromJson(String str) =>
    ParselBaseModel.fromJson(json.decode(str));

String parselBaseModelToJson(ParselBaseModel data) =>
    json.encode(data.toJson());

class ParselBaseModel {
  final bool status;
  final String message;

  ParselBaseModel({
    required this.status,
    required this.message,
  });

  ParselBaseModel copyWith({
    bool? status,
    String? message,
  }) =>
      ParselBaseModel(
        status: status ?? this.status,
        message: message ?? this.message,
      );

  factory ParselBaseModel.fromJson(Map<String, dynamic> json) =>
      ParselBaseModel(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
