// import 'package:barcode_scanner/scanbot_barcode_sdk_v2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_enhanced_barcode_scanner/flutter_enhanced_barcode_scanner.dart';

import 'package:parsel_flutter/api/api.dart';
import 'package:parsel_flutter/models/ExecuteStorage_model.dart';
import 'package:parsel_flutter/resource/app_styles.dart';
import 'package:parsel_flutter/screens/InventoryMenu/InventoryDashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/BinMaster_modal.dart';
import '../../../models/Storage_model.dart' as so;
import '../../../models/locationDropdown_model.dart' as lo;
import '../../../resource/app_colors.dart';
import '../../../resource/app_helper.dart';
import '../../../resource/app_strings.dart';

class StorageDetailScreen extends StatefulWidget {
  final so.ResultList? itemList;

  const StorageDetailScreen({
    Key? key,
    this.itemList,
  }) : super(key: key);

  @override
  State<StorageDetailScreen> createState() => _StorageDetailScreenState();
}

class _StorageDetailScreenState extends State<StorageDetailScreen> {
  var isLoading;
  final List<lo.ResultList> _listLocation = [];
  List<ResultList>? itemList = [];
  String _scanBarcode = 'Unknown';
  String? scanResult;
  String? selectedValue1;
  lo.ResultList? dropdownValue;
  bool isSelect = true;
  int? indexResult = 0;
  int index1 = 0;
  var _isLoading = false;
  String userId = '';
  int? binIdIndex;

  List<String> storageList = [
    'PURCHASE ORDER',
    'SKU NAME',
    'QUANTITY',
    'BATCH',
    'SKU TYPE',
    'CURRENT\n LOCATION',
    'SUGGESTED\n LOCATION',
    'SCAN MANUAL\n LOCATION'
  ];

  DateTime selectedDate = DateTime.now();

  String? barcodeId;

  List<so.ResultList>? _resultList = [];

  String? skuName = '';

  List<ResultList>? _resultList1 = [];

  int? binID = 0;

  @override
  void initState() {
    super.initState();
    getStorageSku(context);
    getBinMaster(context);
    getLocationDropDown(context);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2023));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future getLocationDropDown(BuildContext context) async {
    final preference = await SharedPreferences.getInstance();
    setState(() {});
    return await API.getLocationDropDownList(context).then(
      (lo.LocationDropDownModel? response) async {
        setState(() {});
        print('response-->' + response.toString());
        if (response != null) {
          response.data!.resultList!.map((e) => _listLocation.add(e)).toList();
        } else {
          AppHelper.showSnackBar(context, AppStrings.strSomethingWentWrong);
        }
      },
    ).onError((error, stackTrace) {
      setState(() {});
    });
  }

  dropDownMenu() {
    return Container(
      height: 40,
      padding: const EdgeInsets.only(right: 10),
      alignment: Alignment.centerRight,
      margin: const EdgeInsets.only(left: 20, top: 10, bottom: 5),
      width: MediaQuery.of(context).size.width * 0.45,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 1)]),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<lo.ResultList>(
            hint: const Text("location"),
            value: dropdownValue,
            icon: const Icon(
              Icons.arrow_drop_down,
              size: 30,
            ),
            // elevation: 16,
            style: const TextStyle(color: Colors.black),
            onChanged: (lo.ResultList? newValue) {
              setState(() {
                dropdownValue = newValue!;
                binIdIndex = _listLocation.indexOf(dropdownValue!);
                print('Index of Location-->' + binIdIndex.toString());
              });
            },
            items: _listLocation.map((item) {
              return DropdownMenuItem<lo.ResultList>(
                value: item,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.30,
                  child: Text(
                    item.binLocation.toString(),
                    style: AppStyles.inwardTextSKUOrders,
                  ),
                ),
              );
            }).toList()),
      ),
    );
  }

  Future getBinMaster(BuildContext context) async {
    setState(() {});
    return await API.getBinMAster(context).then(
      (BinMasterModal? response) async {
        setState(() {});
        if (response != null) {
          binID = response.data!.resultList![0].id;
          // !.map((e) => _resultList1!.add(e)).toList();
        } else {
          AppHelper.showSnackBar(context, AppStrings.strSomethingWentWrong);
        }
      },
    ).onError((error, stackTrace) {
      setState(() {});
    });
  }

  Future performAction(BuildContext context, String poId, String productCode,
      String binID) async {
    setState(() {
      _isLoading = true;
    });
    return await API.executeStorage(context, poId, productCode, binID).then(
      (ExecuteStorageModal? response) async {
        setState(() {
          _isLoading = false;
        });
        print('response_Execute_Storage-->' + response.toString());
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

  Future getStorageSku(BuildContext context) async {
    final preference = await SharedPreferences.getInstance();
    setState(() {});
    return await API
        .getSTORAGEOrderList(context, 'STORAGE', 'PENDING', userId)
        .then(
      (so.StorageModal? response) async {
        setState(() {});
        if (response != null) {
          skuName = response.body!.purchaseOrderList!.resultList![indexResult!]
              .itemList![index1].skuDetails!.name
              .toString();
          // .map((e) => _resultList!.add(e))
          // .toList();
          print('skuName-->' + skuName.toString());
        } else {
          AppHelper.showSnackBar(context, AppStrings.strSomethingWentWrong);
        }
      },
    ).onError((error, stackTrace) {
      setState(() {});
    });
  }

  Future<void> getUserId() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    userId = sp.getString('userID') as String;

    setState(() {});
  }

  Future<void> scanQR() async {
    String barcodeScanRes = '';

    // TODO: configure as needed

    // try {
    //   var configuration = BarcodeScannerConfiguration();
    //   var result = await ScanbotBarcodeSdk.startBarcodeScanner(configuration);
    //   // barcodeScanRes = await ScanbotBarcodeSdk.startBarcodeScanner(
    //   //     '#ff6666', 'Cancel', true, ScanMode.QR);
    //   barcodeScanRes = result.message ?? 'Failed to get platform version.';
    //   print(barcodeScanRes);
    // } on PlatformException {
    //   barcodeScanRes = 'Failed to get platform version.';
    // }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  Widget saleBarcodeTextfield(index, index1) {
    return Container(
      height: 40,
      padding: EdgeInsets.only(right: 10),
      alignment: Alignment.centerRight,
      margin: EdgeInsets.only(left: 20, top: 10, bottom: 5),
      width: MediaQuery.of(context).size.width * 0.45,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 1)]),
      child: Text(
        storageList[index] == 'PURCHASE ORDER'
            ? widget.itemList!.poId.toString()
            : storageList[index] == 'BATCH'
                ? widget.itemList!.itemList![index1].batch.toString()
                // : storageList[index] == 'STATUS'
                //     ? widget.itemList!.itemList![index1].status.toString()
                : storageList[index] == 'SKU TYPE'
                    ? widget.itemList!.itemList![index1].type.toString()
                    : storageList[index] == 'CURRENT\n LOCATION'
                        ? widget
                            .itemList!.itemList![index1].binMaster!.binLocation
                            .toString()
                        // : storageList[index] == 'SUGGESTED\n LOCATION'
                        //     ? widget.itemList!.itemList![index1].type.toString()
                        : widget.itemList!.itemList![index1].qty.toString(),
        style: AppStyles.inwardTextDATAStyle,
      ),
    );
  }

  agingTextField() {
    return InkWell(
      onTap: () {
        setState(() {
          _selectDate(context);
        });
      },
      child: Container(
        height: 40,
        padding: EdgeInsets.only(right: 10),
        alignment: Alignment.centerRight,
        margin: EdgeInsets.only(left: 20, top: 10, bottom: 5),
        width: MediaQuery.of(context).size.width * 0.45,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 1)]),
        child: Text(
          "${selectedDate.toLocal()}".split(' ')[0],
          style: AppStyles.inwardTextSKUOrders,
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppHelper.appBar(
          context, 'STORAGE', InventoryDashboardScreen(), Icons.arrow_back_ios),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30, vertical: 13),
              color: AppColors.whiteColor,
              height: MediaQuery.of(context).size.height * 0.82,
              width: double.infinity,
              child: Column(
                children: [
                  IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          storageList[0],
                          style: AppStyles.inwardTextBLUEStyle,
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                height: 40,
                                child: VerticalDivider(
                                  thickness: 2,
                                ),
                              ),
                              Expanded(child: saleBarcodeTextfield(0, index1))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          storageList[1],
                          style: AppStyles.inwardTextBLUEStyle,
                        ),
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              height: 40,
                              child: VerticalDivider(
                                thickness: 2,
                              ),
                            ),
                            Container(
                              height: 40,
                              padding: EdgeInsets.only(right: 10),
                              alignment: Alignment.centerRight,
                              margin:
                                  EdgeInsets.only(left: 20, top: 10, bottom: 5),
                              width: MediaQuery.of(context).size.width * 0.45,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black12, spreadRadius: 1)
                                  ]),
                              child: Text(
                                widget.itemList!.itemList![index1].skuDetails!
                                    .name
                                    .toString(),
                                style: AppStyles.inwardTextDATAStyle,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  // IntrinsicHeight(
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       Text(
                  //         storageList[2],
                  //         style: AppStyles.inwardTextBLUEStyle,
                  //       ),
                  //       Row(
                  //         children: [
                  //           Container(
                  //             margin: EdgeInsets.only(top: 10),
                  //             height: 40,
                  //             child: VerticalDivider(
                  //               thickness: 2,
                  //             ),
                  //           ),
                  //           saleBarcodeTextfield(2, index1)
                  //         ],
                  //       ),
                  //     ],
                  //   ),
                  // ),

                  IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          storageList[2],
                          style: AppStyles.inwardTextBLUEStyle,
                        ),
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              height: 40,
                              child: VerticalDivider(
                                thickness: 2,
                              ),
                            ),
                            saleBarcodeTextfield(2, index1)
                          ],
                        ),
                      ],
                    ),
                  ),
                  IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          storageList[3],
                          style: AppStyles.inwardTextBLUEStyle,
                        ),
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              height: 40,
                              child: VerticalDivider(
                                thickness: 2,
                              ),
                            ),
                            saleBarcodeTextfield(3, index1)
                          ],
                        ),
                      ],
                    ),
                  ),
                  IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          storageList[4],
                          style: AppStyles.inwardTextBLUEStyle,
                        ),
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              height: 40,
                              child: VerticalDivider(
                                thickness: 2,
                              ),
                            ),
                            saleBarcodeTextfield(4, index1)
                          ],
                        ),
                      ],
                    ),
                  ),
                  IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          storageList[5],
                          style: AppStyles.inwardTextBLUEStyle,
                        ),
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              height: 40,
                              child: const VerticalDivider(
                                thickness: 2,
                              ),
                            ),
                            saleBarcodeTextfield(5, index1)
                          ],
                        ),
                      ],
                    ),
                  ),
                  IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          storageList[6],
                          style: AppStyles.inwardTextBLUEStyle,
                        ),
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              height: 40,
                              child: const VerticalDivider(
                                thickness: 2,
                              ),
                            ),
                            dropDownMenu()
                          ],
                        ),
                      ],
                    ),
                  ),
                  IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          storageList[7],
                          style: AppStyles.inwardTextBLUEStyle,
                        ),
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              height: 40,
                              child: const VerticalDivider(
                                thickness: 2,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  scanQR();
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: AppColors.black2Color,
                                ),
                                height: 40,
                                padding: EdgeInsets.only(right: 10),
                                alignment: Alignment.centerRight,
                                margin: EdgeInsets.only(
                                    left: 20, top: 10, bottom: 5),
                                width: MediaQuery.of(context).size.width * 0.45,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('SCAN QR CODE',
                                        style: AppStyles.inwardTextSCANStyle),
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
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ],
        ),
      )),
      bottomNavigationBar: InkWell(
        onTap: () {
          performAction(
            context,
            widget.itemList!.poId.toString(),
            widget.itemList!.itemList![index1].productCode.toString(),
            _listLocation[binIdIndex as int].id.toString(),
          );
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => InventoryDashboardScreen()));
        },
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(4)),
                  color: AppColors.blueColor,
                ),
                alignment: Alignment.center,
                height: 70,
                child: Text(
                  'SUBMIT',
                  style: AppStyles.submitButtonStyle,
                ),
              ),
      ),
    );
  }
}
