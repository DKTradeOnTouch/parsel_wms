import 'dart:convert';

GetOrdersCountModel getOrdersCountModelFromJson(String str) =>
    GetOrdersCountModel.fromJson(json.decode(str));

String getOrdersCountModelToJson(GetOrdersCountModel data) =>
    json.encode(data.toJson());

class GetOrdersCountModel {
  final bool status;
  final String message;
  final Count count;

  GetOrdersCountModel({
    required this.status,
    required this.message,
    required this.count,
  });

  GetOrdersCountModel copyWith({
    bool? status,
    String? message,
    Count? count,
  }) =>
      GetOrdersCountModel(
        status: status ?? this.status,
        message: message ?? this.message,
        count: count ?? this.count,
      );

  factory GetOrdersCountModel.fromJson(Map<String, dynamic> json) =>
      GetOrdersCountModel(
        status: json["status"],
        message: json["message"],
        count: Count.fromJson(json["body"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "body": count.toJson(),
      };
}

class Count {
  final int inGroup;
  final int onGoing;
  final int delivered;

  Count({
    required this.inGroup,
    required this.onGoing,
    required this.delivered,
  });

  Count copyWith({
    int? inGroup,
    int? onGoing,
    int? delivered,
  }) =>
      Count(
        inGroup: inGroup ?? this.inGroup,
        onGoing: onGoing ?? this.onGoing,
        delivered: delivered ?? this.delivered,
      );

  factory Count.fromJson(Map<String, dynamic> json) => Count(
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
