import 'package:flutter/material.dart';
import 'package:parsel_flutter/utils/utils.dart';
import 'package:parsel_flutter/models/despatch_sum_item.dart';
import 'package:parsel_flutter/resource/app_colors.dart';
import 'package:parsel_flutter/resource/app_fonts.dart';
import 'package:provider/provider.dart';

import '../../Provider/Delivery_Controller.dart';

class DeliverySummary extends StatefulWidget {
  DeliverySummary(
      {Key? key, required List<DespatchSummaryItem> deliverySummaryList})
      : _deliverySummaryList = deliverySummaryList,
        super(key: key);
  List<DespatchSummaryItem> _deliverySummaryList;

  @override
  State<DeliverySummary> createState() => _DeliverySummaryState();
}

class _DeliverySummaryState extends State<DeliverySummary> {
  TextEditingController _controllers1 = TextEditingController();
  TextEditingController _controllers2 = TextEditingController();
  TextEditingController _controllers3 = TextEditingController();
  TextEditingController _controllers4 = TextEditingController();
  TextEditingController _controllers5 = TextEditingController();
  TextEditingController _controllers6 = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      print("WidgetsBinding.instance");
      _controllers1.text = widget._deliverySummaryList[0].value;
      _controllers4.text = widget._deliverySummaryList[3].value;
      _controllers5.text = widget._deliverySummaryList[4].value;
      _controllers6.text = widget._deliverySummaryList[5].value;
      _controllers2.clear();
      _controllers3.clear();
      var list = Provider.of<DeliveryController>(context, listen: false);
      list.addTotalReturned();
      list.addTotalDeliverd();
    });
    super.initState();
  }

  int totalretured = 0;
  int totalDelivered = 0;
  @override
  Widget build(BuildContext context) {
    //   return Container();
    // }

    return Consumer<DeliveryController>(builder: (context, Ddata, child) {
      if (_controllers3.text.isEmpty) {
        _controllers3.text = Ddata.totalRetured.toString();
      }

      if (_controllers2.text.isEmpty) {
        _controllers2.text = Ddata.totalDeliverd.toString();
      }

      return ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 30.0, right: 30.0),
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    const Expanded(
                        flex: 2,
                        child: Text(
                          "INVOICE VALUE",
                          style: TextStyle(
                            color: AppColors.blueColor,
                            fontFamily: appFontFamily,
                            fontWeight: FontWeight.w400,
                            fontSize: 12.0,
                          ),
                        )),
                    Visibility(
                      visible: true,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Container(
                          color: ColorUtils.kTextFieldBorderColor,
                          width: 2.0,
                          height: 50.0,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: TextFormField(
                        maxLines: 1,
                        controller: _controllers1,
                        keyboardType: TextInputType.number,
                        onChanged: (text) {
                          //  item.value;
                        },
                        style: const TextStyle(
                          color: AppColors.dashBoardText,
                          fontFamily: appFontFamily,
                          fontWeight: FontWeight.w400,
                          fontSize: 14.0,
                        ),
                        decoration: InputDecoration(
                          // contentPadding:
                          // EdgeInsets.only(left: 15.0, right: 0.0, top: 0.0, bottom: 0.0),
                          contentPadding: const EdgeInsets.only(
                              left: 15.0, right: 0.0, top: 0.0, bottom: 0.0),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 30.0, right: 30.0),
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    const Expanded(
                        flex: 2,
                        child: Text(
                          "DELIVERED",
                          style: TextStyle(
                            color: AppColors.blueColor,
                            fontFamily: appFontFamily,
                            fontWeight: FontWeight.w400,
                            fontSize: 12.0,
                          ),
                        )),
                    Visibility(
                      visible: true,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Container(
                          color: ColorUtils.kTextFieldBorderColor,
                          width: 2.0,
                          height: 50.0,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: TextFormField(
                        readOnly: true,
                        maxLines: 1,
                        controller: _controllers2,
                        keyboardType: TextInputType.number,
                        onChanged: (text) {
                          //  item.value;
                        },
                        style: const TextStyle(
                          color: AppColors.dashBoardText,
                          fontFamily: appFontFamily,
                          fontWeight: FontWeight.w400,
                          fontSize: 14.0,
                        ),
                        decoration: InputDecoration(
                          // contentPadding:
                          // EdgeInsets.only(left: 15.0, right: 0.0, top: 0.0, bottom: 0.0),
                          contentPadding: const EdgeInsets.only(
                              left: 15.0, right: 0.0, top: 0.0, bottom: 0.0),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                            borderSide: BorderSide(
                              color: Colors.transparent,
                              width: 0.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 30.0, right: 30.0),
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    const Expanded(
                        flex: 2,
                        child: const Text(
                          "RETURNED",
                          style: TextStyle(
                            color: AppColors.blueColor,
                            fontFamily: appFontFamily,
                            fontWeight: FontWeight.w400,
                            fontSize: 12.0,
                          ),
                        )),
                    Visibility(
                      visible: true,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Container(
                          color: ColorUtils.kTextFieldBorderColor,
                          width: 2.0,
                          height: 50.0,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: TextFormField(
                        readOnly: true,
                        maxLines: 1,
                        controller: _controllers3,
                        keyboardType: TextInputType.number,
                        onChanged: (text) {
                          //  item.value;
                        },
                        style: const TextStyle(
                          color: AppColors.dashBoardText,
                          fontFamily: appFontFamily,
                          fontWeight: FontWeight.w400,
                          fontSize: 14.0,
                        ),
                        decoration: const InputDecoration(
                          // contentPadding:
                          // EdgeInsets.only(left: 15.0, right: 0.0, top: 0.0, bottom: 0.0),
                          contentPadding: EdgeInsets.only(
                              left: 15.0, right: 0.0, top: 0.0, bottom: 0.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                            borderSide: BorderSide(
                              color: Colors.transparent,
                              width: 0.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 30.0, right: 30.0),
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    const Expanded(
                        flex: 2,
                        child: Text(
                          "NO OF BOXES",
                          style: TextStyle(
                            color: AppColors.blueColor,
                            fontFamily: appFontFamily,
                            fontWeight: FontWeight.w400,
                            fontSize: 12.0,
                          ),
                        )),
                    Visibility(
                      visible: true,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Container(
                          color: ColorUtils.kTextFieldBorderColor,
                          width: 2.0,
                          height: 50.0,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: TextFormField(
                        maxLines: 1,
                        controller: _controllers4,
                        keyboardType: TextInputType.number,
                        onChanged: (text) {
                          //  item.value;
                        },
                        style: const TextStyle(
                          color: AppColors.dashBoardText,
                          fontFamily: appFontFamily,
                          fontWeight: FontWeight.w400,
                          fontSize: 14.0,
                        ),
                        decoration: const InputDecoration(
                          // contentPadding:
                          // EdgeInsets.only(left: 15.0, right: 0.0, top: 0.0, bottom: 0.0),
                          contentPadding: EdgeInsets.only(
                              left: 15.0, right: 0.0, top: 0.0, bottom: 0.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                            borderSide: BorderSide(
                              color: Colors.transparent,
                              width: 0.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 30.0, right: 30.0),
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    const Expanded(
                        flex: 2,
                        child: Text(
                          "SKU TEMPERATURE",
                          style: TextStyle(
                            color: AppColors.blueColor,
                            fontFamily: appFontFamily,
                            fontWeight: FontWeight.w400,
                            fontSize: 11.0,
                          ),
                        )),
                    Visibility(
                      visible: true,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Container(
                          color: ColorUtils.kTextFieldBorderColor,
                          width: 2.0,
                          height: 50.0,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: TextFormField(
                        maxLines: 1,
                        controller: _controllers5,
                        keyboardType: TextInputType.number,
                        onChanged: (text) {
                          //  item.value;
                        },
                        style: const TextStyle(
                          color: AppColors.dashBoardText,
                          fontFamily: appFontFamily,
                          fontWeight: FontWeight.w400,
                          fontSize: 14.0,
                        ),
                        decoration: InputDecoration(
                          // contentPadding:
                          // EdgeInsets.only(left: 15.0, right: 0.0, top: 0.0, bottom: 0.0),
                          contentPadding: const EdgeInsets.only(
                              left: 15.0, right: 0.0, top: 0.0, bottom: 0.0),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                            borderSide: BorderSide(
                              color: Colors.transparent,
                              width: 0.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(left: 30.0, right: 30.0),
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    const Expanded(
                        flex: 2,
                        child: const Text(
                          "REMARKS",
                          style: TextStyle(
                            color: AppColors.blueColor,
                            fontFamily: appFontFamily,
                            fontWeight: FontWeight.w400,
                            fontSize: 12.0,
                          ),
                        )),
                    Visibility(
                      visible: true,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Container(
                          color: ColorUtils.kTextFieldBorderColor,
                          width: 2.0,
                          height: 50.0,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: TextFormField(
                        maxLines: 5,
                        controller: _controllers6,
                        keyboardType: TextInputType.streetAddress,
                        onChanged: (text) {
                          //  item.value;
                        },
                        style: const TextStyle(
                          color: AppColors.dashBoardText,
                          fontFamily: appFontFamily,
                          fontWeight: FontWeight.w400,
                          fontSize: 14.0,
                        ),
                        decoration: const InputDecoration(
                          // contentPadding:
                          // EdgeInsets.only(left: 15.0, right: 0.0, top: 0.0, bottom: 0.0),
                          contentPadding: EdgeInsets.only(
                              left: 15.0, right: 0.0, top: 15.0, bottom: 0.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                            borderSide: BorderSide(
                              color: Colors.transparent,
                              width: 0.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]);
    });
  }
}
