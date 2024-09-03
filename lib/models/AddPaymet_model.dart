class AddPaymet_model {
  List<PaymentsList>? paymentsList;

  AddPaymet_model({this.paymentsList});

  AddPaymet_model.fromJson(Map<String, dynamic> json) {
    if (json['paymentsList'] != null) {
      paymentsList = <PaymentsList>[];
      json['paymentsList'].forEach((v) {
        paymentsList!.add(PaymentsList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.paymentsList != null) {
      data['paymentsList'] = this.paymentsList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PaymentsList {
  int? value;
  String? paymentRemark;
  String? paymentDate;
  String? chequePaymentTypes;
  String? paymentTypes;
  String? name;
  String? paymentMode;

  PaymentsList(
      {this.value,
      this.paymentRemark,
      this.paymentDate,
      this.chequePaymentTypes,
      this.paymentTypes,
      this.paymentMode,
      this.name});

  PaymentsList.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    paymentRemark = json['paymentRemark'];
    paymentDate = json['paymentDate'];
    chequePaymentTypes = json['chequePaymentTypes'];
    paymentTypes = json['paymentTypes'];
    paymentTypes = json['paymentTypes'];
    paymentTypes = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['value'] = this.value;
    data['paymentRemark'] = this.paymentRemark;
    data['paymentDate'] = this.paymentDate;
    data['chequePaymentTypes'] = this.chequePaymentTypes;
    data['paymentTypes'] = this.paymentTypes;
    data['name'] = this.paymentTypes;

    return data;
  }
}
