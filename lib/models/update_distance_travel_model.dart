// To parse this JSON data, do
//
//     final updateDistanceTravelModel = updateDistanceTravelModelFromJson(jsonString);

import 'dart:convert';

UpdateDistanceTravelModel updateDistanceTravelModelFromJson(String str) =>
    UpdateDistanceTravelModel.fromJson(json.decode(str));

String updateDistanceTravelModelToJson(UpdateDistanceTravelModel data) =>
    json.encode(data.toJson());

class UpdateDistanceTravelModel {
  final bool status;
  final Data data;

  UpdateDistanceTravelModel({
    required this.status,
    required this.data,
  });

  factory UpdateDistanceTravelModel.fromJson(Map<String, dynamic> json) =>
      UpdateDistanceTravelModel(
        status: json["status"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
      };
}

class Data {
  final String taskId;
  final String taskName;

  Data({
    required this.taskId,
    required this.taskName,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        taskId: json["task_id"],
        taskName: json["task_name"],
      );

  Map<String, dynamic> toJson() => {
        "task_id": taskId,
        "task_name": taskName,
      };
}
