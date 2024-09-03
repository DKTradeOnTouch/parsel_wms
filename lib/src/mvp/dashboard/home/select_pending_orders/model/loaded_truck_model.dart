// To parse this JSON data, do
//
//     final loadedTruckModel = loadedTruckModelFromJson(jsonString);

import 'dart:convert';

LoadedTruckModel loadedTruckModelFromJson(String str) =>
    LoadedTruckModel.fromJson(json.decode(str));

String loadedTruckModelToJson(LoadedTruckModel data) =>
    json.encode(data.toJson());

class LoadedTruckModel {
  final bool status;
  final String message;
  final TruckData data;

  LoadedTruckModel({
    required this.status,
    required this.message,
    required this.data,
  });

  LoadedTruckModel copyWith({
    bool? status,
    String? message,
    TruckData? data,
  }) =>
      LoadedTruckModel(
        status: status ?? this.status,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory LoadedTruckModel.fromJson(Map<String, dynamic> json) =>
      LoadedTruckModel(
        status: json["status"],
        message: json["message"],
        data: TruckData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
      };
}

class TruckData {
  final String vehicleNumber;
  final String weightMeta;
  final List<Compartment> compartments;

  TruckData({
    required this.vehicleNumber,
    required this.weightMeta,
    required this.compartments,
  });

  TruckData copyWith({
    String? vehicleNumber,
    String? weightMeta,
    List<Compartment>? compartments,
  }) =>
      TruckData(
        vehicleNumber: vehicleNumber ?? this.vehicleNumber,
        weightMeta: weightMeta ?? this.weightMeta,
        compartments: compartments ?? this.compartments,
      );

  factory TruckData.fromJson(Map<String, dynamic> json) => TruckData(
        vehicleNumber: json["vehicle_number"],
        weightMeta: json["weight_meta"],
        compartments: List<Compartment>.from(
            json["compartments"].map((x) => Compartment.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "vehicle_number": vehicleNumber,
        "weight_meta": weightMeta,
        "compartments": List<dynamic>.from(compartments.map((x) => x.toJson())),
      };
}

class Compartment {
  final int allocatedSpacePct;

  Compartment({
    required this.allocatedSpacePct,
  });

  Compartment copyWith({
    int? allocatedSpacePct,
  }) =>
      Compartment(
        allocatedSpacePct: allocatedSpacePct ?? this.allocatedSpacePct,
      );

  factory Compartment.fromJson(Map<String, dynamic> json) => Compartment(
        allocatedSpacePct: json["allocated_space_pct"],
      );

  Map<String, dynamic> toJson() => {
        "allocated_space_pct": allocatedSpacePct,
      };
}
