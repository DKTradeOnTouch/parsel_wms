class UpdateSalesOrderItemResponse {
  String? productCode;
  int? qty;
  int? delivered;
  int? returned;
  String? returnReason;

  UpdateSalesOrderItemResponse({
    this.productCode,
    this.qty,
    this.delivered,
    this.returned,
    this.returnReason = 'Reason 1',
  });

  UpdateSalesOrderItemResponse.fromJson(Map<String, dynamic> json) {
    productCode = json['productCode'];
    qty = json['qty'];
    delivered = json['delivered'];
    returned = json['returned'];
    returnReason = json['returnReason'];
  }

  Map<String, dynamic> toJson() => {
        'productCode': productCode,
        'qty': qty,
        'delivered': delivered,
        'returned': returned,
        'returnReason': returnReason,
      };
}
