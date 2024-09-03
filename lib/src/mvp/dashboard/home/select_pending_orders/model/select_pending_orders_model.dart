class SelectPendingOrdersModel {
  bool isItemSelected;
  int itemQty;
  int id;
  String itemName;

  SelectPendingOrdersModel(
      {required this.isItemSelected,
      required this.itemQty,
      required this.id,
      required this.itemName});
}
