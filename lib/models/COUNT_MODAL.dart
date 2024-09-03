// To parse this JSON data, do
//
//     final countApiModalNew = countApiModalNewFromJson(jsonString);

import 'dart:convert';

CountApiModalNew countApiModalNewFromJson(String str) =>
    CountApiModalNew.fromJson(json.decode(str));

String countApiModalNewToJson(CountApiModalNew data) =>
    json.encode(data.toJson());

class CountApiModalNew {
  final bool status;
  final String message;
  final Body body;

  CountApiModalNew({
    required this.status,
    required this.message,
    required this.body,
  });

  CountApiModalNew copyWith({
    bool? status,
    String? message,
    Body? body,
  }) =>
      CountApiModalNew(
        status: status ?? this.status,
        message: message ?? this.message,
        body: body ?? this.body,
      );

  factory CountApiModalNew.fromJson(Map<String, dynamic> json) =>
      CountApiModalNew(
        status: json["status"],
        message: json["message"],
        body: Body.fromJson(json["body"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "body": body.toJson(),
      };
}

class Body {
  final int inGroup;
  final int onGoing;
  final int delivered;

  Body({
    required this.inGroup,
    required this.onGoing,
    required this.delivered,
  });

  Body copyWith({
    int? inGroup,
    int? onGoing,
    int? delivered,
  }) =>
      Body(
        inGroup: inGroup ?? this.inGroup,
        onGoing: onGoing ?? this.onGoing,
        delivered: delivered ?? this.delivered,
      );

  factory Body.fromJson(Map<String, dynamic> json) => Body(
        inGroup: json["in_group"],
        onGoing: json["on_going"],
        delivered: json["delivered"],
      );

  Map<String, dynamic> toJson() => {
        "in_group": inGroup,
        "on_going": onGoing,
        "delivered": delivered,
      };
}
