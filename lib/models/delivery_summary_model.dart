/* created by Srini on 05-06-2022*/

class DeliverySummaryData {
  String invoiceNo;
  String orderedCount;
  String deliveredCount;
  String returnCount;
  String noOfBoxesCount;

  String skuTemp;
  String remarks;

  DeliverySummaryData({
    required this.invoiceNo,
    required this.orderedCount,
    required this.deliveredCount,
    required this.returnCount,
    required this.noOfBoxesCount,

    required this.skuTemp,
    required this.remarks
  });
}