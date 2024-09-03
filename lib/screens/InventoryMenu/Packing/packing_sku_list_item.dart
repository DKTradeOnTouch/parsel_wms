import 'package:flutter/material.dart';
import 'package:parsel_flutter/models/packing_list_model.dart' as pl;
import 'package:parsel_flutter/models/Storage_model.dart';
import 'package:parsel_flutter/resource/app_colors.dart';
import 'package:parsel_flutter/resource/app_fonts.dart';
import 'package:parsel_flutter/resource/app_strings.dart';

class PackingSkuListItem extends StatefulWidget {
  List<pl.ItemList> itemList;
  PackingSkuListItem({Key? key, required this.itemList}) : super(key: key);

  @override
  State<PackingSkuListItem> createState() => _PackingSkuListItemState();
}

List<pl.ItemList> itemList = [];

// List<String> skuList = [
//   'SARWAR-COOCA POWDER 1KG',
//   '800',
//   'SJUNE2023',
//   'RACK82F Level 1'
// ];

class _PackingSkuListItemState extends State<PackingSkuListItem> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return widget.itemList.isNotEmpty
        ? ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.itemList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Card(
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
                        //SKU NAME
                        Row(
                          children: [
                            const SizedBox(
                              height: 16,
                            ),
                            Text(
                              AppStrings.strSkuName,
                              style: TextStyle(
                                  fontFamily: appFontFamily,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: AppColors.blueColor),
                            ),
                            const SizedBox(
                              width: 40,
                            ),
                            Flexible(
                              child: Text(
                                widget.itemList[index].productName.toString(),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                // skuList[0],
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: appFontFamily,
                                    fontWeight: FontWeight.w500,
                                    color:
                                        AppColors.black2Color.withOpacity(0.6)),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 10,
                        ),

                        //Quantity
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 16,
                            ),
                            Text(
                              AppStrings.strQuantity,
                              style: TextStyle(
                                  fontFamily: appFontFamily,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: AppColors.blueColor),
                            ),
                            const SizedBox(
                              width: 40,
                            ),
                            Text(
                              widget.itemList[index].qty.toString(),

                              // skuList[1],
                              style: TextStyle(
                                  fontFamily: appFontFamily,
                                  fontWeight: FontWeight.w500,
                                  color:
                                      AppColors.black2Color.withOpacity(0.6)),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        //Batch
                        Row(
                          children: [
                            const SizedBox(
                              height: 16,
                            ),
                            Text(
                              AppStrings.strBatch,
                              style: TextStyle(
                                  fontFamily: appFontFamily,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: AppColors.blueColor),
                            ),
                            const SizedBox(
                              width: 70,
                            ),
                            Text(
                              widget.itemList[index].batch.toString(),
                              // skuList[2],
                              style: TextStyle(
                                  fontFamily: appFontFamily,
                                  fontWeight: FontWeight.w500,
                                  color:
                                      AppColors.black2Color.withOpacity(0.6)),
                            ),
                          ],
                        ),
                        // const SizedBox(
                        //   height: 10,
                        // ),
                        // //Bin Location
                        // Row(
                        //   children: [
                        //     const SizedBox(
                        //       height: 16,
                        //     ),
                        //     Text(
                        //       AppStrings.strBinLocation,
                        //       style: TextStyle(
                        //           fontFamily: appFontFamily,
                        //           fontWeight: FontWeight.w500,
                        //           fontSize: 16,
                        //           color: AppColors.blueColor),
                        //     ),
                        //     const SizedBox(
                        //       width: 10,
                        //     ),
                        //     Text(
                        //       widget.itemList[index].action.toString(),

                        //       // skuList[3],
                        //       style: TextStyle(
                        //           fontFamily: appFontFamily,
                        //           fontWeight: FontWeight.w500,
                        //           color:
                        //               AppColors.black2Color.withOpacity(0.6)),
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                ),
              );
            })
        : Center(child: Text('No Data'));
  }
}
