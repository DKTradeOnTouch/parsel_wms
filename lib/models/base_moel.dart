// To parse this JSON data, do
//
//     final baseModel = baseModelFromJson(jsonString);

import 'dart:convert';

BaseModel baseModelFromJson(String str) => BaseModel.fromJson(json.decode(str));

String baseModelToJson(BaseModel data) => json.encode(data.toJson());

class BaseModel {
  final bool status;
  final String message;

  BaseModel({
    required this.status,
    required this.message,
  });

  BaseModel copyWith({
    bool? status,
    String? message,
  }) =>
      BaseModel(
        status: status ?? this.status,
        message: message ?? this.message,
      );

  factory BaseModel.fromJson(Map<String, dynamic> json) => BaseModel(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
