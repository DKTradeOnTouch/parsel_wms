// To parse this JSON data, do
//
//     final prefsApiModel = prefsApiModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

PrefsApiModel prefsApiModelFromJson(String str) =>
    PrefsApiModel.fromJson(json.decode(str));

String prefsApiModelToJson(PrefsApiModel data) => json.encode(data.toJson());

class PrefsApiModel {
  final String groupId;
  final int noOfBox;
  final int temperature;
  final String ifile;

  PrefsApiModel({
    required this.groupId,
    required this.noOfBox,
    required this.temperature,
    required this.ifile,
  });

  factory PrefsApiModel.fromJson(Map<String, dynamic> json) => PrefsApiModel(
        groupId: json["group_id"],
        noOfBox: json["no_of_box"],
        temperature: json["temperature"],
        ifile: json["Ifile"],
      );

  Map<String, dynamic> toJson() => {
        "group_id": groupId,
        "no_of_box": noOfBox,
        "temperature": temperature,
        "Ifile": ifile,
      };
}
