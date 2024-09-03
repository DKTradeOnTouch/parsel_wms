import 'package:flutter/material.dart';
import 'package:parsel_flutter/models/storage_list_data_model.dart';
import 'package:parsel_flutter/resource/app_colors.dart';
import 'package:parsel_flutter/resource/app_fonts.dart';
import 'package:parsel_flutter/resource/app_strings.dart';
import 'package:parsel_flutter/screens/InventoryMenu/Storage/storage_list_details_view.dart';

import '../../../models/Storage_model.dart';

class StorageListNew extends StatefulWidget {
  const StorageListNew({Key? key, this.itemList}) : super(key: key);
  final StorageData? itemList;

  @override
  State<StorageListNew> createState() => _StorageListNewState();
}

final List<ResultList>? itemList = [];

int index = 0;
// storageNavigation(context) {
//   Navigator.push(
//       context,
//       MaterialPageRoute(
//           builder: (_) => StorageDetailScreen(
//               itemList: widget.itemList,
//               )));
// }

// List<String> po = ['9412', '8891'];
// List<String> sku = ['SPRIG-VANILLA GLY EXTRACT', 'MANAMA PINEAPPLE'];
// List<String> quantity = ['1000', '1000'];
// List<String> batch = ['SAUG2023', 'SAUG2023'];
// List<String> location = ['IN-4AA', 'IN-1F'];
// List<String> status = ['SORTING', 'SORTING'];

class _StorageListNewState extends State<StorageListNew> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 0,
          ),
          InkWell(
            onTap: () {
              /// Navigation Before Data fetch from AI

              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (_) => StorageDetailScreen(
              //               itemList: widget.itemList,
              //             )));

              /// Navigation After Data fetch from AI

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => StorageListDetailsView(
                            storageData: widget.itemList ?? [] as StorageData,
                          )));
            },
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
                    Row(
                      children: [
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                          AppStrings.strPO,
                          style: const TextStyle(
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
                          widget.itemList!.poId.toString(),
                          style: TextStyle(
                              fontFamily: appFontFamily,
                              fontWeight: FontWeight.w500,
                              color: AppColors.black2Color.withOpacity(0.6)),
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
                    //           color: Color.fromARGB(255, 96, 99, 110)),
                    //     ),
                    //     const SizedBox(
                    //       width: 77,
                    //     ),
                    //     Flexible(
                    //       child: Text(
                    //         // sku[0],
                    //         widget.itemList!.itemList![index].skuDetails!.name
                    //             .toString(),
                    //         overflow: TextOverflow.ellipsis,
                    //         maxLines: 2,
                    //         style: TextStyle(
                    //             fontSize: 12,
                    //             fontFamily: appFontFamily,
                    //             fontWeight: FontWeight.w500,
                    //             color: AppColors.black2Color.withOpacity(0.6)),
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
                    //       widget.itemList!.itemList![index].qty.toString(),
                    //       style: TextStyle(
                    //           fontFamily: appFontFamily,
                    //           fontWeight: FontWeight.w500,
                    //           color: AppColors.black2Color.withOpacity(0.6)),
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
                    //       widget.itemList!.itemList![index].batch.toString(),
                    //       style: TextStyle(
                    //           fontFamily: appFontFamily,
                    //           fontWeight: FontWeight.w500,
                    //           color: AppColors.black2Color.withOpacity(0.6)),
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
                    //       widget.itemList!.itemList![index].type.toString(),
                    //       style: TextStyle(
                    //           fontFamily: appFontFamily,
                    //           fontWeight: FontWeight.w500,
                    //           color: AppColors.black2Color.withOpacity(0.6)),
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
                    //       widget.itemList!.itemList![index].status.toString(),
                    //       style: TextStyle(
                    //           fontFamily: appFontFamily,
                    //           fontWeight: FontWeight.w500,
                    //           color: AppColors.black2Color.withOpacity(0.6)),
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
          ),
        ],
      ),
    );
  }
}
