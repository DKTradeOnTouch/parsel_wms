import 'package:flutter/material.dart';

import 'package:parsel_flutter/models/PickingList.dart';
import 'package:parsel_flutter/resource/app_colors.dart';
import 'package:parsel_flutter/resource/app_fonts.dart';
import 'package:parsel_flutter/resource/app_helper.dart';
import 'package:parsel_flutter/resource/app_strings.dart';

import 'pickList_detai_page.dart';

class PickingList extends StatefulWidget {
  final List<ResultList>? resultList;
  final List<ItemList>? itemList;

  Data? data;
  PickingList({
    Key? key,
    this.resultList,
    required this.data,
    this.itemList,
  }) : super(key: key);

  @override
  State<PickingList> createState() => _PickingListState();
}

Data? data;
List<ResultList> resultList = [];
List<ItemList> itemList = [];

// List<String> salesOrder = ['9942', '2842', '8421'];

class _PickingListState extends State<PickingList> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.resultList!.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  print('salesOrderID-->' +
                      widget.resultList![index].salesOrderId.toString());
                  print('SKU COUNT-->' +
                      widget.resultList![index].itemList!.length.toString());
                  // print('productName-->' +
                  //     widget.itemList![index].productName.toString());
                  AppHelper.changeScreen(
                      context,
                      PickingListDetailPage(
                          itemList: widget.resultList![index].itemList,
                          // data: data!,
                          skuCount: widget.data!.totalCount.toString(),
                          salesID: widget.resultList![index].salesOrderId
                              .toString()));
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
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                          AppStrings.strSalesOrder,
                          style: TextStyle(
                              fontFamily: appFontFamily,
                              fontWeight: FontWeight.w500,
                              color: AppColors.blueColor),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Text(
                          widget.data!.resultList![index].salesOrderId
                              .toString(),
                          // salesOrder[0],
                          style: TextStyle(
                              fontFamily: appFontFamily,
                              fontWeight: FontWeight.w500,
                              color: AppColors.black2Color.withOpacity(0.6)),
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
