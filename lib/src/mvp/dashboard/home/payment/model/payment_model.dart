import 'package:flutter/material.dart';

enum PaymentType { cod, credit, cheque, online }

class PaymentModel {
  final String imageUrl;
  final String title;
  final PaymentType paymentType;

  PaymentModel({
    required this.imageUrl,
    required this.title,
    required this.paymentType,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaymentModel &&
          runtimeType == other.runtimeType &&
          imageUrl == other.imageUrl &&
          title == other.title &&
          paymentType == other.paymentType;

  @override
  int get hashCode => imageUrl.hashCode ^ title.hashCode ^ paymentType.hashCode;
}
