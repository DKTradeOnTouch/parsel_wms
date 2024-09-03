class CreatePaymentModeModel {
  List<CreatePaymentsList>? payments;

  CreatePaymentModeModel({this.payments});

  CreatePaymentModeModel.fromJson(Map<String, dynamic> json) {
    if (json['paymentsList'] != null) {
      payments = <CreatePaymentsList>[];
      json['paymentsList'].forEach((v) {
        payments!.add(CreatePaymentsList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (payments != null) {
      data['paymentsList'] = payments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CreatePaymentsList {
  int? value;
  String? paymentRemark;
  String? paymentDate;
  String? chequePaymentTypes;
  String? paymentTypes;
  String? name;
  String? paymentMode;

  CreatePaymentsList(
      {this.value,
      this.paymentRemark,
      this.paymentDate,
      this.chequePaymentTypes,
      this.paymentTypes,
      this.name,
      this.paymentMode = ''});

  CreatePaymentsList.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    paymentRemark = json['paymentRemark'];
    paymentDate = json['paymentDate'];
    chequePaymentTypes = json['chequePaymentTypes'];
    paymentTypes = json['paymentTypes'];
    paymentTypes = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['value'] = value;
    data['paymentRemark'] = paymentRemark;
    data['paymentDate'] = paymentDate;
    data['chequePaymentTypes'] = chequePaymentTypes;
    data['paymentTypes'] = paymentTypes;
    data['name'] = paymentTypes;

    return data;
  }
}
