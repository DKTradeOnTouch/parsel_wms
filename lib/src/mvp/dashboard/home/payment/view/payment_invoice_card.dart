import 'package:flutter/material.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/in_progress/model/get_sales_order_list_by_status_model.dart';
import 'package:parsel_flutter/utils/utils.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

typedef InvVoidCallBack = Function(int);

class PaymentInvoiceCard extends StatefulWidget {
  const PaymentInvoiceCard(
      {super.key,
      required this.resultList,
      required this.controller,
      required this.currentPage,
      required this.callBack});
  final ResultList resultList;
  final AutoScrollController controller;
  final int currentPage;
  final InvVoidCallBack callBack;
  @override
  State<PaymentInvoiceCard> createState() => _PaymentInvoiceCardState();
}

class _PaymentInvoiceCardState extends State<PaymentInvoiceCard> {
  @override
  Widget build(BuildContext context) {
    return widget.resultList.subResultList.length == 1
        ? Center(
            child: Column(
              children: [
                const SizedBox(height: 5),
                Text(
                  'INV #${widget.resultList.id}',
                  style: FontUtilities.h20(
                      fontColor: ColorUtils.color3F3E3E,
                      fontWeight: FWT.semiBold),
                ),
                const SizedBox(height: 5),
              ],
            ),
          )
        : Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: SizedBox(
              height: 46,
              child: Center(
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.resultList.subResultList.length,
                    shrinkWrap: true,
                    controller: widget.controller,
                    itemBuilder: (context, index) {
                      ResultList result =
                          widget.resultList.subResultList[index];
                      return AutoScrollTag(
                        controller: widget.controller,
                        index: index,
                        key: ValueKey(index),
                        child: result.returnItemsList.length ==
                                result.itemList.length
                            ? const SizedBox()
                            : Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: InkWell(
                                  onTap: () {
                                    print(index);
                                    widget.callBack(index);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: widget.currentPage == index
                                            ? ColorUtils.whiteColor
                                            : ColorUtils.colorE7E7E7,
                                        border: Border.all(
                                            color: widget.currentPage == index
                                                ? ColorUtils.primaryColor
                                                : Colors.transparent),
                                        borderRadius: BorderRadius.circular(5)),
                                    constraints: const BoxConstraints(
                                        minWidth: 145, minHeight: 46),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15.0, vertical: 5.0),
                                        child: Text(
                                          'INV #${widget.resultList.subResultList[index].id}',
                                          style: FontUtilities.h20(
                                              fontColor: ColorUtils.color3F3E3E,
                                              fontWeight: FWT.semiBold),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                      );
                    }),
              ),
            ));
  }
}
