// import 'package:barcode_scanner/scanbot_barcode_sdk_v2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:intl/intl.dart';
import 'package:parsel_flutter/api/api.dart';
import 'package:parsel_flutter/models/inward_perform_action_model.dart';
import 'package:parsel_flutter/models/locationDropdown_model.dart' as lo;
import 'package:parsel_flutter/resource/app_styles.dart';
import 'package:parsel_flutter/screens/InventoryMenu/InventoryDashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/InwardList_model.dart' as In;
import '../../../resource/app_colors.dart';
import '../../../resource/app_helper.dart';
import '../../../resource/app_strings.dart';

class InwardScreen extends StatefulWidget {
  final In.ResultList itemList;
  // final lo.ResultList listLocation;
  const InwardScreen({
    Key? key,
    required this.itemList,
    // required this.listLocation,
  }) : super(key: key);

  @override
  State<InwardScreen> createState() => _InwardScreenState();
}

class _InwardScreenState extends State<InwardScreen> {
  Color scaffoldBackgroundColor = Colors.white;
  final _formKey = GlobalKey<FormState>();
  final List<FocusNode> _focusNodes = [
    FocusNode(),
    // FocusNode(),
  ];
  var isLoading;
  final List<lo.ResultList> _listLocation = [];
  List<In.ResultList> itemList = [];
  String _scanBarcode = 'Unknown';
  String? scanResult;
  String? selectedValue1;
  lo.ResultList? dropdownValue;
  bool isSelect = true;
  int index = 0;
  int index1 = 0;
  var _isLoading = false;
  List<String> inwardList = [
    'PURCHASE ORDER',
    'BARCODE ID',
    'SKU NAME',
    'QUANTITY',
    'BATCH',
    'AGING',
    'LOCATION',
  ];

  DateTime selectedDate = DateTime.now();
  String userId = '';

  String? barcodeId;

  List<In.ResultList> _resultList2 = [];

  String? productCode = '';

  String? skuName = '';

  String? qty = '';

  String? batch = '';

  String? bID;

  String? ag_yyyy;

  String? ag_mm;

  String? ag_dd;

  TextEditingController qtycontroller = TextEditingController();
  TextEditingController batchcontroller = TextEditingController();

  int? valuebatch;

  int? binIdIndex;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2022, 8),
        lastDate: DateTime(2026, 12));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  // List<num>? rolist = [];
  String rolist = '';
  @override
  void initState() {
    getLocationDropDown(context);
    super.initState();
    bID = barcodeId;
    // ag_yyyy = widget.itemList.itemList![index].aging![0].toString();
    // if (widget.itemList.itemList![index].aging![1].toString().length != 2) {
    //   ag_mm = '0' + widget.itemList.itemList![index].aging![1].toString();
    // } else {
    //   ag_mm = widget.itemList.itemList![index].aging![1].toString();
    // }
    // if (widget.itemList.itemList![index].aging![2].toString().length != 2) {
    //   ag_dd = '0' + widget.itemList.itemList![index].aging![2].toString();
    // } else {
    //   ag_dd = widget.itemList.itemList![index].aging![2].toString();
    // }
  }

  Future<void> getUserId() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    userId = sp.getString('userID').toString();
    setState(() {});
  }

  Future performAction(BuildContext context, String poId, String productCode,
      String binid, String type, String batch, String date) async {
    setState(() {
      _isLoading = true;
    });
    return await API
        .performAction(
            context, poId, productCode, 'CONFIRMED', binid, type, batch, date)
        .then(
      (InwardPerformActionModel? response) async {
        setState(() {
          _isLoading = false;
        });
        print('rsponse-->' + response.toString());
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

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  Widget saleBarcodeTextfield(index) {
    return Container(
      height: 40,
      padding: const EdgeInsets.only(right: 10),
      alignment: Alignment.centerRight,
      margin: const EdgeInsets.only(left: 20, top: 10, bottom: 5),
      width: MediaQuery.of(context).size.width * 0.45,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [const BoxShadow(color: Colors.black12, spreadRadius: 1)]),
      child: Text(
        inwardList[index] == 'PURCHASE ORDER'
            ? widget.itemList.poId.toString()
            : inwardList[index] == 'BARCODE ID'
                ? '6537987654'
                // widget.itemList.itemList![0].skuDetails!.barCodeId.toString()
                // : inwardList[index] == 'BATCH'
                //     ? batch.toString()
                : inwardList[index] == 'QUANTITY'
                    ? qty.toString()
                    : skuName.toString(),
        style: AppStyles.inwardTextDATAStyle,
      ),
    );
  }

  quantityBatchTextField(index) {
    return Container(
        height: 40,
        padding: const EdgeInsets.only(right: 10),
        alignment: Alignment.centerRight,
        margin: const EdgeInsets.only(left: 20, top: 10, bottom: 5),
        width: MediaQuery.of(context).size.width * 0.45,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              const BoxShadow(color: Colors.black12, spreadRadius: 1)
            ]),
        child: TextFormField(
          readOnly: true,
          initialValue: inwardList[index] == 'BATCH' ? batch : qty,
          // "widget.itemList[index].itemList![0].qty.toString()",
          textAlign: TextAlign.end,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintStyle: AppStyles.inwardTextDATAStyle,
          ),
        ));
  }

  quantityText() {
    return Container(
      height: 40,
      padding: const EdgeInsets.only(right: 10),
      // alignment: Alignment.centerRight,
      margin: const EdgeInsets.only(left: 20, top: 10, bottom: 5),
      width: MediaQuery.of(context).size.width * 0.45,
      child: TextFormField(
          keyboardType: TextInputType.number,
          controller: qtycontroller,
          decoration: InputDecoration(
            hintText: "0",
            fillColor: Colors.white,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(
                color: Colors.black12,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(
                color: Colors.black12,
                width: 2.0,
              ),
            ),
          )),
    );
  }

  batchText() {
    return Container(
      height: 40,
      padding: const EdgeInsets.only(right: 10),
      // alignment: Alignment.centerRight,
      margin: const EdgeInsets.only(left: 20, top: 10, bottom: 5),
      width: MediaQuery.of(context).size.width * 0.45,
      child: TextFormField(
        controller: batchcontroller,
        focusNode: _focusNodes[0],
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            filled: true,
            hintText: 'Batch',
            fillColor: Colors.white,
            focusColor: Colors.grey),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please Enter Batch';
          }
          return null;
        },
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
        padding: const EdgeInsets.only(right: 10),
        alignment: Alignment.centerRight,
        margin: const EdgeInsets.only(left: 20, top: 10, bottom: 5),
        width: MediaQuery.of(context).size.width * 0.45,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              const BoxShadow(color: Colors.black12, spreadRadius: 1)
            ]),
        child: Text(
          // DateFormat('yyyy-MM-dd').format((DateTime.now())).toString(),
          // "$ag_dd-$ag_mm-$ag_yyyy",
          // widget.itemList.itemList![index].aging.toString(),
          "${DateFormat('dd-MM-yyyy').format((selectedDate))}".split(' ')[0],
          style: AppStyles.inwardTextSKUOrders,
        ),
      ),
    );
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

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      appBar: AppHelper.appBar(
          context, 'INWARD', InventoryDashboardScreen(), Icons.arrow_back_ios),
      body: Form(
        key: _formKey,
        child: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                // color: AppColors.lightBlueColor,
                color: scaffoldBackgroundColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    (Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        margin: const EdgeInsets.only(
                            top: 16, bottom: 16, left: 20),
                        height: MediaQuery.of(context).size.height * 0.08,
                        padding:
                            const EdgeInsets.only(top: 8, left: 10, right: 5),
                        child: TextFormField(
                          readOnly: true,
                          decoration: InputDecoration(
                              enabledBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 2),
                              ),
                              filled: true,
                              hintText: widget
                                  .itemList.itemList![index].skuDetails!.name
                                  .toString(),
                              hintStyle: AppStyles.inwardTextSKUOrders,
                              fillColor: Colors.white,
                              focusColor: Colors.white),
                        ),
                      ),
                    )),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      flex: 1,
                      child: InkWell(
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
                          margin: const EdgeInsets.only(
                              top: 20, bottom: 13, right: 20),
                          height: MediaQuery.of(context).size.height * 0.07,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('SCAN QR CODE',
                                  style: AppStyles.inwardTextSCANStyle),
                              const SizedBox(
                                width: 10,
                              ),
                              const Icon(
                                Icons.qr_code_scanner,
                                color: Colors.white,
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 13),
                // color: AppColors.whiteColor,
                color: scaffoldBackgroundColor,
                height: MediaQuery.of(context).size.height * 0.82,
                width: double.infinity,
                child: Column(
                  children: [
                    IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            inwardList[0],
                            style: AppStyles.inwardTextBLUEStyle,
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 10),
                                  height: 40,
                                  child: const VerticalDivider(
                                    thickness: 2,
                                  ),
                                ),
                                Expanded(child: saleBarcodeTextfield(0))
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
                            inwardList[1],
                            style: AppStyles.inwardTextBLUEStyle,
                          ),
                          Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 10),
                                height: 40,
                                child: const VerticalDivider(
                                  thickness: 2,
                                ),
                              ),
                              saleBarcodeTextfield(1)
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
                            inwardList[2],
                            style: AppStyles.inwardTextBLUEStyle,
                          ),
                          Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 10),
                                height: 40,
                                child: const VerticalDivider(
                                  thickness: 2,
                                ),
                              ),
                              Container(
                                height: 40,
                                padding: const EdgeInsets.only(right: 10),
                                alignment: Alignment.centerRight,
                                margin: const EdgeInsets.only(
                                    left: 20, top: 10, bottom: 5),
                                width: MediaQuery.of(context).size.width * 0.45,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      const BoxShadow(
                                          color: Colors.black12,
                                          spreadRadius: 1)
                                    ]),
                                child: Text(
                                  widget.itemList.itemList![index].skuDetails!
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
                    IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            inwardList[3],
                            style: AppStyles.inwardTextBLUEStyle,
                          ),
                          Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 10),
                                height: 40,
                                child: const VerticalDivider(
                                  thickness: 2,
                                ),
                              ),
                              // saleBarcodeTextfield(3)
                              Container(
                                height: 40,
                                padding: const EdgeInsets.only(right: 10),
                                alignment: Alignment.centerRight,
                                margin: const EdgeInsets.only(
                                    left: 20, top: 10, bottom: 5),
                                width: MediaQuery.of(context).size.width * 0.45,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      const BoxShadow(
                                          color: Colors.black12,
                                          spreadRadius: 1)
                                    ]),
                                child: Text(
                                  widget.itemList.itemList![index].qty
                                      .toString(),
                                  style: AppStyles.inwardTextDATAStyle,
                                ),
                              )
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
                            inwardList[4],
                            style: AppStyles.inwardTextBLUEStyle,
                          ),
                          Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 10),
                                height: 40,
                                child: const VerticalDivider(
                                  thickness: 2,
                                ),
                              ),
                              batchText()
                              // Container(
                              //   height: 40,
                              //   padding: EdgeInsets.only(right: 10),
                              //   alignment: Alignment.centerRight,
                              //   margin:
                              //       EdgeInsets.only(left: 20, top: 10, bottom: 5),
                              //   width: MediaQuery.of(context).size.width * 0.45,
                              //   decoration: BoxDecoration(
                              //       color: Colors.white,
                              //       borderRadius: BorderRadius.circular(8),
                              //       boxShadow: [
                              //         BoxShadow(
                              //             color: Colors.black12, spreadRadius: 1)
                              //       ]),
                              //   child: Text(
                              //     widget.itemList.itemList![index].batch
                              //         .toString(),
                              //     style: AppStyles.inwardTextDATAStyle,
                              //   ),
                              // )
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
                            inwardList[5],
                            style: AppStyles.inwardTextBLUEStyle,
                          ),
                          Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 10),
                                height: 40,
                                child: const VerticalDivider(
                                  thickness: 2,
                                ),
                              ),
                              agingTextField()
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
                            inwardList[6],
                            style: AppStyles.inwardTextBLUEStyle,
                          ),
                          Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 10),
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
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          height: 50,
                          width: 110,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.black12,
                                    spreadRadius: 1,
                                    blurRadius: 5)
                              ]),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    isSelect = true;
                                  });
                                },
                                child: isSelect == true
                                    ? const Icon(
                                        Icons.radio_button_checked,
                                        color: AppColors.blueColor,
                                      )
                                    : const Icon(
                                        Icons.radio_button_off,
                                        color: AppColors.blueColor,
                                      ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Goods',
                                style: AppStyles.goodConsumableStyle,
                              )
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          height: 50,
                          width: 130,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                const BoxShadow(
                                    color: Colors.black12,
                                    spreadRadius: 1,
                                    blurRadius: 5)
                              ]),
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 5,
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    isSelect = false;
                                  });
                                },
                                child: isSelect == false
                                    ? const Icon(
                                        Icons.radio_button_checked,
                                        color: AppColors.blueColor,
                                      )
                                    : const Icon(
                                        Icons.radio_button_off,
                                        color: AppColors.blueColor,
                                      ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                'Consumable',
                                style: AppStyles.goodConsumableStyle,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            scaffoldBackgroundColor = Colors.red;
                            setState(() {});
                          },
                          child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: const Text(
                                'Error',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              )),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        GestureDetector(
                          onTap: () {
                            scaffoldBackgroundColor = Colors.green;
                            setState(() {});
                          },
                          child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: const Text(
                                'Success',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              )),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        )),
      ),
      bottomNavigationBar: InkWell(
        onTap: () {
          print('binId-->' + _listLocation[binIdIndex as int].id.toString());
          print('Date-->' + DateFormat('yyyy-MM-dd').format((selectedDate)));
          print('batch-->' + batchcontroller.text);
          if (_formKey.currentState!.validate()) {
            isSelect == true
                ? performAction(
                    context,
                    widget.itemList.poId.toString(),
                    widget.itemList.itemList![index1].productCode.toString(),
                    _listLocation[binIdIndex as int].id.toString(),
                    'GOODS',
                    batchcontroller.text,
                    DateFormat('yyyy-MM-dd').format((selectedDate)))
                : performAction(
                    context,
                    widget.itemList.poId.toString(),
                    widget.itemList.itemList![index1].productCode.toString(),
                    _listLocation[binIdIndex as int].id.toString(),
                    'CONSUMABLE',
                    batchcontroller.text,
                    DateFormat('yyyy-MM-dd').format((selectedDate)));
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => InventoryDashboardScreen()));
          }
        },
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: const Radius.circular(4)),
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
