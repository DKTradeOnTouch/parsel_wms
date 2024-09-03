// To parse this JSON data, do
//
//     final userConfigurationModel = userConfigurationModelFromJson(jsonString);

import 'dart:convert';

UserConfigurationModel userConfigurationModelFromJson(String str) =>
    UserConfigurationModel.fromJson(json.decode(str));

String userConfigurationModelToJson(UserConfigurationModel data) =>
    json.encode(data.toJson());

class UserConfigurationModel {
  final bool status;
  final Data data;

  UserConfigurationModel({
    required this.status,
    required this.data,
  });

  UserConfigurationModel copyWith({
    bool? status,
    Data? data,
  }) =>
      UserConfigurationModel(
        status: status ?? this.status,
        data: data ?? this.data,
      );

  factory UserConfigurationModel.fromJson(Map<String, dynamic> json) =>
      UserConfigurationModel(
        status: json["status"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
      };
}

class Data {
  final int id;
  final String clientLogo;
  final String clientName;
  final String reassignStrategy;
  final String depotLatitude;
  final String depotLongitude;
  final bool enabledWms;
  final dynamic deletedAt;
  final String tempDriver;

  Data({
    required this.id,
    required this.clientLogo,
    required this.clientName,
    required this.reassignStrategy,
    required this.depotLatitude,
    required this.depotLongitude,
    required this.enabledWms,
    required this.deletedAt,
    required this.tempDriver,
  });

  Data copyWith({
    int? id,
    String? clientLogo,
    String? clientName,
    String? reassignStrategy,
    String? depotLatitude,
    String? depotLongitude,
    bool? enabledWms,
    dynamic deletedAt,
    dynamic tempDriver,
  }) =>
      Data(
        id: id ?? this.id,
        clientLogo: clientLogo ?? this.clientLogo,
        clientName: clientName ?? this.clientName,
        reassignStrategy: reassignStrategy ?? this.reassignStrategy,
        depotLatitude: depotLatitude ?? this.depotLatitude,
        depotLongitude: depotLongitude ?? this.depotLongitude,
        enabledWms: enabledWms ?? this.enabledWms,
        deletedAt: deletedAt ?? this.deletedAt,
        tempDriver: tempDriver ?? this.tempDriver,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        clientLogo: json["client_logo"],
        clientName: json["client_name"],
        reassignStrategy: json["reassign_strategy"],
        depotLatitude: json["depot_latitude"],
        depotLongitude: json["depot_longitude"],
        enabledWms: json["enabled_wms"],
        deletedAt: json["deleted_at"],
        tempDriver: json["temp_driver"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "client_logo": clientLogo,
        "client_name": clientName,
        "reassign_strategy": reassignStrategy,
        "depot_latitude": depotLatitude,
        "depot_longitude": depotLongitude,
        "enabled_wms": enabledWms,
        "deleted_at": deletedAt,
        "temp_driver": tempDriver,
      };
}
