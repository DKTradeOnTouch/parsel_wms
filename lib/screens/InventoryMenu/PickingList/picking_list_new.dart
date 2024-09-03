// ignore_for_file: must_be_immutable

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:parsel_flutter/models/PickingList.dart';
import 'package:parsel_flutter/models/picking_list_data_model.dart';
import 'package:parsel_flutter/resource/app_colors.dart';
import 'package:parsel_flutter/resource/app_fonts.dart';
import 'package:parsel_flutter/resource/app_helper.dart';
import 'package:parsel_flutter/screens/InventoryMenu/PickingList/picking_list_details_page_view.dart';

class PickingListNew extends StatefulWidget {
  final List<PickingData> pickingList;

  const PickingListNew({
    Key? key,
    required this.pickingList,
  }) : super(key: key);

  @override
  State<PickingListNew> createState() => _PickingListNewState();
}

Data? data;
List<ResultList> resultList = [];
List<ItemList> itemList = [];

// List<String> salesOrder = ['9942', '2842', '8421'];

class _PickingListNewState extends State<PickingListNew> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.pickingList.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  if (kDebugMode) {
                    print('SKU COUNT-->' + widget.pickingList[index].productId);
                  }
                  // print('productName-->' +
                  //     widget.itemList![index].productName.toString());
                  // AppHelper.changeScreen(
                  //     context,
                  //     PickingListDetailPage(
                  //         itemList: widget.resultList![index].itemList,
                  //         // data: data!,
                  //         skuCount: widget.data!.totalCount.toString(),
                  //         salesID: widget.resultList![index].salesOrderId
                  //             .toString()));
                  AppHelper.changeScreen(
                    context,
                    PickingListDetailPageNew(
                        pickingData: widget.pickingList[index]),
                  );
                },
                child: Card(
                  elevation: 0.5,
                  shadowColor: AppColors.blackColor.withOpacity(0.2),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.white70, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Container(
                    padding: const EdgeInsets.only(
                        left: 16, right: 16, top: 22, bottom: 22),
                    width: double.infinity,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.pickingList[index].skus,
                            // salesOrder[0],
                            maxLines: null,
                            style: const TextStyle(
                                fontFamily: appFontFamily,
                                fontWeight: FontWeight.w500,
                                color: AppColors.blackColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
