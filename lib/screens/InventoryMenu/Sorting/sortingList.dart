import 'package:flutter/material.dart';
import 'package:parsel_flutter/models/Storage_model.dart';
import 'package:parsel_flutter/resource/app_colors.dart';
import 'package:parsel_flutter/resource/app_fonts.dart';
import 'package:parsel_flutter/resource/app_helper.dart';
import 'package:parsel_flutter/resource/app_strings.dart';
import 'package:parsel_flutter/screens/InventoryMenu/Sorting/sortingCard.dart';

class SortingList extends StatefulWidget {
  final List<ResultList> resultList;
  const SortingList({
    Key? key,
    required this.resultList,
  }) : super(key: key);

  @override
  State<SortingList> createState() => _SortingListState();
}

class _SortingListState extends State<SortingList> {
  int index1 = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.resultList.isNotEmpty
        ? ListView.builder(
            itemCount: widget.resultList.length,
            itemBuilder: (context, index) => InkWell(
              onTap: (() {
                // print('productCode-->' +
                //     widget.resultList[index].itemList![index1].productCode
                //         .toString());
                // print('SKU Count-->' +
                //     widget.resultList[index].itemList![index1].qty.toString());
                AppHelper.changeScreen(
                    context,
                    SortingCardScreen(
                        skuCount: widget.resultList[index].itemList![index1].qty
                            .toString(),
                        poIDcard: widget.resultList[index].poId.toString(),
                        productCodeCard: widget
                            .resultList[index].itemList![index1].productCode
                            .toString()));
              }),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      elevation: 0.8,
                      shadowColor: AppColors.blackColor.withOpacity(0.2),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.white70, width: 1),
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
                                  width: 85,
                                ),
                                Text(
                                  // po[0],
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

                            // Row(
                            //   children: [
                            //     const SizedBox(
                            //       height: 16,
                            //     ),
                            //     Text(
                            //       AppStrings.strSku,
                            //       // AppStrings.strCode,
                            //       style: TextStyle(
                            //           fontFamily: appFontFamily,
                            //           fontWeight: FontWeight.w500,
                            //           fontSize: 16,
                            //           color: AppColors.blueColor),
                            //     ),
                            //     const SizedBox(
                            //       width: 77,
                            //     ),
                            //     Flexible(
                            //       child: Text(
                            //         // sku[0],
                            //         widget.resultList[index].itemList![index1]
                            //             .skuDetails!.name
                            //             .toString(),
                            //         overflow: TextOverflow.ellipsis,
                            //         maxLines: 2,
                            //         style: TextStyle(
                            //             fontFamily: appFontFamily,
                            //             fontWeight: FontWeight.w500,
                            //             color: AppColors.black2Color
                            //                 .withOpacity(0.6)),
                            //       ),
                            //     ),
                            //   ],
                            // ),

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
                            //       width: 23,
                            //     ),
                            //     Text(
                            //       // quantity[0],
                            //       widget.resultList[index].itemList![index1].qty
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
                            //       width: 55,
                            //     ),
                            //     Text(
                            //       // batch[0],
                            //       widget
                            //           .resultList[index].itemList![index1].batch
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
                            //       AppStrings.strLocation,
                            //       // AppStrings.strType,
                            //       style: TextStyle(
                            //           fontFamily: appFontFamily,
                            //           fontWeight: FontWeight.w500,
                            //           fontSize: 16,
                            //           color: AppColors.blueColor),
                            //     ),
                            //     const SizedBox(
                            //       width: 28,
                            //     ),
                            //     Text(
                            //       // location[0],
                            //       widget
                            //           .resultList[index].itemList![index1].type
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
                            //       // status[0],
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
            ),
          )
        : Center(child: Text('No Data'));
  }
}
