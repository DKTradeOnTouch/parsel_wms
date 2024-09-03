// To parse this JSON data, do
//
//     final createdPaymentModel = createdPaymentModelFromJson(jsonString);

import 'dart:convert';

CreatedPaymentModel createdPaymentModelFromJson(String str) =>
    CreatedPaymentModel.fromJson(json.decode(str));

String createdPaymentModelToJson(CreatedPaymentModel data) =>
    json.encode(data.toJson());

class CreatedPaymentModel {
  final int status;
  final String message;
  final Body body;

  CreatedPaymentModel({
    required this.status,
    required this.message,
    required this.body,
  });

  CreatedPaymentModel copyWith({
    int? status,
    String? message,
    Body? body,
  }) =>
      CreatedPaymentModel(
        status: status ?? this.status,
        message: message ?? this.message,
        body: body ?? this.body,
      );

  factory CreatedPaymentModel.fromJson(Map<String, dynamic> json) =>
      CreatedPaymentModel(
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
  final List<Datum> data;

  Body({
    required this.data,
  });

  Body copyWith({
    List<Datum>? data,
  }) =>
      Body(
        data: data ?? this.data,
      );

  factory Body.fromJson(Map<String, dynamic> json) => Body(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  final int id;
  final DateTime creationTime;
  final String paymentType;
  final double value;
  final String paymentRemark;
  final DateTime paymentDate;
  final String chequeType;
  final String status;
  final dynamic doneByUserId;

  Datum({
    required this.id,
    required this.creationTime,
    required this.paymentType,
    required this.value,
    required this.paymentRemark,
    required this.paymentDate,
    required this.chequeType,
    required this.status,
    required this.doneByUserId,
  });

  Datum copyWith({
    int? id,
    DateTime? creationTime,
    String? paymentType,
    double? value,
    String? paymentRemark,
    DateTime? paymentDate,
    String? chequeType,
    String? status,
    dynamic doneByUserId,
  }) =>
      Datum(
        id: id ?? this.id,
        creationTime: creationTime ?? this.creationTime,
        paymentType: paymentType ?? this.paymentType,
        value: value ?? this.value,
        paymentRemark: paymentRemark ?? this.paymentRemark,
        paymentDate: paymentDate ?? this.paymentDate,
        chequeType: chequeType ?? this.chequeType,
        status: status ?? this.status,
        doneByUserId: doneByUserId ?? this.doneByUserId,
      );

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        creationTime: DateTime.parse(json["creationTime"]),
        paymentType: json["paymentType"],
        value: json["value"],
        paymentRemark: json["paymentRemark"],
        paymentDate: DateTime.parse(json["paymentDate"]),
        chequeType: json["chequeType"],
        status: json["status"],
        doneByUserId: json["doneByUserId"] ?? null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "creationTime": creationTime.toIso8601String(),
        "paymentType": paymentType,
        "value": value,
        "paymentRemark": paymentRemark,
        "paymentDate":
            "${paymentDate.year.toString().padLeft(4, '0')}-${paymentDate.month.toString().padLeft(2, '0')}-${paymentDate.day.toString().padLeft(2, '0')}",
        "chequeType": chequeType,
        "status": status,
        "doneByUserId": doneByUserId,
      };
}
