// import 'package:barcode_scanner/scanbot_barcode_sdk_v2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:parsel_flutter/models/PickingList.dart' as pl;
import 'package:parsel_flutter/resource/app_colors.dart';
import 'package:parsel_flutter/resource/app_fonts.dart';
import 'package:parsel_flutter/resource/app_strings.dart';
import 'package:parsel_flutter/resource/app_styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../api/api.dart';
import '../../../models/performActionPICKPACK_modal.dart';
import '../../../resource/app_helper.dart';
import '../InventoryDashboard.dart';
import 'packing_sku_list_item.dart';
import 'package:parsel_flutter/models/packing_list_model.dart' as packing;

class PackingListDetailPage extends StatefulWidget {
  final List<packing.ItemList>? itemList;
  final String? salesID;
  final String? skuCount;

  // Data? data;

  PackingListDetailPage({
    Key? key,
    required this.itemList,
    this.salesID,
    // required this.data,
    this.skuCount,
  }) : super(key: key);

  @override
  State<PackingListDetailPage> createState() => _PackingListDetailPageState();
}

class _PackingListDetailPageState extends State<PackingListDetailPage> {
  TextEditingController boxNameController = TextEditingController();

  List<pl.ItemList>? itemList = [];
  pl.Data? data;

  String _scanBarcode = '';

  int? index1 = 0;

  bool? _isLoading;

  Future<void> scanQR() async {
    String barcodeScanRes = '';
    // Platform messages may fail, so we use a try/catch PlatformException.
    // try {
    //   var configuration = BarcodeScannerConfiguration();
    //   var result = await ScanbotBarcodeSdk.startBarcodeScanner(configuration);
    //   // barcodeScanRes = await ScanbotBarcodeSdk.startBarcodeScanner(
    //   //     '#ff6666', 'Cancel', true, ScanMode.QR);
    //   barcodeScanRes = result.message ?? 'Failed to get platform version.';
    // } on PlatformException {
    //   barcodeScanRes = 'Failed to get platform version.';
    // }
    if (!mounted) return;
    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  String? userId = '';

  Future<void> getUserId() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    userId = sp.getString('userID');
    setState(() {});
  }

  // Future getPickingList(BuildContext context) async {
  //   return await API.getSTORAGEOrderList(
  //       context, 'STORAGE', 'PENDING', userId!);
  // }

  Future getPackingList(BuildContext context) async {
    final preference = await SharedPreferences.getInstance();
    return await API.getPACKINGList(context, 'PACKING', 'ON_GOING', userId!,
        Authtoken: preference.getString("token").toString());
  }

  Future performActionPickPack(
      BuildContext context, String salesOrderId, String status) async {
    final preference = await SharedPreferences.getInstance();
    setState(() {
      _isLoading = true;
    });
    return await API
        .performActionOnPICKPACK(
            context, salesOrderId, boxNameController.text, status,
            Authtoken: preference.getString("token").toString())
        .then(
      (PickPackPerformActionModal? response) async {
        setState(() {
          _isLoading = false;
        });
        print('PERFORM_PP_response-->' + response.toString());
        if (response!.message != null) {
          AppHelper.showSnackBar(context, response.message.toString());
        } else {
          AppHelper.showSnackBar(context, response.message.toString());
        }
      },
    ).onError((error, stackTrace) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title:
            Text(AppStrings.strPackingList, style: AppStyles.appBarTitleStyle),
        leading: GestureDetector(
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Container(
              height: 15,
              width: 15,
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                iconSize: 20.0,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 35),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          //Sales Order
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                AppStrings.strSalesOrder,
                                style: const TextStyle(
                                    fontFamily: appFontFamily,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    color: AppColors.blueColor),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Container(
                                height: 35,
                                child: VerticalDivider(
                                  thickness: 2,
                                ),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: Container(
                                  height: 50,
                                  child: TextFormField(
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      hintText: widget.salesID,
                                      fillColor: Colors.grey,
                                      focusColor: Colors.grey,
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        borderSide: const BorderSide(
                                          color: Colors.grey,
                                          width: 1.0,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        borderSide: const BorderSide(
                                          color: Colors.grey,
                                          width: 1.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(
                            height: 10,
                          ),

                          //Sku Count
                          Row(
                            children: [
                              Text(
                                AppStrings.strSkuCount,
                                style: TextStyle(
                                    fontFamily: appFontFamily,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    color: AppColors.blueColor),
                              ),
                              const SizedBox(
                                width: 25,
                              ),
                              Container(
                                height: 40,
                                child: VerticalDivider(
                                  thickness: 2,
                                ),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: Container(
                                  height: 50,
                                  child: TextFormField(
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      hintText:
                                          widget.itemList!.length.toString(),
                                      fillColor: Colors.grey,
                                      focusColor: Colors.grey,
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                          width: 1.0,
                                        ),
                                      ),
                                      // focusedBorder: OutlineInputBorder(
                                      //   borderRadius:
                                      //       BorderRadius.circular(8.0),
                                      //   borderSide: BorderSide(
                                      //     color: Colors.grey,
                                      //     width: 1.0,
                                      //   ),
                                      // ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(
                            height: 10,
                          ),

                          //Sku Count
                          Row(
                            children: [
                              Text(
                                AppStrings.strBoxName,
                                style: TextStyle(
                                    fontFamily: appFontFamily,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    color: AppColors.blueColor),
                              ),
                              const SizedBox(
                                width: 25,
                              ),
                              Container(
                                height: 40,
                                child: VerticalDivider(
                                  thickness: 2,
                                ),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter box name!';
                                    }
                                    return null;
                                  },
                                  controller: boxNameController,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 0),
                                    hintText: 'Enter Box name',
                                    hintStyle: TextStyle(fontSize: 15),
                                    fillColor: Colors.grey,
                                    focusColor: Colors.grey,
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: BorderSide(
                                        color: Colors.red,
                                        // width: 1.0,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: BorderSide(
                                        color: Colors.grey,
                                        width: 1.0,
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: BorderSide(
                                        color: Colors.grey,
                                        width: 1.0,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: BorderSide(
                                        color: Colors.grey,
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                    PackingSkuListItem(
                      itemList: widget.itemList!,
                    ),
                  ],
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                scanQR();
              });
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: AppColors.black2Color,
              ),
              margin: EdgeInsets.only(top: 20, bottom: 13, right: 20),
              height: MediaQuery.of(context).size.height * 0.07,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('SCAN QR CODE', style: AppStyles.inwardTextSCANStyle),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.qr_code_scanner,
                    color: Colors.white,
                  )
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              if (_formKey.currentState!.validate()) {
                AppHelper.showAlert(
                    '', 'CONFIRMED', context, InventoryDashboardScreen());
                performActionPickPack(
                    context, widget.salesID.toString(), 'CONFIRMED');
              }
            },
            child: Container(
              height: 60,
              decoration: const BoxDecoration(
                color: AppColors.blueColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0)),
              ),
              width: double.infinity,
              child: Center(
                child: Text(
                  AppStrings.strConfirmPacking,
                  style: AppStyles.buttonTextStyle,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
