// To parse this JSON data, do
//
//     final firebaseLocationLatLngModel = firebaseLocationLatLngModelFromJson(jsonString);

import 'dart:convert';

FirebaseLocationLatLngModel firebaseLocationLatLngModelFromJson(String str) =>
    FirebaseLocationLatLngModel.fromJson(json.decode(str));

String firebaseLocationLatLngModelToJson(FirebaseLocationLatLngModel data) =>
    json.encode(data.toJson());

class FirebaseLocationLatLngModel {
  final double lat;
  final double lon;
  final double heading;
  final String timestamp;

  FirebaseLocationLatLngModel({
    required this.lat,
    required this.lon,
    required this.heading,
    required this.timestamp,
  });

  factory FirebaseLocationLatLngModel.fromJson(Map<String, dynamic> json) =>
      FirebaseLocationLatLngModel(
        lat: json["lat"],
        lon: json["lon"],
        heading: json["heading"],
        timestamp: json["timestamp"],
      );

  Map<String, dynamic> toJson() => {
        "lat": lat,
        "lon": lon,
        "heading": heading,
        "timestamp": timestamp,
      };
}
