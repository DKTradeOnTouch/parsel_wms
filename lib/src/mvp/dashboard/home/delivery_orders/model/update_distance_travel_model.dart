// To parse this JSON data, do
//
//     final pickingListDataModel = pickingListDataModelFromJson(jsonString);

import 'dart:convert';

UpdateDistanceTravelModel updateDistanceTravelModelFromJson(String str) =>
    UpdateDistanceTravelModel.fromJson(json.decode(str));

String pickingListDataModelToJson(UpdateDistanceTravelModel data) =>
    json.encode(data.toJson());

class UpdateDistanceTravelModel {
  final bool status;
  final Tasks tasks;

  UpdateDistanceTravelModel({
    required this.status,
    required this.tasks,
  });

  UpdateDistanceTravelModel copyWith({
    bool? status,
    Tasks? tasks,
  }) =>
      UpdateDistanceTravelModel(
        status: status ?? this.status,
        tasks: tasks ?? this.tasks,
      );

  factory UpdateDistanceTravelModel.fromJson(Map<String, dynamic> json) =>
      UpdateDistanceTravelModel(
        status: json["status"],
        tasks: Tasks.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": tasks.toJson(),
      };
}

class Tasks {
  final String taskId;
  final String taskName;

  Tasks({
    required this.taskId,
    required this.taskName,
  });

  Tasks copyWith({
    String? taskId,
    String? taskName,
  }) =>
      Tasks(
        taskId: taskId ?? this.taskId,
        taskName: taskName ?? this.taskName,
      );

  factory Tasks.fromJson(Map<String, dynamic> json) => Tasks(
        taskId: json["task_id"],
        taskName: json["task_name"],
      );

  Map<String, dynamic> toJson() => {
        "task_id": taskId,
        "task_name": taskName,
      };
}
