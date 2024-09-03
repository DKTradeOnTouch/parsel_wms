import 'package:flutter/material.dart';
import 'package:parsel_flutter/models/locationDropdown_model.dart' as lo;
import 'package:parsel_flutter/resource/app_colors.dart';
import 'package:parsel_flutter/resource/app_fonts.dart';
import 'package:parsel_flutter/resource/app_helper.dart';
import 'package:parsel_flutter/resource/app_strings.dart';
import 'package:parsel_flutter/screens/InventoryMenu/Inward/Inward.dart';
import '../../../api/api.dart';
import '../../../models/InwardList_model.dart' as In;

import '../../../models/locationDropdown_model.dart' as lo;

class InwardListItem extends StatefulWidget {
  final List<In.ResultList> resultList;
  InwardListItem({
    Key? key,
    required this.resultList,
    // required this.listLocation,
  }) : super(key: key);

  @override
  State<InwardListItem> createState() => _InwardListItemState();
}

class _InwardListItemState extends State<InwardListItem> {
  @override
  int index1 = 0;
  final List<lo.ResultList> _listLocation = [];

  String? barcodeId;

  @override
  void initState() {
    super.initState();
    getLocationDropDown(context);
  }

  Future getLocationDropDown(BuildContext context) async {
    setState(() {});
    return await API.getLocationDropDownList(context).then(
      (lo.LocationDropDownModel? response) async {
        setState(() {});
        if (response != null) {
          barcodeId = response.data!.resultList![index1].barCodeId;
          response.data!.resultList!.map((e) => _listLocation.add(e)).toList();
        } else {
          AppHelper.showSnackBar(context, AppStrings.strSomethingWentWrong);
        }
      },
    ).onError((error, stackTrace) {
      setState(() {});
    });
  }

  Widget build(BuildContext context) {
    return widget.resultList.isNotEmpty
        ? ListView.builder(
            itemCount: widget.resultList.length,
            itemBuilder: (context, index) => InkWell(
                  onTap: (() {
                    // print('ResultListLength->' +
                    //     widget.resultList.length.toString());
                    // print('barCODE ID-->' +
                    //     _listLocation[index].barCodeId.toString());
                    AppHelper.changeScreen(
                        context,
                        InwardScreen(
                          itemList: widget.resultList[index],
                          // listLocation: _listLocation[index],
                        ));
                  }),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          elevation: 0.8,
                          shadowColor: AppColors.blackColor.withOpacity(0.2),
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                color: Colors.white70, width: 1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Container(
                            padding: const EdgeInsets.only(
                                left: 16, right: 16, top: 22, bottom: 22),
                            width: double.infinity,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    Text(
                                      AppStrings.strPO,
                                      style: TextStyle(
                                          fontFamily: appFontFamily,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          color: AppColors.blueColor),
                                    ),
                                    const SizedBox(
                                      width: 90,
                                    ),
                                    Text(
                                      widget.resultList[index].poId.toString(),
                                      style: TextStyle(
                                          fontFamily: appFontFamily,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.black2Color
                                              .withOpacity(0.6)),
                                    ),
                                  ],
                                ),

                                // const SizedBox(
                                //   height: 10,
                                // ),

                                // //Quantity
                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.start,
                                //   children: [
                                //     const SizedBox(
                                //       height: 16,
                                //     ),
                                //     Text(
                                //       AppStrings.strQuantity,
                                //       style: TextStyle(
                                //           fontFamily: appFontFamily,
                                //           fontWeight: FontWeight.w500,
                                //           fontSize: 16,
                                //           color: AppColors.blueColor),
                                //     ),
                                //     const SizedBox(
                                //       width: 30,
                                //     ),
                                //     Text(
                                //       widget.resultList[index].itemList![index1]
                                //           .qty
                                //           .toString(),
                                //       style: TextStyle(
                                //           fontFamily: appFontFamily,
                                //           fontWeight: FontWeight.w500,
                                //           color: AppColors.black2Color
                                //               .withOpacity(0.6)),
                                //     ),
                                //   ],
                                // ),
                                // const SizedBox(
                                //   height: 10,
                                // ),
                                // //Batch
                                // Row(
                                //   children: [
                                //     const SizedBox(
                                //       height: 16,
                                //     ),
                                //     Text(
                                //       AppStrings.strBatch,
                                //       style: TextStyle(
                                //           fontFamily: appFontFamily,
                                //           fontWeight: FontWeight.w500,
                                //           fontSize: 16,
                                //           color: AppColors.blueColor),
                                //     ),
                                //     const SizedBox(
                                //       width: 60,
                                //     ),
                                //     Text(
                                //       widget.resultList[index].itemList![index1]
                                //           .batch
                                //           .toString(),
                                //       style: TextStyle(
                                //           fontFamily: appFontFamily,
                                //           fontWeight: FontWeight.w500,
                                //           color: AppColors.black2Color
                                //               .withOpacity(0.6)),
                                //     ),
                                //   ],
                                // ),
                                // const SizedBox(
                                //   height: 10,
                                // ),
                                // //Type
                                // Row(
                                //   children: [
                                //     const SizedBox(
                                //       height: 16,
                                //     ),
                                //     Text(
                                //       AppStrings.strType,
                                //       style: TextStyle(
                                //           fontFamily: appFontFamily,
                                //           fontWeight: FontWeight.w500,
                                //           fontSize: 16,
                                //           color: AppColors.blueColor),
                                //     ),
                                //     const SizedBox(
                                //       width: 70,
                                //     ),
                                //     Text(
                                //       widget.resultList[index].itemList![index1]
                                //           .type
                                //           .toString(),
                                //       style: TextStyle(
                                //           fontFamily: appFontFamily,
                                //           fontWeight: FontWeight.w500,
                                //           color: AppColors.black2Color
                                //               .withOpacity(0.6)),
                                //     ),
                                //   ],
                                // ),

                                const SizedBox(
                                  height: 1,
                                ),
                                //STATUS
                                // Row(
                                //   children: [
                                //     const SizedBox(
                                //       height: 16,
                                //     ),
                                //     Text(
                                //       AppStrings.strStatus,
                                //       style: TextStyle(
                                //           fontFamily: appFontFamily,
                                //           fontWeight: FontWeight.w500,
                                //           fontSize: 16,
                                //           color: AppColors.blueColor),
                                //     ),
                                //     const SizedBox(
                                //       width: 50,
                                //     ),
                                //     Text(
                                //       widget.resultList[index].itemList![index1]
                                //           .status
                                //           .toString(),
                                //       style: TextStyle(
                                //           fontFamily: appFontFamily,
                                //           fontWeight: FontWeight.w500,
                                //           color: AppColors.black2Color
                                //               .withOpacity(0.6)),
                                //     ),
                                //   ],
                                // ),

                                // const SizedBox(
                                //   height: 15,
                                // ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ))
        : Center(child: Text('No Data'));
  }
}
