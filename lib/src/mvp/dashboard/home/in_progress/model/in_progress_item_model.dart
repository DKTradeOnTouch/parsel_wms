class InProgressItemModel {
  final String locationName;
  final String locationAddress;
  final List<String> invoiceNo;
  final String salesOrderId;
  final bool isItemActiveForDelivery;

  InProgressItemModel(
      {required this.locationName,
      required this.locationAddress,
      required this.invoiceNo,
      required this.salesOrderId,
      required this.isItemActiveForDelivery});
}
