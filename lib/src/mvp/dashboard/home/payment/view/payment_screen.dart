import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:parsel_flutter/src/mvp/dashboard/home/delivery_orders/args/delivery_orders_args.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/in_progress/args/in_progress_args.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/in_progress/model/get_sales_order_list_by_status_model.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/payment/model/create_payment_mode_model.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/payment/model/payment_model.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/payment/provider/payment_provider.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/payment/view/payment_invoice_card.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/payment/view/payment_method_view.dart';
import 'package:parsel_flutter/src/widget/widget.dart';
import 'package:parsel_flutter/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key, required this.deliveryOrdersArgs})
      : super(key: key);
  final DeliveryOrdersArgs deliveryOrdersArgs;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  Timer? _debounce;

  // TextEditingController codController = TextEditingController(text: '0');
  // TextEditingController codRemarksController =
  //     TextEditingController(text: 'COD Payment');
  // TextEditingController cashGivenController = TextEditingController(text: '0');
  // TextEditingController changeGivenController =
  //     TextEditingController(text: '0');
  // TextEditingController creditController = TextEditingController(text: '0');
  // TextEditingController creditRemarksController =
  //     TextEditingController(text: 'Credit Payment');
  // TextEditingController chequeController = TextEditingController(text: '0');
  // TextEditingController chequeRemarksController =
  //     TextEditingController(text: 'Cheque Payment');
  // TextEditingController onlineController = TextEditingController(text: '0');
  // TextEditingController onlineRemarksController =
  //     TextEditingController(text: 'Online Payment');
  // List<CreatePaymentsList> paymentList = [];
  late AutoScrollController controller;
  late AutoScrollController invoiceController;

  double totalInvoiceValue = 0;
  int totalDelivered = 0;
  int totalReturned = 0;
  final _formKey = GlobalKey<FormState>();

  double _renderedHeight = 0.0;
  PageController _pageController = PageController();
  @override
  void initState() {
    PaymentProvider paymentProvider = Provider.of(context, listen: false);
    for (int i = 0;
        i < widget.deliveryOrdersArgs.resultList.subResultList.length;
        i++) {
      widget.deliveryOrdersArgs.resultList.subResultList[i].widgetsGlobalKey =
          GlobalKey();
      widget.deliveryOrdersArgs.resultList.subResultList[i]
          .currentPaymentModeList = [
        paymentProvider.initCurrentPaymentModeList()
      ];
      widget.deliveryOrdersArgs.resultList.subResultList[i].codController =
          TextEditingController(
              text:
                  '${double.parse(widget.deliveryOrdersArgs.resultList.subResultList[i].invoiceValue).ceil()}');
      widget.deliveryOrdersArgs.resultList.subResultList[i]
          .codRemarksController = TextEditingController(text: 'COD Payment');
      widget.deliveryOrdersArgs.resultList.subResultList[i]
          .cashGivenController = TextEditingController(text: '0');
      widget.deliveryOrdersArgs.resultList.subResultList[i]
          .changeGivenController = TextEditingController(text: '0');
      widget.deliveryOrdersArgs.resultList.subResultList[i].creditController =
          TextEditingController(text: '0');
      widget.deliveryOrdersArgs.resultList.subResultList[i]
              .creditRemarksController =
          TextEditingController(text: 'Credit Payment');
      widget.deliveryOrdersArgs.resultList.subResultList[i].chequeController =
          TextEditingController(text: '0');
      widget.deliveryOrdersArgs.resultList.subResultList[i]
              .chequeRemarksController =
          TextEditingController(text: 'Cheque Payment');
      widget.deliveryOrdersArgs.resultList.subResultList[i].onlineController =
          TextEditingController(text: '0');
      widget.deliveryOrdersArgs.resultList.subResultList[i]
              .onlineRemarksController =
          TextEditingController(text: 'Online Payment');

      totalInvoiceValue = totalInvoiceValue +
          double.parse(widget
              .deliveryOrdersArgs.resultList.subResultList[i].invoiceValue);
      if (i == widget.deliveryOrdersArgs.resultList.subResultList.length - 1) {
        // Timer(const Duration(milliseconds: 500), () {
        //   _getRenderedHeight(index: 0);
        // });
      }
    }

    controller = AutoScrollController(axis: Axis.vertical);
    invoiceController = AutoScrollController(axis: Axis.vertical);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // paymentProvider.initCurrentPaymentModeList();

      print('paymentProvider.currentPage ${paymentProvider.currentPage}');
      paymentProvider.currentPage = 0;
      paymentProvider.swipeListLength = 0;
      for (int i = 0;
          i < widget.deliveryOrdersArgs.resultList.subResultList.length;
          i++) {
        ResultList resultList =
            widget.deliveryOrdersArgs.resultList.subResultList[i];
        if (resultList.returnItemsList.length != resultList.itemList.length) {
          paymentProvider.swipeListLength = paymentProvider.swipeListLength + 1;
        }
      }
      for (int i = 0;
          i < widget.deliveryOrdersArgs.resultList.subResultList.length;
          i++) {
        if (widget.deliveryOrdersArgs.resultList.subResultList[i]
                .returnItemsList.length !=
            widget.deliveryOrdersArgs.resultList.subResultList[i].itemList
                .length) {
          _pageController.jumpToPage(i);
          Timer(const Duration(milliseconds: 500), () {
            _getRenderedHeight(index: i);
            paymentProvider.currentPage = i;
          });
          break;
        }
      }

      invoiceController.scrollToIndex(paymentProvider.currentPage);

      ///PaymentProvider
      paymentProvider.currentPaymentMode = paymentProvider.paymentModelList[0];
      paymentProvider.getSalesOrderListByStatusResponse =
          Right(StaticException());
      paymentProvider.createdPaymentResponse = Right(StaticException());

      ///DeliveryOrdersDetailsProvider

      // List<ItemList> itemList =
      //     deliveryOrdersDetailsProvider.resultList.left.itemList;
      // for (int j = 0; j < itemList.length; j++) {
      //   totalInvoiceValue = totalInvoiceValue +
      //       ((itemList[j].unitPrice * itemList[j].qty) -
      //           (itemList[j].unitPrice *
      //               int.parse(itemList[j].returnItemQtyController!.text)));
      //   totalDelivered = totalDelivered +
      //       (itemList[j].qty -
      //           int.parse(itemList[j].returnItemQtyController!.text));
      //   totalReturned = totalReturned +
      //       int.parse(itemList[j].returnItemQtyController!.text);
      // }

      // _getRenderedHeight(index: paymentProvider.currentPage);
    });
    for (int i = 0;
        i < widget.deliveryOrdersArgs.resultList.subResultList.length;
        i++) {
      ResultList subResult =
          widget.deliveryOrdersArgs.resultList.subResultList[i];

      subResult.cashGivenController!.addListener(() {
        if (subResult.cashGivenController!.text == '0') {
          subResult.changeGivenController!.text = '0';
          return;
        }
        print(
            'subResult.cashGivenController!.text --> ${subResult.cashGivenController!.text.isEmpty}');
        if (subResult.cashGivenController!.text.isNotEmpty) {
          subResult.changeGivenController!.text =
              '${double.parse(subResult.cashGivenController!.text).ceil() - double.parse(subResult.codController!.text).ceil()}';
        } else {
          subResult.changeGivenController!.text = '0';
          // subResult.cashGivenController!.text = '0';
        }
      });
    }

    super.initState();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, PaymentProvider paymentProvider, __) {
      return Stack(
        children: [
          Scaffold(
            body: Container(
              color: ColorUtils.primaryColor,
              child: SafeArea(
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 100,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(AssetUtils.authBgImage),
                              fit: BoxFit.cover)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(children: [
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.arrow_back_ios_new,
                                color: ColorUtils.whiteColor,
                              )),
                          const SizedBox(width: 10),
                          Text(
                            LocaleKeys.payment.tr(),
                            style: FontUtilities.h20(
                                fontColor: ColorUtils.whiteColor),
                          )
                        ]),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: VariableUtilities.screenSize.height,
                        width: VariableUtilities.screenSize.width,
                        padding: const EdgeInsets.only(top: 8.0),
                        decoration: const BoxDecoration(
                            color: ColorUtils.colorF7F9FF,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            )),
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: Container(
                                        height: 60,
                                        width: 60,
                                        decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                  color: ColorUtils.blackColor
                                                      .withOpacity(0.5),
                                                  blurRadius: 10,
                                                  spreadRadius: -5)
                                            ],
                                            color: ColorUtils.whiteColor,
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                        // radius: 30,

                                        child: Center(
                                          child: Image.asset(
                                            AssetUtils.arrivedIconImage,
                                            color: ColorUtils.color0439FE,
                                            height: 26,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    PaymentInvoiceCard(
                                        callBack: (int index) async {
                                          if (!_formKey.currentState!
                                              .validate()) {
                                            _getRenderedHeight(index: index);
                                            Fluttertoast.showToast(
                                                msg:
                                                    'Please Fill Blank Fields');
                                            // updatePaymentMode();

                                            return;
                                          }
                                          paymentProvider.currentPage = index;
                                          _pageController.jumpToPage(index);
                                          Timer(
                                              const Duration(milliseconds: 500),
                                              () {
                                            _getRenderedHeight(
                                                index: paymentProvider
                                                    .currentPage);
                                            setState(() {});
                                          });
                                        },
                                        currentPage:
                                            paymentProvider.currentPage,
                                        controller: invoiceController,
                                        resultList: widget
                                            .deliveryOrdersArgs.resultList),
                                    Center(
                                      child: Text(
                                        '₹ ${double.parse(widget.deliveryOrdersArgs.resultList.subResultList[paymentProvider.currentPage].invoiceValue).ceil()}/-',
                                        style: FontUtilities.h28(
                                            fontColor: ColorUtils.color0439FE,
                                            fontWeight: FWT.semiBold),
                                      ),
                                    ),
                                    const Divider(),
                                    widget.deliveryOrdersArgs.resultList
                                                .subResultList.length <=
                                            1
                                        ? const SizedBox()
                                        : Container(
                                            width: VariableUtilities
                                                .screenSize.width,
                                            color: ColorUtils.colorDDE4FE,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20.0,
                                                      vertical: 5),
                                              child: Text(
                                                  LocaleKeys
                                                      .this_delivery_contains
                                                      .plural(widget
                                                          .deliveryOrdersArgs
                                                          .resultList
                                                          .subResultList
                                                          .length),
                                                  maxLines: 2,
                                                  style: FontUtilities.h15(
                                                      fontColor: ColorUtils
                                                          .color828282)),
                                            ),
                                          ),
                                    Form(
                                      key: _formKey,
                                      child: SizedBox(
                                        height: _getRenderedHeight(
                                            index: paymentProvider.currentPage),
                                        child: PageView.builder(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: widget.deliveryOrdersArgs
                                              .resultList.subResultList.length,
                                          controller: _pageController,
                                          itemBuilder: (cx, i) {
                                            return widget
                                                        .deliveryOrdersArgs
                                                        .resultList
                                                        .subResultList[i]
                                                        .returnItemsList
                                                        .length ==
                                                    widget
                                                        .deliveryOrdersArgs
                                                        .resultList
                                                        .subResultList[i]
                                                        .itemList
                                                        .length
                                                ? const SizedBox()
                                                : SingleChildScrollView(
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    child: Container(
                                                      key: widget
                                                          .deliveryOrdersArgs
                                                          .resultList
                                                          .subResultList[i]
                                                          .widgetsGlobalKey,
                                                      child: Column(
                                                        children: [
                                                          PaymentMethodView(
                                                            currentPaymentModeList: widget
                                                                .deliveryOrdersArgs
                                                                .resultList
                                                                .subResultList[
                                                                    i]
                                                                .currentPaymentModeList,
                                                            currentPaymentMode:
                                                                paymentProvider
                                                                    .currentPaymentMode,
                                                            paymentModelList:
                                                                paymentProvider
                                                                    .paymentModelList,
                                                            callBack:
                                                                (paymentModel) async {
                                                              onPaymentMethodChange(
                                                                  paymentModel,
                                                                  paymentProvider,
                                                                  i);
                                                            },
                                                          ),
                                                          ListView.builder(
                                                              scrollDirection:
                                                                  Axis.vertical,
                                                              controller:
                                                                  controller,
                                                              physics:
                                                                  const NeverScrollableScrollPhysics(),
                                                              itemCount: widget
                                                                  .deliveryOrdersArgs
                                                                  .resultList
                                                                  .subResultList[
                                                                      i]
                                                                  .currentPaymentModeList
                                                                  .length,
                                                              shrinkWrap: true,
                                                              itemBuilder:
                                                                  (context,
                                                                      index) {
                                                                return AutoScrollTag(
                                                                  controller:
                                                                      controller,
                                                                  index: index,
                                                                  key: ValueKey(
                                                                      index),
                                                                  child: Column(
                                                                    children: [
                                                                      const SizedBox(
                                                                          height:
                                                                              10),
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .symmetric(
                                                                            horizontal:
                                                                                20.0,
                                                                            vertical:
                                                                                2.5),
                                                                        child:
                                                                            Align(
                                                                          alignment:
                                                                              Alignment.topLeft,
                                                                          child:
                                                                              Text(
                                                                            getPaymentName(paymentType: widget.deliveryOrdersArgs.resultList.subResultList[i].currentPaymentModeList[index].paymentType),
                                                                            style:
                                                                                FontUtilities.h20(fontColor: ColorUtils.color3F3E3E),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                          height:
                                                                              10),
                                                                      Container(
                                                                          width: VariableUtilities
                                                                              .screenSize
                                                                              .width,
                                                                          decoration: BoxDecoration(
                                                                              color: ColorUtils
                                                                                  .whiteColor,
                                                                              borderRadius: BorderRadius.circular(
                                                                                  10)),
                                                                          child: Padding(
                                                                              padding: const EdgeInsets.only(right: 20.0, left: 20.0, top: 18.0, bottom: 5.0),
                                                                              child: fetchCurrentPaymentsModeWidget(index: i, paymentType: widget.deliveryOrdersArgs.resultList.subResultList[i].currentPaymentModeList[index].paymentType))),
                                                                    ],
                                                                  ),
                                                                );
                                                              }),
                                                          Container(
                                                              width:
                                                                  VariableUtilities
                                                                      .screenSize
                                                                      .width,
                                                              decoration: BoxDecoration(
                                                                  color: ColorUtils
                                                                      .whiteColor,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10)),
                                                              child: Padding(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        20.0),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    const Divider(),
                                                                    const SizedBox(
                                                                        height:
                                                                            5),
                                                                    Text(
                                                                      LocaleKeys
                                                                          .summary
                                                                          .tr(),
                                                                      style: FontUtilities.h18(
                                                                          fontColor: ColorUtils
                                                                              .color232323,
                                                                          fontWeight:
                                                                              FWT.semiBold),
                                                                    ),
                                                                    const SizedBox(
                                                                        height:
                                                                            8),
                                                                    Text(
                                                                      '${LocaleKeys.payment_method.tr()}:',
                                                                      style: FontUtilities.h18(
                                                                          fontColor:
                                                                              ColorUtils.color232323),
                                                                    ),
                                                                    const SizedBox(
                                                                        height:
                                                                            8),
                                                                    ListView.builder(
                                                                        physics: const NeverScrollableScrollPhysics(),
                                                                        shrinkWrap: true,
                                                                        itemCount: widget.deliveryOrdersArgs.resultList.subResultList[i].currentPaymentModeList.length,
                                                                        itemBuilder: (context, index) {
                                                                          return Column(
                                                                            children: [
                                                                              Row(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  Text(
                                                                                    getPaymentSummary(paymentType: widget.deliveryOrdersArgs.resultList.subResultList[i].currentPaymentModeList[index].paymentType, index: i)['type'],
                                                                                    style: FontUtilities.h18(fontColor: ColorUtils.color232323),
                                                                                  ),
                                                                                  Text(
                                                                                    '₹ ${double.tryParse('${getPaymentSummary(paymentType: widget.deliveryOrdersArgs.resultList.subResultList[i].currentPaymentModeList[index].paymentType, index: i)['amount']}') != null ? '${double.tryParse('${getPaymentSummary(paymentType: widget.deliveryOrdersArgs.resultList.subResultList[i].currentPaymentModeList[index].paymentType, index: i)['amount']}')!.ceil()}/-' : '0/-'}',
                                                                                    style: FontUtilities.h18(fontColor: ColorUtils.color232323),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              const SizedBox(height: 8),
                                                                            ],
                                                                          );
                                                                        }),
                                                                    const Divider(),
                                                                    Row(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Text(
                                                                          LocaleKeys
                                                                              .total
                                                                              .tr(),
                                                                          style:
                                                                              FontUtilities.h18(fontColor: ColorUtils.color232323),
                                                                        ),
                                                                        Text(
                                                                          '₹ ${double.parse('${getPaymentSummaryTotalAmount(index: paymentProvider.currentPage)}').ceil()}/-',
                                                                          style:
                                                                              FontUtilities.h18(fontColor: ColorUtils.color232323),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    const SizedBox(
                                                                        height:
                                                                            15),
                                                                  ],
                                                                ),
                                                              )),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                          },
                                        ),
                                      ),
                                    )
                                  ]),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Padding(
                padding: const EdgeInsets.all(8.0),
                child: PrimaryButton(
                    width: VariableUtilities.screenSize.width,
                    onTap: () async {
                      // return;
                      if (!_formKey.currentState!.validate()) {
                        // updatePaymentMode();
                        Timer(const Duration(milliseconds: 100), () {
                          _getRenderedHeight(
                              index: paymentProvider.currentPage);
                          setState(() {});
                        });
                        return;
                      }

                      List<ResultList> subResultList =
                          widget.deliveryOrdersArgs.resultList.subResultList;

                      for (int i = 0; i < subResultList.length; i++) {
                        ResultList subResult = subResultList[i];
                        double totalAmount = 0.0;
                        for (var paymentMode
                            in subResult.currentPaymentModeList) {
                          if (paymentMode.paymentType == PaymentType.cod) {
                            if (subResult.codController!.text.isEmpty ||
                                subResult.changeGivenController!.text.isEmpty ||
                                subResult.cashGivenController!.text.isEmpty ||
                                subResult.codRemarksController!.text.isEmpty) {
                              // Your logic here
                            } else {
                              totalAmount = totalAmount +
                                  double.parse(subResult.codController!.text);
                            }
                          }
                          if (paymentMode.paymentType == PaymentType.credit) {
                            if (subResult.creditController!.text.isEmpty ||
                                subResult
                                    .creditRemarksController!.text.isEmpty) {
                              // Your logic here
                            } else {
                              totalAmount = totalAmount +
                                  double.parse(
                                      subResult.creditController!.text);
                            }
                          }
                          if (paymentMode.paymentType == PaymentType.online) {
                            if (subResult.onlineController!.text.isEmpty ||
                                subResult
                                    .onlineRemarksController!.text.isEmpty) {
                              // Your logic here
                            } else {
                              totalAmount = totalAmount +
                                  double.parse(
                                      subResult.onlineController!.text);
                            }
                          }
                          if (paymentMode.paymentType == PaymentType.cheque) {
                            if (subResult.chequeController!.text.isEmpty ||
                                subResult
                                    .chequeRemarksController!.text.isEmpty) {
                              // Your logic here
                            } else {
                              totalAmount = totalAmount +
                                  double.parse(
                                      subResult.chequeController!.text);
                            }
                          }
                        }

                        if (paymentProvider.currentPage == i &&
                            totalAmount !=
                                double.parse(subResult.invoiceValue)) {
                          Fluttertoast.showToast(
                              msg:
                                  'Yours Entered amount and Invoice amount aren\'t matched!');
                          return;
                        }

                        if (totalAmount !=
                            double.parse(subResult.invoiceValue)) {
                          Fluttertoast.showToast(
                              msg:
                                  'Your Entered amount and Invoice amount aren\'t matched!');

                          paymentProvider.currentPage = i;

                          await invoiceController.scrollToIndex(
                              paymentProvider.currentPage,
                              preferPosition: AutoScrollPosition.middle);

                          _pageController.jumpToPage(
                            paymentProvider.currentPage,
                            // duration: const Duration(milliseconds: 400),
                            // curve: Curves.easeIn
                          );

                          Timer(const Duration(milliseconds: 100), () {
                            _getRenderedHeight(index: i);
                            setState(() {});
                          });
                          return;
                        }
                      }
                      print(
                          'hasDataOnNextPage ${hasDataOnNextPage(currentPage: paymentProvider.currentPage)}');
                      if (hasDataOnNextPage(
                          currentPage: paymentProvider.currentPage)) {
                        if (widget.deliveryOrdersArgs.resultList.subResultList
                                    .length -
                                1 !=
                            _pageController.page!.toInt()) {
                          for (int i = paymentProvider.currentPage + 1;
                              i <
                                  widget.deliveryOrdersArgs.resultList
                                      .subResultList.length;
                              i++) {
                            ResultList result = widget
                                .deliveryOrdersArgs.resultList.subResultList[i];
                            print(
                                'result.returnItemsList.length !=result.itemList.length${result.returnItemsList.length != result.itemList.length}');
                            if (result.returnItemsList.length !=
                                result.itemList.length) {
                              await _pageController.animateToPage(i,
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.easeIn);

                              paymentProvider.currentPage =
                                  int.parse('${_pageController.page!.toInt()}');

                              await invoiceController.scrollToIndex(
                                  paymentProvider.currentPage,
                                  preferPosition: AutoScrollPosition.middle);
                              Timer(const Duration(milliseconds: 600), () {
                                _getRenderedHeight(
                                    index: paymentProvider.currentPage);
                                setState(() {});
                              });
                              break;
                            }
                          }
                          return;
                        }
                      } else {
                        updatePaymentMode(index: paymentProvider.currentPage);

                        for (int i = 0;
                            i <
                                widget.deliveryOrdersArgs.resultList
                                    .subResultList.length;
                            i++) {
                          ResultList resultList = widget
                              .deliveryOrdersArgs.resultList.subResultList[i];
                          await paymentProvider
                              .updateSalesOrder(context,
                                  isLastIndex: widget.deliveryOrdersArgs
                                              .resultList.subResultList.length -
                                          1 ==
                                      i,
                                  isCallFromOffline: false,
                                  id: '${resultList.id}',
                                  payments: resultList.sendPaymentToAdminList,
                                  salesOrderId: resultList.salesOrderId,
                                  arrivedTimestamp:
                                      widget.deliveryOrdersArgs.timestamp,
                                  deliveredTimestamp:
                                      DateTime.now().millisecondsSinceEpoch,
                                  deliveryStatus: 'DELIVERED')
                              .then((value) {
                            if (value) {
                              if (widget.deliveryOrdersArgs.resultList
                                              .subResultList.length -
                                          1 ==
                                      i &&
                                  value) {
                                MixpanelManager.trackEvent(
                                    eventName: 'OpenDialog',
                                    properties: {
                                      'Dialog': 'PaymentDoneDialog'
                                    });
                                showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (_) {
                                      return PopScope(
                                        canPop: false,
                                        child: StartTripDialog(
                                          isPaymentDialog: true,
                                          imageUrl: AssetUtils
                                              .paymentDoneIconIconImage,
                                          title: LocaleKeys
                                              .customer_payment_is_successfully
                                              .tr(),
                                          subTitle: LocaleKeys
                                              .you_can_start_your_next_trip
                                              .tr(),
                                          submitTitle:
                                              LocaleKeys.continue_trip.tr(),
                                          submitOnTap: () {
                                            MixpanelManager.trackEvent(
                                                eventName: 'ScreenView',
                                                properties: {
                                                  'Screen': 'InProgressScreen'
                                                });
                                            Navigator.pushNamedAndRemoveUntil(
                                                context,
                                                RouteUtilities.inProgressScreen,
                                                (route) => false,
                                                arguments: InProgressArgs(
                                                    navigateFrom: RouteUtilities
                                                        .paymentScreen));
                                          },
                                        ),
                                      );
                                    }).then((value) {
                                  MixpanelManager.trackEvent(
                                      eventName: 'CloseDialog',
                                      properties: {
                                        'Dialog': 'PaymentDoneDialog'
                                      });
                                });
                              }
                            }
                          });
                        }
                      }

                      // Navigator.pushNamed(
                      //     context, RouteUtilities.returnOrdersScreen);
                    },
                    title: hasDataOnNextPage(
                            currentPage: paymentProvider.currentPage)
                        ? LocaleKeys.confirm_next.tr()
                        : LocaleKeys.confirm.tr())),
          ),
          Visibility(
              visible: (paymentProvider
                          .getSalesOrderListByStatusResponse.isRight &&
                      paymentProvider.getSalesOrderListByStatusResponse.right
                          is NoDataFoundException) ||
                  (paymentProvider.createdPaymentResponse.isRight &&
                      paymentProvider.createdPaymentResponse.right
                          is NoDataFoundException),
              child: CustomCircularProgressIndicator())
        ],
      );
    });
  }

  bool hasDataOnNextPage({required int currentPage}) {
    final resultList = widget.deliveryOrdersArgs.resultList.subResultList;

    for (int i = currentPage + 1; i < resultList.length; i++) {
      ResultList result = resultList[i];

      if (result.returnItemsList.length != result.itemList.length) {
        // If the current returnItemsList length is not equal to the previous itemList length, break the loop and scroll to the next page
        return true;
      }
    }

    // If all consecutive pairs of lists have the same length until the last element, no need to scroll
    return false;
  }

  void onPaymentMethodChange(
      PaymentModel paymentModel, PaymentProvider paymentProvider, int i) async {
    ResultList result = widget.deliveryOrdersArgs.resultList.subResultList[i];
    paymentProvider.currentPaymentMode = paymentModel;

    if (result.currentPaymentModeList.contains(paymentModel)) {
      result.currentPaymentModeList.remove(paymentModel);

      Timer(const Duration(milliseconds: 500), () {
        _getRenderedHeight(index: paymentProvider.currentPage);
        setState(() {});
      });
    } else {
      int insertIndex = 0;
      for (PaymentModel existingPayment in result.currentPaymentModeList) {
        if (existingPayment.paymentType.index <
            paymentModel.paymentType.index) {
          insertIndex++;
        } else {
          break;
        }
      }

      // Insert the new payment model at the determined index
      result.currentPaymentModeList.insert(insertIndex, paymentModel);

      await controller.scrollToIndex(insertIndex);
      print('insertIndex--> of payment list --> $insertIndex');
      Timer(const Duration(milliseconds: 500), () {
        _getRenderedHeight(index: paymentProvider.currentPage);
        setState(() {});
      });
    }

    if (result.currentPaymentModeList.isEmpty) {
      result.currentPaymentModeList.add(paymentProvider.paymentModelList[0]);
      await controller.scrollToIndex(0,
          preferPosition: AutoScrollPosition.middle);
      Timer(const Duration(milliseconds: 500), () {
        _getRenderedHeight(index: paymentProvider.currentPage);
        setState(() {});
      });
    }

    _formKey.currentState!.validate();
    removeControllerValue(
        paymentType: paymentModel.paymentType,
        index: paymentProvider.currentPage);
    setState(() {});
  }

  void removeControllerValue(
      {required PaymentType paymentType, required int index}) {
    ResultList resultList =
        widget.deliveryOrdersArgs.resultList.subResultList[index];

    switch (paymentType) {
      case PaymentType.cod:
        resultList.codController = TextEditingController(text: '0');
        break;
      case PaymentType.credit:
        resultList.creditController = TextEditingController(text: '0');

        break;
      case PaymentType.cheque:
        resultList.chequeController = TextEditingController(text: '0');

        break;
      case PaymentType.online:
        resultList.onlineController = TextEditingController(text: '0');

        break;
    }
    getPaymentSummary(paymentType: paymentType, index: index);
    getPaymentSummaryTotalAmount(index: index);
  }

  Map<String, dynamic> getPaymentSummary(
      {required PaymentType paymentType, required int index}) {
    ResultList resultList =
        widget.deliveryOrdersArgs.resultList.subResultList[index];

    switch (paymentType) {
      case PaymentType.cod:
        String amount = resultList.codController != null
            ? resultList.codController!.text
            : '0';
        return {'type': LocaleKeys.cod.tr(), 'amount': amount};

      case PaymentType.credit:
        String amount = resultList.creditController != null
            ? resultList.creditController!.text
            : '0';
        return {'type': LocaleKeys.credit.tr(), 'amount': amount};

      case PaymentType.cheque:
        String amount = resultList.chequeController != null
            ? resultList.chequeController!.text
            : '0';
        return {'type': LocaleKeys.cheque.tr(), 'amount': amount};

      case PaymentType.online:
        String amount = resultList.onlineController != null
            ? resultList.onlineController!.text
            : '0';
        return {'type': LocaleKeys.online.tr(), 'amount': amount};
    }
  }

  double getPaymentSummaryTotalAmount({required int index}) {
    double amount = 0.0;

    ResultList resultList =
        widget.deliveryOrdersArgs.resultList.subResultList[index];

    amount = (double.tryParse(resultList.codController != null
                ? resultList.codController!.text.isEmpty
                    ? '0'
                    : resultList.codController!.text
                : '0') ??
            0) +
        (double.tryParse(resultList.creditController != null
                ? resultList.creditController!.text.isEmpty
                    ? '0'
                    : resultList.creditController!.text
                : '0') ??
            0) +
        (double.tryParse(resultList.chequeController != null
                ? resultList.chequeController!.text.isEmpty
                    ? '0'
                    : resultList.chequeController!.text
                : '0') ??
            0) +
        (double.tryParse(resultList.onlineController != null
                ? resultList.onlineController!.text.isEmpty
                    ? '0'
                    : resultList.onlineController!.text
                : '0') ??
            0);

    return amount;
  }

  double _getRenderedHeight({required int index}) {
    print("_getRenderedHeight --> $_renderedHeight");
    _renderedHeight = 0.0;

    // Get the RenderBox of the widget
    RenderBox? renderBox = widget.deliveryOrdersArgs.resultList
        .subResultList[index].widgetsGlobalKey!.currentContext
        ?.findRenderObject() as RenderBox?;
    // Check if RenderBox is not null
    if (renderBox != null) {
      // Get the size of the RenderBox
      Size size = renderBox.size;
      // Set the rendered height
      _renderedHeight = size.height;
    }

    return _renderedHeight;
  }

  Widget fetchCurrentPaymentsModeWidget(
      {required PaymentType paymentType, required int index}) {
    switch (paymentType) {
      case PaymentType.cod:
        return codCard(index: index);

      case PaymentType.credit:
        return creditCard(index: index);

      case PaymentType.cheque:
        return chequeCard(index: index);

      case PaymentType.online:
        return onlineCard(index: index);

      default:
        return codCard(index: index);
    }
  }

  Widget codCard({required int index}) {
    return Column(
      children: [
        InputField(
            inputFormatters: [
              // FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),

              FilteringTextInputFormatter.digitsOnly
            ],
            onChanged: (val) {
              _debounce?.cancel();

              _debounce = Timer(const Duration(milliseconds: 500), () {
                print('User finished typing: $val');
                if (val.isNotEmpty) {
                  getPaymentSummary(index: index, paymentType: PaymentType.cod);
                  getPaymentSummaryTotalAmount(index: index);
                }
                setState(() {});
              });
            },
            keyboardType: TextInputType.number,
            prefixSymbol: true,
            controller: widget.deliveryOrdersArgs.resultList
                .subResultList[index].codController!,
            label: LocaleKeys.amount.tr(),
            hintText: LocaleKeys.enter_cod_value.tr()),
        InputField(
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            keyboardType: TextInputType.number,
            prefixSymbol: true,
            controller: widget.deliveryOrdersArgs.resultList
                .subResultList[index].cashGivenController!,
            label: LocaleKeys.cash_given.tr(),
            hintText: LocaleKeys.enter_cash_given_value.tr()),
        InputField(
            keyboardType: TextInputType.number,
            readOnly: true,
            prefixSymbol: true,
            controller: widget.deliveryOrdersArgs.resultList
                .subResultList[index].changeGivenController!,
            label: LocaleKeys.change_given.tr(),
            hintText: LocaleKeys.enter_change_given_value.tr()),
        InputField(
          controller: widget.deliveryOrdersArgs.resultList.subResultList[index]
              .codRemarksController!,
          label: LocaleKeys.remarks.tr(),
          hintText: LocaleKeys.enter_remarks.tr(),
          validator: (val) {
            if (val!.isEmpty) {
              return '${LocaleKeys.please_enter_remark.tr()}!';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget creditCard({required int index}) {
    return Column(
      children: [
        InputField(
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (val) {
              _debounce?.cancel();

              _debounce = Timer(const Duration(milliseconds: 500), () {
                if (val.isNotEmpty) {
                  getPaymentSummary(index: index, paymentType: PaymentType.cod);
                  getPaymentSummaryTotalAmount(index: index);
                }
                setState(() {});
              });
            },
            keyboardType: TextInputType.number,
            prefixSymbol: true,
            controller: widget.deliveryOrdersArgs.resultList
                .subResultList[index].creditController!,
            label: LocaleKeys.amount.tr(),
            hintText: LocaleKeys.enter_credit_value.tr()),
        InputField(
          controller: widget.deliveryOrdersArgs.resultList.subResultList[index]
              .creditRemarksController!,
          label: LocaleKeys.remarks.tr(),
          hintText: LocaleKeys.enter_remarks.tr(),
          validator: (val) {
            if (val!.isEmpty) {
              return '${LocaleKeys.please_enter_remark.tr()}!';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget chequeCard({required int index}) {
    return Column(
      children: [
        InputField(
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (val) {
              _debounce?.cancel();

              _debounce = Timer(const Duration(milliseconds: 500), () {
                print('User finished typing: $val');
                if (val.isNotEmpty) {
                  getPaymentSummary(index: index, paymentType: PaymentType.cod);
                  getPaymentSummaryTotalAmount(index: index);
                }
                setState(() {});
              });
            },
            keyboardType: TextInputType.number,
            prefixSymbol: true,
            controller: widget.deliveryOrdersArgs.resultList
                .subResultList[index].chequeController!,
            label: LocaleKeys.amount.tr(),
            hintText: LocaleKeys.enter_cheque_value.tr()),
        InputField(
          controller: widget.deliveryOrdersArgs.resultList.subResultList[index]
              .chequeRemarksController!,
          label: LocaleKeys.remarks.tr(),
          hintText: LocaleKeys.enter_remarks.tr(),
          validator: (val) {
            if (val!.isEmpty) {
              return '${LocaleKeys.please_enter_remark.tr()}!';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget onlineCard({required int index}) {
    return Column(
      children: [
        InputField(
            onChanged: (val) {
              _debounce?.cancel();

              _debounce = Timer(const Duration(milliseconds: 500), () {
                print('User finished typing: $val');
                if (val.isNotEmpty) {
                  getPaymentSummary(index: index, paymentType: PaymentType.cod);
                  getPaymentSummaryTotalAmount(index: index);
                }
                setState(() {});
              });
            },
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            keyboardType: TextInputType.number,
            prefixSymbol: true,
            controller: widget.deliveryOrdersArgs.resultList
                .subResultList[index].onlineController!,
            label: LocaleKeys.amount.tr(),
            hintText: LocaleKeys.enter_online_value.tr()),
        InputField(
          controller: widget.deliveryOrdersArgs.resultList.subResultList[index]
              .onlineRemarksController!,
          label: LocaleKeys.remarks.tr(),
          hintText: LocaleKeys.enter_remarks.tr(),
          validator: (val) {
            if (val!.isEmpty) {
              return '${LocaleKeys.please_enter_remark.tr()}!';
            }
            return null;
          },
        ),
      ],
    );
  }

  Future<void> updatePaymentMode({required int index}) async {
    for (int i = 0;
        i < widget.deliveryOrdersArgs.resultList.subResultList.length;
        i++) {
      ResultList subResultList =
          widget.deliveryOrdersArgs.resultList.subResultList[i];
      List<PaymentModel> currentPaymentModeList =
          subResultList.currentPaymentModeList;
      subResultList.sendPaymentToAdminList = [];
      for (int j = 0; j < currentPaymentModeList.length; j++) {
        if (currentPaymentModeList[j].paymentType == PaymentType.cod) {
          if (int.parse(subResultList.codController!.text) != 0) {
            subResultList.sendPaymentToAdminList.add(CreatePaymentsList(
              paymentMode: 'cod',
              value: int.parse(subResultList.codController!.text),
              paymentDate:
                  DateFormat('yyyy-MM-dd').format((DateTime.now())).toString(),
              paymentRemark: subResultList.codRemarksController!.text,
              paymentTypes: "CASH_ON_DELIVERY",
              chequePaymentTypes: "NONE",
            ));
          }
        }
        if (currentPaymentModeList[j].paymentType == PaymentType.cheque) {
          if (int.parse(subResultList.chequeController!.text) != 0) {
            subResultList.sendPaymentToAdminList.add(CreatePaymentsList(
              value: int.parse(subResultList.chequeController!.text),
              paymentDate:
                  DateFormat('yyyy-MM-dd').format((DateTime.now())).toString(),
              paymentRemark:
                  subResultList.chequeRemarksController!.text + "," + 'PDC',
              paymentTypes: 'CHEQUE',
              chequePaymentTypes: 'PDC',
              paymentMode: 'cheque',
            ));
          }
        }
        if (currentPaymentModeList[j].paymentType == PaymentType.online) {
          if (int.parse(subResultList.onlineController!.text) != 0) {
            subResultList.sendPaymentToAdminList.add(CreatePaymentsList(
              value: int.parse(subResultList.onlineController!.text),
              paymentDate:
                  DateFormat('yyyy-MM-dd').format((DateTime.now())).toString(),
              paymentRemark: subResultList.onlineRemarksController!.text,
              paymentTypes: 'ONLINE',
              chequePaymentTypes: 'NONE',
              paymentMode: 'online',
            ));
          }
        }
        if (currentPaymentModeList[j].paymentType == PaymentType.credit) {
          if (int.parse(subResultList.creditController!.text) != 0) {
            subResultList.sendPaymentToAdminList.add(CreatePaymentsList(
              value: int.parse(subResultList.creditController!.text),
              paymentDate:
                  DateFormat('yyyy-MM-dd').format((DateTime.now())).toString(),
              paymentRemark: subResultList.creditRemarksController!.text,
              paymentTypes: 'CREDIT',
              chequePaymentTypes: 'NONE',
              paymentMode: 'credit',
            ));
          }
        }
      }
    }
    for (int i = 0;
        i < widget.deliveryOrdersArgs.resultList.subResultList.length;
        i++) {
      ResultList result = widget.deliveryOrdersArgs.resultList.subResultList[i];
      print(
          'result.sendPaymentToAdminList.length ${result.sendPaymentToAdminList.length}');
      for (int j = 0; j < result.sendPaymentToAdminList.length; j++) {
        CreatePaymentsList payment = result.sendPaymentToAdminList[j];

        print('================$i-------------');
        print('paymentMode ${payment.paymentMode}');
        print('paymentTypes ${payment.paymentTypes}');
        print('value ${payment.value}');
        print('================');
      }
    }
  }

  String getPaymentName({required PaymentType paymentType}) {
    switch (paymentType) {
      case PaymentType.cod:
        return LocaleKeys.cod.tr();
      case PaymentType.credit:
        return LocaleKeys.credit.tr();
      case PaymentType.cheque:
        return LocaleKeys.cheque.tr();
      case PaymentType.online:
        return LocaleKeys.online.tr();
      default:
        return '';
    }
  }
}
