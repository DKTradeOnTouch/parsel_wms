import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:parsel_flutter/resource/app_icons.dart';
import 'package:parsel_flutter/screens/confirm_back_widget.dart';
import 'package:parsel_flutter/screens/deliver_orders/delivery_summary_page.dart';
import 'package:parsel_flutter/src/widget/widget.dart';
import 'package:parsel_flutter/utils/utils.dart';
import 'package:provider/provider.dart';

import '../../Provider/Delivery_Controller.dart';
import '../../models/SalesOrderBYID_Model.dart';
import '../../models/uploadsalesorder_model.dart' as uplds;
import '../../resource/app_colors.dart';
import '../../resource/app_fonts.dart';
import '../../resource/app_strings.dart';
import '../../resource/app_styles.dart';

class DeliverOrdersPage extends StatefulWidget {
  const DeliverOrdersPage({
    Key? key,
    this.store,
    required String diff,
    required this.salesOrderId,
    required this.id,
    required this.deliverOrdersList,
    required this.dataList,
    required this.dataUp,
    required this.salesOrder,
  }) : super(key: key);

  final String salesOrderId;
  final String id;
  final List<ItemList> deliverOrdersList;
  final List<ItemList> dataList;
  final List<uplds.ItemList> dataUp;
  final Store? store;
  final SalesOrderBYID_Model salesOrder;

  // final

  @override
  State<DeliverOrdersPage> createState() => _DeliverOrdersState();
}

class _DeliverOrdersState extends State<DeliverOrdersPage> {
  // List<ItemList> _DeliverOrdersList = [];
  late File croppedFile;
  late String base64Image;
  bool afterProcess = false;
  bool _isLoading = false;
  // Store? store;
  TextEditingController textFieldController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  TextEditingController fullItemReturnController =
      TextEditingController(text: 'Select Reason for Return');
  List<TextEditingController> returnControllers = [];
  List<TextEditingController> qtyControllers = [];
  List<TextEditingController> excessControllers = [];
  List<String> dList = [
    "Select Reason for Return",
    " Invoice canceled",
    " Damaged",
    " Melted",
    "Double Billing",
    " Expired Stock",
    " Late Delivery",
    "Loading Mistake",
    " Near Expiry",
    "No Ackw/No GRN",
    " No Cash",
    " No Delivery Attempt",
    "No Loading",
    " No Order By Party",
    " No Space",
    " No Stock",
    " Old Return",
    " Rate Diff",
    " Route Cancelled",
    " Vehicle Salesman Mistake",
    " Sample",
    " Shop Closed",
    "Short Received",
    "Stock Rtn To Co",
    "Wrong Order",
    " Wrong Billing",
    "Wrong Route",
    "Wrong Address"
  ];
  List<String> _Dvalue = [];

//  List< INVOICE.ResultList>  resultList1=[];
  final List<ItemList> temp = [];
  final _formKey = GlobalKey<FormState>();
  String? diff;

  String? sID;

  @override
  void initState() {
    for (int i = 0; i < widget.dataList.length; i++) {
      _Dvalue.add((widget.dataUp[i].returnReason == 'Reason 1' ||
              widget.dataUp[i].returnReason == null)
          ? dList[0]
          : widget.dataUp[i].returnReason ?? '');
      returnControllers
          .add(TextEditingController(text: "${widget.dataUp[i].returned}"));
      excessControllers.add(TextEditingController());
      qtyControllers
          .add(TextEditingController(text: '${widget.dataUp[i].qty}'));
    }
    super.initState();
    if (ConnectivityHandler.connectivityResult
        .contains(ConnectivityResult.none)) {
      getSalesDataFromPrefs();
    } else {
      // GetSalesorderbyID(context);
    }
  }

  getSalesDataFromPrefs() {
    String prefsDataList = VariableUtilities.preferences.getString(
            "${LocalCacheKey.deliveredOrderDataList}${widget.salesOrderId}") ??
        '';
    if (prefsDataList != '') {
      // dataList = List<ItemList>.from(
      //     jsonDecode(prefsDataList).map((x) => ItemList.fromJson(x)));
    }

    String prefsDataUp = VariableUtilities.preferences.getString(
            "${LocalCacheKey.deliveredOrderDataUp}${widget.salesOrderId}") ??
        '';

    if (prefsDataUp != '') {
      // dataUp
      // dataUp = List<uplds.ItemList>.from(
      //     jsonDecode(prefsDataUp).map((x) => uplds.ItemList.fromJson(x)));
    }
    String prefsDataDeliverOrder = VariableUtilities.preferences.getString(
            "${LocalCacheKey.deliverDeliverOrdersList}${widget.salesOrderId}") ??
        '';

    if (prefsDataDeliverOrder != '') {
      // dataup
      // _DeliverOrdersList = List<ItemList>.from(
      //     jsonDecode(prefsDataDeliverOrder).map((x) => ItemList.fromJson(x)));
    }
    String prefsDeliveredStore = VariableUtilities.preferences.getString(
            "${LocalCacheKey.deliveredOrderStore}${widget.salesOrderId}") ??
        '';
    if (prefsDeliveredStore != '') {
      // store = Store.fromJson(jsonDecode(prefsDeliveredStore));
    }
    setState(() {});
  }

  // Future GetSalesorderbyID(BuildContext context) async {
  //   final preference = await SharedPreferences.getInstance();
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   return await API.GetSalesorderbyID(
  //     context,
  //     showNoInternet: true,
  //     Authtoken: preference.getString("token").toString(),
  //     ID: widget.id,
  //   ).then(
  //     (SalesOrderBYID_Model? response) async {
  //       setState(() {
  //         _isLoading = false;
  //       });
  //       print('response-->' + response.toString());
  //       if (response != null) {
  //         _DeliverOrdersList.addAll(response.data!.itemList!);
  //         StorageUtils.preferences.setString(
  //             "${StorageUtils.deliverDeliverOrdersList}${widget.Salesorderid}",
  //             jsonEncode(_DeliverOrdersList));
  //         dataList.addAll(response.data!.itemList!);
  //         StorageUtils.preferences.setString(
  //             "${StorageUtils.deliveredOrderDataList}${widget.Salesorderid}",
  //             jsonEncode(dataList));
  //         store = response.data!.store!;
  //         StorageUtils.preferences.setString(
  //             "${StorageUtils.deliveredOrderStore}${widget.Salesorderid}",
  //             jsonEncode(store));

  //         var list = Provider.of<Delivery_Controller>(context, listen: false);
  //         list.dpitemList.clear();
  //         response.data!.itemList!
  //             .map((e) => dataup.add(uplds.ItemList(
  //                 productCode: e.productCode,
  //                 qty: e.id,
  //                 returnReason: "Reason 1",
  //                 returned: e.returned,
  //                 delivered: e.qty)))
  //             .toList();

  //         StorageUtils.preferences.setString(
  //             "${StorageUtils.deliveredOrderDataUp}${widget.Salesorderid}",
  //             jsonEncode(dataup));
  //         list.setAlldelivryitem(dataup);
  //         for (int i = 0; i < dataList.length; i++) {}
  //         setState(() {});
  //       } else {
  //         AppHelper.showSnackBar(context, AppStrings.strSomethingWentWrong);
  //       }
  //     },
  //   ).onError((error, stackTrace) {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   });
  // }

  // Future updateSalesorderbyID1(
  //     BuildContext context, List<uplds.ItemList> itm) async {
  //   final preference = await SharedPreferences.getInstance();
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   log('itm --> ${jsonEncode(itm)}');
  //   return await API
  //       .updateSalesorderbyID1(context,
  //           showNoInternet: true,
  //           itemList: itm,
  //           executionStatus: 'ARRIVED',
  //           ID: widget.Salesorderid)
  //       .then(
  //     (up.UpdateSalesOrder_model? response) async {
  //       setState(() {
  //         _isLoading = false;
  //       });
  //       print('response-->' + response.toString());
  //       if (response != null) {
  //       } else {
  //         AppHelper.showSnackBar(context, AppStrings.strSomethingWentWrong);
  //       }
  //     },
  //   ).onError((error, stackTrace) {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   });
  // }
  @override
  void dispose() {
    super.dispose();
  }

  Widget routeItem(
      BuildContext context,
      ItemList itemList,
      int index,
      TextEditingController Qcontroller,
      TextEditingController Rcontroller,
      String DValue) {
    // Rcontroller.text = itemList.returned.toString();
    Qcontroller.text = itemList.qty.toString();

/*if(itemList.returned!=null){
  Rcontroller.text=itemList.returned.toString();
}*/
    int? Qty = int.parse(itemList.qty.toString());

    return Card(
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        elevation: 10,
        margin: const EdgeInsets.only(bottom: 0.5),
        child: Padding(
          padding: const EdgeInsets.only(left: 30.0, right: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                padding: const EdgeInsets.only(
                    left: 15.0, right: 0.0, top: 15.0, bottom: 15.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: AppColors.black2Color.withOpacity(0.25),
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(
                          5.0) //                 <--- border radius here
                      ),
                ),
                child: Text(
                  itemList.productName.toString(),
                  style: const TextStyle(
                      color: AppColors.dashBoardText,
                      fontWeight: FontWeight.w500,
                      fontFamily: appFontFamily,
                      fontSize: 12.0),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.0),
                            child: Text(
                              'RETURN',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: appFontFamily,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.blueColor),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (int.parse(value!) > Qty) {
                                return 'Return not more than Qty ';
                              } else {
                                return null;
                              }
                            },
                            onChanged: (text) {
                              print('Text---> ${Rcontroller.text}');
                              int delivedQty = int.parse(Qcontroller.text) -
                                  (Rcontroller.text != ''
                                      ? int.parse(Rcontroller.text)
                                      : 0);
                              var list = Provider.of<DeliveryController>(
                                  context,
                                  listen: false);
                              list.updateParticular(
                                  uplds.ItemList(
                                      productCode: itemList.productCode,
                                      qty: int.parse(Qcontroller.text),
                                      returned: int.parse(
                                          Rcontroller.text.isEmpty
                                              ? '0'
                                              : Rcontroller.text),
                                      delivered: delivedQty,
                                      returnReason: "Reason 1"),
                                  index);
                              setState(() {});
                            },
                            controller: Rcontroller,
                            style: const TextStyle(
                                color: AppColors.dashBoardText,
                                fontWeight: FontWeight.w400,
                                fontSize: 14.0),
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(
                                  left: 15.0,
                                  right: 0.0,
                                  top: 0.0,
                                  bottom: 0.0),
                              border: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(4.0),
                                ),
                                borderSide: BorderSide(
                                  // color: kTextFieldBorderColor,
                                  width: 1,
                                  color:
                                      AppColors.black2Color.withOpacity(0.25),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 5.0, right: 5.0),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 5.0, right: 5.0),
                    ),
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              'QTY',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: appFontFamily,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.blueColor),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                              height: 48,
                              width: 80,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(width: 1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: TextField(
                                readOnly: true,
                                controller: Qcontroller,
                                style: const TextStyle(
                                    color: AppColors.dashBoardText,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14.0),
                                keyboardType: TextInputType.number,
                                onChanged: (text) {},
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(
                                      left: 15.0,
                                      right: 0.0,
                                      top: 0.0,
                                      bottom: 0.0),
                                  border: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(4.0),
                                    ),
                                    borderSide: BorderSide(
                                      // color: kTextFieldBorderColor,
                                      width: 1,
                                      color: AppColors.black2Color
                                          .withOpacity(0.25),
                                    ),
                                  ),
                                ),
                              )

                              // inputFieldQTY(itemList.qty.toString(),
                              //     _QtyControllers[index]),
                              )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 14,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  "REASON",
                  style: TextStyle(
                      fontSize: 12,
                      fontFamily: appFontFamily,
                      fontWeight: FontWeight.w400,
                      color: AppColors.blueColor),
                ),
              ),
              Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(left: 15.0, right: 5.0),
                  margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: AppColors.black2Color.withOpacity(0.25),
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(
                            4.0) //                 <--- border radius here
                        ),
                  ),
                  child: DropdownButtonFormField<String>(
                    validator: (value) {
                      if (Rcontroller.text.isNotEmpty &&
                          Rcontroller.text != '0' &&
                          value.toString() == 'Select Reason for Return') {
                        return 'Please Select Proper Reason';
                      } else {
                        return null;
                      }
                    },
                    value: _Dvalue[index],
                    icon: const Visibility(
                        visible: true, child: Icon(Icons.keyboard_arrow_down)),
                    items: dList.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(
                              color: AppColors.hintTextColor,
                              fontFamily: appFontFamily),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      int delivedQty = int.parse(Qcontroller.text) -
                          (Rcontroller.text != ''
                              ? int.parse(Rcontroller.text)
                              : 0);

                      var list = Provider.of<DeliveryController>(context,
                          listen: false);
                      list.updateParticular(
                          uplds.ItemList(
                              productCode: itemList.productCode,
                              qty: int.parse(Qcontroller.text),
                              returned: int.parse(Rcontroller.text),
                              returnReason: value.toString(),
                              delivered: delivedQty),
                          index);
                      setState(() {});
                    },
                  )),
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    /* Future.delayed(const Duration(milliseconds: 600000), () {

// Here you can write your code
      LocationCreate(context);
      setState(() {
        // Here you can write your code for open new view
      });

    });*/

    return ConfirmBackWrapperWidget(
      child: Form(
          key: _formKey,
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize:
                  const Size.fromHeight(80.0), // here the desired height
              child: AppBar(
                backgroundColor: Colors.black,
                title: Container(
                  padding: const EdgeInsets.only(top: 20),
                  margin: const EdgeInsets.only(top: 38, left: 34, bottom: 19),
                  child:
                      Text('DELIVER ORDER', style: AppStyles.appBarTitleStyle),
                ),
                leading: GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Container(
                      padding: const EdgeInsets.only(top: 30),
                      height: 15,
                      width: 15,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios),
                          iconSize: 20.0,
                          onPressed: () {
                            Navigator.maybePop(context);
                          },
                        ),
                      ),
                    ),
                  ),
                  onTap: () {},
                ),
                actions: [
                  InkWell(
                    onTap: () {
                      showAlert(context, true);
                    },
                    child: Container(
                      // padding: const EdgeInsets.only(top: 30),
                      margin: const EdgeInsets.only(top: 30),
                      child: Image.asset(
                        AppIcons.icLocationPin,
                        height: 18,
                        // width: 18,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 35,
                  ),
                ],
              ),
            ),
            body: widget.deliverOrdersList.isNotEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(
                            left: 35, right: 0, top: 16, bottom: 16),
                        color: AppColors.lightBlueColor,
                        child: Row(
                          children: [
                            //Invoice
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppStrings.strInvoiceNo,
                                  style: const TextStyle(
                                      fontFamily: appFontFamily,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: AppColors.black2Color),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  '${widget.salesOrderId}',
                                  maxLines: 2,
                                  overflow: TextOverflow.fade,
                                  style: const TextStyle(
                                      fontFamily: appFontFamily,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      color: AppColors.black2Color),
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 60,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'CUSTOMER',
                                  style: TextStyle(
                                      fontFamily: appFontFamily,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: AppColors.black2Color),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.45,
                                  child: Text(
                                    '${widget.store!.storeName.toString()}',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                    style: const TextStyle(
                                        fontFamily: appFontFamily,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                        color: AppColors.black2Color),
                                  ),
                                ),
                              ],
                            ), //Cost
                          ],
                        ),
                      ),
                      SearchInput(
                          controller: searchController, onChanged: (text) {}),
                      Expanded(
                          child: ListView.builder(
                              itemCount: widget.dataList.length,
                              itemBuilder: (BuildContext context, index) {
                                return routeItem(
                                    context,
                                    widget.dataList[index],
                                    index,
                                    qtyControllers[index],
                                    returnControllers[index],
                                    _Dvalue[index]);
                              })),
                    ],
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
            bottomNavigationBar: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.blueColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0)),
                    ),
                    child: MaterialButton(
                      height: 60.0,
                      onPressed: () async {
                        final proceed = await showConfirmationDialog(
                          context: context,
                          title: "Full return",
                          content: "Are you sure to return all items?",
                          positiveButtonLabel: "Return",
                        );
                        if (proceed == true) {
                          for (int i = 0; i < qtyControllers.length; i++) {
                            returnControllers[i].text = qtyControllers[i].text;
                          }
                          var list = Provider.of<DeliveryController>(context,
                              listen: false);
                          for (int i = 0; i < list.dpItemList.length; i++) {
                            print(
                                "list.dpitemList --> ${list.dpItemList[i].toJson()}");
                            list.dpItemList[i].returnReason =
                                fullItemReturnController.text;
                            print(
                                "qtyControllers[i].text --> $i --> ${qtyControllers[i].text}");
                            list.dpItemList[i].returned = int.parse(
                                qtyControllers[i].text.isEmpty
                                    ? "0"
                                    : qtyControllers[i].text);
                            list.dpItemList[i].delivered = 0;
                            _Dvalue[i] = fullItemReturnController.text;
                            setState(() {});
                          }
                        }
                      },
                      child: const Text(
                        'Full Return',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: appFontFamily,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            letterSpacing: 1),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.blueColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0)),
                    ),
                    child: MaterialButton(
                      height: 60.0,
                      onPressed: () {
                        var list = Provider.of<DeliveryController>(context,
                            listen: false);
                        log("widget.dataup ${jsonEncode(list.uploadParticularListItem)}");
                        final deliveryController =
                            Provider.of<DeliveryController>(context,
                                listen: false);
                        double count = 0;
                        for (int i = 0;
                            i <
                                deliveryController
                                    .uploadParticularListItem.length;
                            i++) {
                          var abc =
                              deliveryController.uploadParticularListItem[i];
                          print(
                              'Product name --> $i ${abc.returned}  ${abc.delivered}');
                          count = count + double.parse("${abc.returned}");
                        }
                        print('Count-> $count');
                        if (_formKey.currentState!.validate()) {
                          showAlert(context, false);
                        }
                      },
                      child: const Text(
                        'DELIVER',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: appFontFamily,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            letterSpacing: 1),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Future<bool?> showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String content,
    required String positiveButtonLabel,
    String negativeButtonLabel = "Cancel",
  }) {
    // final _formKey = GlobalKey<FormState>();
    fullItemReturnController =
        TextEditingController(text: 'Select Reason for Return');

    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(builder: (context, innerState) {
          return Center(
            // key: _formKey,
            child: SingleChildScrollView(
              child: AlertDialog(
                title: Text(title),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(content),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      validator: (value) {
                        if (fullItemReturnController.text.isNotEmpty &&
                            fullItemReturnController.text != '0' &&
                            value.toString() == 'Select Reason for Return') {
                          return 'Please Select Proper Reason';
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 0),
                          labelStyle: const TextStyle(
                              fontSize: 16, color: Color(0XFF7C7C7C)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: Color(0XFF7C7C7C),
                                style: BorderStyle.solid),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: Color(0XFF7C7C7C),
                                style: BorderStyle.solid),
                          ),
                          hoverColor: const Color(0XFF444444)),
                      value: fullItemReturnController.text,
                      icon: const Visibility(
                          visible: true,
                          child: Icon(Icons.keyboard_arrow_down)),
                      items: dList.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: const TextStyle(
                                fontSize: 15,
                                color: AppColors.hintTextColor,
                                fontFamily: appFontFamily),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        innerState(() {
                          fullItemReturnController =
                              TextEditingController(text: value);
                        });
                      },
                    ),
                    (fullItemReturnController.text ==
                            'Select Reason for Return')
                        ? const Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Text('Please Select Proper Reason!',
                                style:
                                    TextStyle(fontSize: 14, color: Colors.red)),
                          )
                        : const SizedBox()
                  ],
                ),
                actions: [
                  TextButton(
                    child: Text(positiveButtonLabel),
                    onPressed: () {
                      if (fullItemReturnController.text ==
                          'Select Reason for Return') {
                      } else {
                        Navigator.of(dialogContext)
                            .pop(true); // Dismiss alert dialog
                      }
                    },
                  ),
                  TextButton(
                    child: Text(negativeButtonLabel),
                    onPressed: () {
                      Navigator.of(dialogContext)
                          .pop(false); // Dismiss alert dialog
                    },
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  //Adding static data to list - Srini
  // void launchGoogleMap(String address) async {
  //   String query = Uri.encodeComponent(address);
  //   String googleUrl = "https://www.google.com/maps/search/?api=1&query=$query";

  //   if (await canLaunchUrl(Uri.parse(googleUrl))) {
  //     await launchUrl(Uri.parse(googleUrl));
  //   }
  // }

  //Show dialog for confirmation
  showAlert(BuildContext context, bool showMapLink) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Consumer<DeliveryController>(builder: (context, Ddata, child) {
          return AlertDialog(
            title: Column(
              children: [
                Container(
                    alignment: Alignment.center,
                    child: Container(
                        width: 40,
                        height: 40,
                        child: SvgPicture.asset("assets/logo.svg",
                            semanticsLabel: 'Acme Logo'))),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0, bottom: 2.0),
                  child: Text(
                    showMapLink ? 'DELIVERY ADDRESS' : "ARRIVED",
                    style: const TextStyle(
                        color: AppColors.blueColor,
                        fontSize: 13,
                        fontFamily: appFontFamily,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            content: SizedBox(
              height: showMapLink ? 130.0 : 90.0,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Text(
                        showMapLink
                            ? "${widget.store!.storeAddress.toString()}\n \n Arrived to customer location. Please click on 'OK' to continue"
                            : "Arrived to customer location. Please click on 'OK' to continue",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 13,
                            fontFamily: appFontFamily,
                            fontWeight: FontWeight.w400,
                            letterSpacing: -1)),
                  ),
                  Visibility(
                    visible: showMapLink,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 22.0),
                      child: InkWell(
                        onTap: () {
                          // launchGoogleMap(store!.storeAddress.toString());
                        },
                        child: const Text('FIND ON MAP',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: appFontFamily,
                              fontSize: 15,
                              decoration: TextDecoration.underline,
                            )),
                      ),
                    ),
                  )
                ],
              ),
            ),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                              height: 40,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.black2Color,
                                borderRadius: BorderRadius.circular(5),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    offset: Offset(5, 5),
                                    blurRadius: 10,
                                  )
                                ],
                              ),
                              child: Text(
                                showMapLink ? 'GO BACK' : 'CANCEL',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                    letterSpacing: 1),
                              ))),
                    ),
                    Visibility(
                      visible: !showMapLink,
                      child: const SizedBox(
                        width: 15.0,
                      ),
                    ),
                    Visibility(
                      visible: !showMapLink,
                      child: Expanded(
                        child: InkWell(
                            onTap: () {
                              VariableUtilities.preferences.setString(
                                  "${LocalCacheKey.deliveredOrderDataUp}${widget.salesOrderId}",
                                  jsonEncode(Ddata.uploadParticularListItem));

                              Navigator.of(context).pop();
                              // String textToSend = textFieldController.text;
                              // if (ConnectivityHandler.connectivityResult ==
                              //     ConnectivityResult.none) {
                              //   String prefsQueApi = StorageUtils.preferences
                              //           .getString(
                              //               StorageUtils.paymentApiInQue) ??
                              //       '';
                              //   // log("prefsQueApi --> $prefsQueApi");
                              //   List<dynamic> prefsList = [];
                              //   if (prefsQueApi.isNotEmpty) {
                              //     prefsList = List<dynamic>.from(
                              //         jsonDecode(prefsQueApi).map(
                              //             (x) => jsonDecode(jsonEncode(x))));
                              //   }
                              //   for (int i = 0; i < prefsList.length; i++) {
                              //     Map<String, dynamic> prefsJson = {};
                              //     if (prefsList[i].runtimeType == String) {
                              //       prefsJson = jsonDecode(prefsList[i]);
                              //     } else {
                              //       prefsJson =
                              //           jsonDecode(jsonEncode(prefsList[i]));
                              //     }
                              //     if (prefsJson['parameters']['ID'] ==
                              //         widget.Salesorderid.toString()) {
                              //       if (prefsJson['function_name'] ==
                              //           'updateSalesorderbyID1') {
                              //         Map<String, dynamic>
                              //             updateSalesorderbyID1 = {
                              //           "function_name":
                              //               "updateSalesorderbyID1",
                              //           'parameters': {
                              //             'showNoInternet': true,
                              //             'itemList':
                              //                 Ddata.uploadparticularListitem,
                              //             'executionStatus': 'ARRIVED',
                              //             'ID': widget.Salesorderid
                              //           }
                              //         };

                              //         prefsList.insert(
                              //             i, updateSalesorderbyID1);
                              //         prefsList.removeWhere((element) {
                              //           Map<String, dynamic> elementJson = {};

                              //           if (element.runtimeType == String) {
                              //             elementJson = jsonDecode(element);
                              //           } else {
                              //             elementJson =
                              //                 jsonDecode(jsonEncode(element));
                              //           }
                              //           return elementJson['function_name'] ==
                              //               prefsJson['function_name'];
                              //         });

                              //         AppHelper.showSnackBar(context,
                              //             "Your Request is already submitted");
                              //         StorageUtils.preferences.setString(
                              //             StorageUtils.paymentApiInQue,
                              //             jsonEncode(prefsList));
                              //         Navigator.push(
                              //             context,
                              //             MaterialPageRoute(
                              //                 builder: (_) =>
                              //                     DeliverySummaryPage(
                              //                       salesOrder:
                              //                           widget.salesOrder,
                              //                       dataList: widget.dataList,
                              //                       dataup: widget.dataup,
                              //                       deliverOrdersList: widget
                              //                           .deliverOrdersList,
                              //                       id: widget.id,
                              //                       Salesorderid:
                              //                           widget.Salesorderid,
                              //                       diff: textToSend,
                              //                     )));
                              //         return;
                              //       }
                              //     }
                              //   }

                              //   Map<String, dynamic> updateSalesorderbyID1 = {
                              //     "function_name": "updateSalesorderbyID1",
                              //     'parameters': {
                              //       'showNoInternet': true,
                              //       'itemList': Ddata.uploadparticularListitem,
                              //       'executionStatus': 'ARRIVED',
                              //       'ID': widget.Salesorderid
                              //     }
                              //   };
                              //   List<dynamic> updatedPrefsList = [];
                              //   if (prefsQueApi.isNotEmpty) {
                              //     updatedPrefsList = List<dynamic>.from(
                              //         jsonDecode(prefsQueApi).map(
                              //             (x) => jsonDecode(jsonEncode(x))));
                              //     updatedPrefsList
                              //         .add(jsonEncode(updateSalesorderbyID1));
                              //   } else {
                              //     updatedPrefsList
                              //         .add(jsonEncode(updateSalesorderbyID1));
                              //   }

                              //   StorageUtils.preferences.setString(
                              //       StorageUtils.paymentApiInQue,
                              //       jsonEncode(updatedPrefsList));
                              //   AppHelper.showSnackBar(
                              //       context, "Your Request is Submitted!");
                              //   // return;
                              // } else {
                              //   updateSalesorderbyID1(
                              //       context, Ddata.uploadparticularListitem);
                              // }
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => DeliverySummaryPage(
                                            salesOrder: widget.salesOrder,
                                            dataList: widget.dataList,
                                            dataup: widget.dataUp,
                                            deliverOrdersList:
                                                widget.deliverOrdersList,
                                            id: widget.id,
                                            Salesorderid: widget.salesOrderId,
                                            diff: '',
                                          )));
                            },
                            child: Container(
                                height: 40,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppColors.black2Color,
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black12,
                                      offset: Offset(5, 5),
                                      blurRadius: 10,
                                    )
                                  ],
                                ),
                                child: Text(
                                  showMapLink ? 'CLOSE' : 'OK',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                      letterSpacing: 1),
                                ))),
                      ),
                    )
                  ],
                ),
              ),
            ],
          );
        });
      },
    );
  }
/* Future returnSOData(
      BuildContext context, String salesOrderId) async {
    setState(() {
      _isLoading = true;
    });
    return await API
        .returnSOData(context, salesOrderId,
            showNoInternet: true)
        .then(
      (ReturnSODataModel ? response) async {
        setState(() {
          _isLoading = false;
        });
        print('response-->' + response.toString());
        if (response!.message != null) {
          AppHelper.showSnackBar(context, response.message.toString());
          final preference = await SharedPreferences.getInstance();
          preference.setString('salesOrderID', response.body.toString());

        } else {
          AppHelper.showSnackBar(context, response.message.toString());
        }
      },
    ).onError((error, stackTrace) {
      setState(() {
        _isLoading = false;
      });
    });
  }*/
}
