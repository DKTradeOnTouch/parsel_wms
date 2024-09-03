// To parse this JSON data, do
//
//     final updateStoreLocationModel = updateStoreLocationModelFromJson(jsonString);

import 'dart:convert';

UpdateStoreLocationModel updateStoreLocationModelFromJson(String str) =>
    UpdateStoreLocationModel.fromJson(json.decode(str));

String updateStoreLocationModelToJson(UpdateStoreLocationModel data) =>
    json.encode(data.toJson());

class UpdateStoreLocationModel {
  final bool status;
  final String message;

  UpdateStoreLocationModel({
    required this.status,
    required this.message,
  });

  UpdateStoreLocationModel copyWith({
    bool? status,
    String? message,
  }) =>
      UpdateStoreLocationModel(
        status: status ?? this.status,
        message: message ?? this.message,
      );

  factory UpdateStoreLocationModel.fromJson(Map<String, dynamic> json) =>
      UpdateStoreLocationModel(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
