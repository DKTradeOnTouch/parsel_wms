class DispatchSummaryArgs {
  final String driverName;
  final DateTime driverTime;
  final int skuCount;
  final int skuQtyCount;
  final int deliveryPoint;
  final int noOfBoxes;
  final double temperature;
  final DateTime docTime;

  DispatchSummaryArgs(
      {required this.driverName,
      required this.driverTime,
      required this.skuCount,
      required this.skuQtyCount,
      required this.deliveryPoint,
      required this.noOfBoxes,
      required this.temperature,
      required this.docTime});
}
