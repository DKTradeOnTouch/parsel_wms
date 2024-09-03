// import 'package:easy_localization/easy_localization.dart';
// import 'package:either_dart/either.dart';
// import 'package:flutter/material.dart';
// import 'package:parsel_flutter/src/mvp/dashboard/home/delivery_orders/args/delivery_orders_args.dart';
// import 'package:parsel_flutter/src/mvp/dashboard/home/in_progress/args/in_progress_args.dart';
// import 'package:parsel_flutter/src/mvp/dashboard/home/payment/model/create_payment_mode_model.dart';
// import 'package:parsel_flutter/src/mvp/dashboard/home/payment/model/payment_model.dart';
// import 'package:parsel_flutter/src/mvp/dashboard/home/payment/provider/payment_provider.dart';
// import 'package:parsel_flutter/src/mvp/dashboard/home/payment/view/payment_invoice_card.dart';
// import 'package:parsel_flutter/src/mvp/dashboard/home/payment/view/payment_method_view.dart';
// import 'package:parsel_flutter/src/widget/widget.dart';
// import 'package:parsel_flutter/utils/utils.dart';
// import 'package:provider/provider.dart';
// import 'package:scroll_to_index/scroll_to_index.dart';

// class PaymentScreen extends StatefulWidget {
//   const PaymentScreen({Key? key, required this.deliveryOrdersArgs})
//       : super(key: key);
//   final DeliveryOrdersArgs deliveryOrdersArgs;

//   @override
//   State<PaymentScreen> createState() => _PaymentScreenState();
// }

// class _PaymentScreenState extends State<PaymentScreen> {
//   TextEditingController codController = TextEditingController(text: '0');
//   TextEditingController codRemarksController =
//       TextEditingController(text: 'COD Payment');
//   TextEditingController cashGivenController = TextEditingController(text: '0');
//   TextEditingController changeGivenController =
//       TextEditingController(text: '0');
//   TextEditingController creditController = TextEditingController(text: '0');
//   TextEditingController creditRemarksController =
//       TextEditingController(text: 'Credit Payment');
//   TextEditingController chequeController = TextEditingController(text: '0');
//   TextEditingController chequeRemarksController =
//       TextEditingController(text: 'Cheque Payment');
//   TextEditingController onlineController = TextEditingController(text: '0');
//   TextEditingController onlineRemarksController =
//       TextEditingController(text: 'Online Payment');
//   List<CreatePaymentsList> paymentList = [];
//   late AutoScrollController controller;
//   late AutoScrollController invoiceController;

//   double totalInvoiceValue = 0;
//   int totalDelivered = 0;
//   int totalReturned = 0;
//   final _formKey = GlobalKey<FormState>();
//   List<Widget> paymentWidgetsList = [];
//   PageController _pageController = PageController();

//   @override
//   void initState() {
//     controller = AutoScrollController(axis: Axis.vertical);
//     invoiceController = AutoScrollController(axis: Axis.vertical);
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       paymentWidgetsList.add(codCard());

//       PaymentProvider paymentProvider = Provider.of(context, listen: false);
//       paymentProvider.initCurrentPaymentModeList();
//       paymentProvider.currentPage = 0;
//       invoiceController.scrollToIndex(paymentProvider.currentPage);

//       ///PaymentProvider
//       paymentProvider.currentPaymentMode = paymentProvider.paymentModelList[0];
//       paymentProvider.getSalesOrderListByStatusResponse =
//           Right(StaticException());
//       paymentProvider.createdPaymentResponse = Right(StaticException());

//       ///DeliveryOrdersDetailsProvider
//       for (int i = 0;
//           i < widget.deliveryOrdersArgs.resultList.subResultList.length;
//           i++) {
//         totalInvoiceValue = totalInvoiceValue +
//             double.parse(widget
//                 .deliveryOrdersArgs.resultList.subResultList[i].invoiceValue);
//       }
//       // List<ItemList> itemList =
//       //     deliveryOrdersDetailsProvider.resultList.left.itemList;
//       // for (int j = 0; j < itemList.length; j++) {
//       //   totalInvoiceValue = totalInvoiceValue +
//       //       ((itemList[j].unitPrice * itemList[j].qty) -
//       //           (itemList[j].unitPrice *
//       //               int.parse(itemList[j].returnItemQtyController!.text)));
//       //   totalDelivered = totalDelivered +
//       //       (itemList[j].qty -
//       //           int.parse(itemList[j].returnItemQtyController!.text));
//       //   totalReturned = totalReturned +
//       //       int.parse(itemList[j].returnItemQtyController!.text);
//       // }
//       codController =
//           TextEditingController(text: '${totalInvoiceValue.ceil()}');

//       creditController =
//           TextEditingController(text: '${totalInvoiceValue.ceil()}');
//     });
//     cashGivenController.addListener(() {
//       if (cashGivenController.text == '0') {
//         changeGivenController.text = '0';
//         return;
//       }
//       if (cashGivenController.text.isNotEmpty) {
//         changeGivenController.text =
//             '${double.parse(cashGivenController.text).ceil() - double.parse(codController.text).ceil()}';
//       }
//     });
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer(builder: (context, PaymentProvider paymentProvider, __) {
//       return Stack(
//         children: [
//           Scaffold(
//             body: Container(
//               color: ColorUtils.primaryColor,
//               child: SafeArea(
//                 child: Column(
//                   children: [
//                     Container(
//                       width: double.infinity,
//                       height: 100,
//                       decoration: const BoxDecoration(
//                           image: DecorationImage(
//                               image: AssetImage(AssetUtils.authBgImage),
//                               fit: BoxFit.cover)),
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Row(children: [
//                           IconButton(
//                               onPressed: () {
//                                 Navigator.pop(context);
//                               },
//                               icon: const Icon(
//                                 Icons.arrow_back_ios_new,
//                                 color: ColorUtils.whiteColor,
//                               )),
//                           const SizedBox(width: 10),
//                           Text(
//                             LocaleKeys.payment.tr(),
//                             style: FontUtilities.h20(
//                                 fontColor: ColorUtils.whiteColor),
//                           )
//                         ]),
//                       ),
//                     ),
//                     Container(
//                       height: VariableUtilities.screenSize.height,
//                       width: VariableUtilities.screenSize.width,
//                       padding: const EdgeInsets.only(top: 8.0),
//                       decoration: const BoxDecoration(
//                           color: ColorUtils.colorF7F9FF,
//                           borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(20),
//                             topRight: Radius.circular(20),
//                           )),
//                       child: SingleChildScrollView(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const SizedBox(height: 10),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Center(
//                                     child: Container(
//                                       height: 60,
//                                       width: 60,
//                                       decoration: BoxDecoration(
//                                           boxShadow: [
//                                             BoxShadow(
//                                                 color: ColorUtils.blackColor
//                                                     .withOpacity(0.5),
//                                                 blurRadius: 10,
//                                                 spreadRadius: -5)
//                                           ],
//                                           color: ColorUtils.whiteColor,
//                                           borderRadius:
//                                               BorderRadius.circular(30)),
//                                       // radius: 30,

//                                       child: Center(
//                                         child: Image.asset(
//                                           AssetUtils.arrivedIconImage,
//                                           color: ColorUtils.color0439FE,
//                                           height: 26,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   const SizedBox(height: 10),
//                                   PaymentInvoiceCard(
//                                       callBack: (int index) {
//                                         paymentProvider.currentPage = index;
//                                       },
//                                       currentPage: paymentProvider.currentPage,
//                                       controller: invoiceController,
//                                       resultList:
//                                           widget.deliveryOrdersArgs.resultList),
//                                   Center(
//                                     child: Text(
//                                       '₹ ${double.parse(widget.deliveryOrdersArgs.resultList.subResultList[paymentProvider.currentPage].invoiceValue).ceil()}/-',
//                                       style: FontUtilities.h28(
//                                           fontColor: ColorUtils.color0439FE,
//                                           fontWeight: FWT.semiBold),
//                                     ),
//                                   ),
//                                   const Divider(),
//                                   widget.deliveryOrdersArgs.resultList
//                                               .subResultList.length <=
//                                           1
//                                       ? const SizedBox()
//                                       : Container(
//                                           width: VariableUtilities
//                                               .screenSize.width,
//                                           color: ColorUtils.colorDDE4FE,
//                                           child: Padding(
//                                             padding: const EdgeInsets.symmetric(
//                                                 horizontal: 20.0, vertical: 5),
//                                             child: Text(
//                                                 LocaleKeys
//                                                     .this_delivery_contains
//                                                     .plural(widget
//                                                         .deliveryOrdersArgs
//                                                         .resultList
//                                                         .subResultList
//                                                         .length),
//                                                 maxLines: 2,
//                                                 style: FontUtilities.h15(
//                                                     fontColor: ColorUtils
//                                                         .color828282)),
//                                           ),
//                                         ),
//                                   Expanded(
//                                     child:
//                                         LayoutBuilder(builder: (context, _co) {
//                                       print('_co -< $_co');
//                                       return Container(
//                                         height: _co.maxHeight,
//                                         child: PageView.builder(
//                                             physics:
//                                                 const NeverScrollableScrollPhysics(),
//                                             controller: _pageController,
//                                             scrollDirection: Axis.horizontal,
//                                             itemCount: widget
//                                                 .deliveryOrdersArgs
//                                                 .resultList
//                                                 .subResultList
//                                                 .length,
//                                             itemBuilder: (context, index) {
//                                               return Column(
//                                                 children: [
//                                                   PaymentMethodView(
//                                                     currentPaymentModeList:
//                                                         paymentProvider
//                                                             .currentPaymentModeList,
//                                                     currentPaymentMode:
//                                                         paymentProvider
//                                                             .currentPaymentMode,
//                                                     paymentModelList:
//                                                         paymentProvider
//                                                             .paymentModelList,
//                                                     callBack:
//                                                         (paymentModel) async {
//                                                       paymentProvider
//                                                               .currentPaymentMode =
//                                                           paymentModel;

//                                                       if (paymentProvider
//                                                           .currentPaymentModeList
//                                                           .contains(
//                                                               paymentModel)) {
//                                                         paymentProvider
//                                                             .currentPaymentModeList
//                                                             .remove(
//                                                                 paymentModel);
//                                                       } else {
//                                                         paymentProvider
//                                                             .currentPaymentModeList
//                                                             .add(paymentModel);
//                                                         await controller.scrollToIndex(
//                                                             paymentProvider
//                                                                 .currentPaymentModeList
//                                                                 .indexOf(
//                                                                     paymentModel));
//                                                       }

//                                                       if (paymentProvider
//                                                           .currentPaymentModeList
//                                                           .isEmpty) {
//                                                         paymentProvider
//                                                             .currentPaymentModeList
//                                                             .add(paymentProvider
//                                                                 .paymentModelList[0]);
//                                                         await controller
//                                                             .scrollToIndex(0,
//                                                                 preferPosition:
//                                                                     AutoScrollPosition
//                                                                         .middle);
//                                                       }

//                                                       _formKey.currentState!
//                                                           .validate();
//                                                     },
//                                                   ),

//                                                   // const SizedBox(height: 10),
//                                                   // Padding(
//                                                   //   padding: const EdgeInsets.symmetric(
//                                                   //       horizontal: 20.0, vertical: 2.5),
//                                                   //   child: Align(
//                                                   //     alignment: Alignment.topLeft,
//                                                   //     child: Text(
//                                                   //       getPaymentName(
//                                                   //           paymentType: paymentProvider
//                                                   //               .currentPaymentMode
//                                                   //               .paymentType),
//                                                   //       style: FontUtilities.h20(
//                                                   //           fontColor:
//                                                   //               ColorUtils.color3F3E3E),
//                                                   //     ),
//                                                   //   ),
//                                                   // ),
//                                                   Form(
//                                                     key: _formKey,
//                                                     child: ListView.builder(
//                                                         scrollDirection:
//                                                             Axis.vertical,
//                                                         controller: controller,
//                                                         physics:
//                                                             const NeverScrollableScrollPhysics(),
//                                                         itemCount: paymentProvider
//                                                             .currentPaymentModeList
//                                                             .length,
//                                                         shrinkWrap: true,
//                                                         itemBuilder:
//                                                             (context, index) {
//                                                           return AutoScrollTag(
//                                                             controller:
//                                                                 controller,
//                                                             index: index,
//                                                             key:
//                                                                 ValueKey(index),
//                                                             child: Column(
//                                                               children: [
//                                                                 const SizedBox(
//                                                                     height: 10),
//                                                                 Padding(
//                                                                   padding: const EdgeInsets
//                                                                       .symmetric(
//                                                                       horizontal:
//                                                                           20.0,
//                                                                       vertical:
//                                                                           2.5),
//                                                                   child: Align(
//                                                                     alignment:
//                                                                         Alignment
//                                                                             .topLeft,
//                                                                     child: Text(
//                                                                       getPaymentName(
//                                                                           paymentType: paymentProvider
//                                                                               .currentPaymentModeList[index]
//                                                                               .paymentType),
//                                                                       style: FontUtilities.h20(
//                                                                           fontColor:
//                                                                               ColorUtils.color3F3E3E),
//                                                                     ),
//                                                                   ),
//                                                                 ),
//                                                                 const SizedBox(
//                                                                     height: 10),
//                                                                 Container(
//                                                                     width: VariableUtilities
//                                                                         .screenSize
//                                                                         .width,
//                                                                     decoration: BoxDecoration(
//                                                                         color: ColorUtils
//                                                                             .whiteColor,
//                                                                         borderRadius: BorderRadius.circular(
//                                                                             10)),
//                                                                     child: Padding(
//                                                                         padding: const EdgeInsets
//                                                                             .only(
//                                                                             right:
//                                                                                 20.0,
//                                                                             left:
//                                                                                 20.0,
//                                                                             top:
//                                                                                 18.0,
//                                                                             bottom:
//                                                                                 5.0),
//                                                                         child: fetchCurrentPaymentsModeWidget(
//                                                                             paymentType:
//                                                                                 paymentProvider.currentPaymentModeList[index].paymentType))),
//                                                               ],
//                                                             ),
//                                                           );
//                                                         }),
//                                                   ),
//                                                   Container(
//                                                       width: VariableUtilities
//                                                           .screenSize.width,
//                                                       decoration: BoxDecoration(
//                                                           color: ColorUtils
//                                                               .whiteColor,
//                                                           borderRadius:
//                                                               BorderRadius
//                                                                   .circular(
//                                                                       10)),
//                                                       child: Padding(
//                                                         padding:
//                                                             const EdgeInsets
//                                                                 .symmetric(
//                                                                 horizontal:
//                                                                     20.0),
//                                                         child: Column(
//                                                           crossAxisAlignment:
//                                                               CrossAxisAlignment
//                                                                   .start,
//                                                           children: [
//                                                             const Divider(),
//                                                             const SizedBox(
//                                                                 height: 5),
//                                                             Text(
//                                                               LocaleKeys.summary
//                                                                   .tr(),
//                                                               style: FontUtilities.h18(
//                                                                   fontColor:
//                                                                       ColorUtils
//                                                                           .color232323,
//                                                                   fontWeight: FWT
//                                                                       .semiBold),
//                                                             ),
//                                                             const SizedBox(
//                                                                 height: 8),
//                                                             Text(
//                                                               '${LocaleKeys.payment_method.tr()}:',
//                                                               style: FontUtilities.h18(
//                                                                   fontColor:
//                                                                       ColorUtils
//                                                                           .color232323),
//                                                             ),
//                                                             const SizedBox(
//                                                                 height: 8),
//                                                             Row(
//                                                               crossAxisAlignment:
//                                                                   CrossAxisAlignment
//                                                                       .start,
//                                                               mainAxisAlignment:
//                                                                   MainAxisAlignment
//                                                                       .spaceBetween,
//                                                               children: [
//                                                                 Text(
//                                                                   LocaleKeys.cod
//                                                                       .tr(),
//                                                                   style: FontUtilities.h18(
//                                                                       fontColor:
//                                                                           ColorUtils
//                                                                               .color232323),
//                                                                 ),
//                                                                 Text(
//                                                                   paymentProvider
//                                                                               .currentPaymentMode
//                                                                               .paymentType ==
//                                                                           PaymentType
//                                                                               .cod
//                                                                       ? '₹ ${double.parse('$totalInvoiceValue').ceil()}/-'
//                                                                       : '₹ 0.0/-',
//                                                                   style: FontUtilities.h18(
//                                                                       fontColor:
//                                                                           ColorUtils
//                                                                               .color232323),
//                                                                 ),
//                                                               ],
//                                                             ),
//                                                             const SizedBox(
//                                                                 height: 8),
//                                                             Row(
//                                                               crossAxisAlignment:
//                                                                   CrossAxisAlignment
//                                                                       .start,
//                                                               mainAxisAlignment:
//                                                                   MainAxisAlignment
//                                                                       .spaceBetween,
//                                                               children: [
//                                                                 Text(
//                                                                   LocaleKeys
//                                                                       .credit
//                                                                       .tr(),
//                                                                   style: FontUtilities.h18(
//                                                                       fontColor:
//                                                                           ColorUtils
//                                                                               .color232323),
//                                                                 ),
//                                                                 Text(
//                                                                   paymentProvider
//                                                                               .currentPaymentMode
//                                                                               .paymentType !=
//                                                                           PaymentType
//                                                                               .cod
//                                                                       ? '₹ ${double.parse('$totalInvoiceValue').ceil()}/-'
//                                                                       : '₹ 0.0/-',
//                                                                   style: FontUtilities.h18(
//                                                                       fontColor:
//                                                                           ColorUtils
//                                                                               .color232323),
//                                                                 ),
//                                                               ],
//                                                             ),
//                                                             const Divider(),
//                                                             Row(
//                                                               crossAxisAlignment:
//                                                                   CrossAxisAlignment
//                                                                       .start,
//                                                               mainAxisAlignment:
//                                                                   MainAxisAlignment
//                                                                       .spaceBetween,
//                                                               children: [
//                                                                 Text(
//                                                                   LocaleKeys
//                                                                       .total
//                                                                       .tr(),
//                                                                   style: FontUtilities.h18(
//                                                                       fontColor:
//                                                                           ColorUtils
//                                                                               .color232323),
//                                                                 ),
//                                                                 Text(
//                                                                   '₹ ${double.parse('$totalInvoiceValue').ceil()}/-',
//                                                                   style: FontUtilities.h18(
//                                                                       fontColor:
//                                                                           ColorUtils
//                                                                               .color232323),
//                                                                 ),
//                                                               ],
//                                                             ),
//                                                             const SizedBox(
//                                                                 height: 15),
//                                                           ],
//                                                         ),
//                                                       )),
//                                                 ],
//                                               );
//                                             }),
//                                       );
//                                     }),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//             bottomNavigationBar: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: PrimaryButton(
//                     width: VariableUtilities.screenSize.width,
//                     onTap: () async {
//                       if (!_formKey.currentState!.validate()) {
//                         // updatePaymentMode();

//                         return;
//                       }
//                       if (widget.deliveryOrdersArgs.resultList.subResultList
//                                   .length -
//                               1 !=
//                           _pageController.page!.toInt()) {
//                         await _pageController.nextPage(
//                             duration: const Duration(milliseconds: 400),
//                             curve: Curves.easeIn);

//                         paymentProvider.currentPage =
//                             int.parse('${_pageController.page!.toInt()}');

//                         await controller.scrollToIndex(
//                             paymentProvider.currentPage,
//                             preferPosition: AutoScrollPosition.middle);

//                         return;
//                       }
//                       updatePaymentMode();

//                       paymentProvider
//                           .updateSalesOrder(context,
//                               id: '${widget.deliveryOrdersArgs.resultList.id}',
//                               payments: paymentList,
//                               salesOrderId: widget
//                                   .deliveryOrdersArgs.resultList.salesOrderId,
//                               deliveryStatus: 'ARRIVED')
//                           .then((value) {
//                         if (value) {
//                           MixpanelManager.trackEvent(
//                               eventName: 'OpenDialog',
//                               properties: {'Dialog': 'PaymentDoneDialog'});
//                           showDialog(
//                               context: context,
//                               builder: (_) {
//                                 return StartTripDialog(
//                                   isPaymentDialog: true,
//                                   imageUrl: AssetUtils.paymentDoneIconIconImage,
//                                   title: LocaleKeys
//                                       .customer_payment_is_successfully
//                                       .tr(),
//                                   subTitle: LocaleKeys
//                                       .you_can_start_your_next_trip
//                                       .tr(),
//                                   submitTitle: LocaleKeys.continue_trip.tr(),
//                                   submitOnTap: () {
//                                     MixpanelManager.trackEvent(
//                                         eventName: 'ScreenView',
//                                         properties: {
//                                           'Screen': 'InProgressScreen'
//                                         });
//                                     Navigator.pushNamedAndRemoveUntil(
//                                         context,
//                                         RouteUtilities.inProgressScreen,
//                                         (route) => false,
//                                         arguments: InProgressArgs(
//                                             navigateFrom:
//                                                 RouteUtilities.paymentScreen));
//                                   },
//                                 );
//                               }).then((value) {
//                             MixpanelManager.trackEvent(
//                                 eventName: 'CloseDialog',
//                                 properties: {'Dialog': 'PaymentDoneDialog'});
//                           });
//                         }
//                       });
//                       // Navigator.pushNamed(
//                       //     context, RouteUtilities.returnOrdersScreen);
//                     },
//                     title: LocaleKeys.confirm.tr())),
//           ),
//           Visibility(
//               visible: (paymentProvider
//                           .getSalesOrderListByStatusResponse.isRight &&
//                       paymentProvider.getSalesOrderListByStatusResponse.right
//                           is NoDataFoundException) ||
//                   (paymentProvider.createdPaymentResponse.isRight &&
//                       paymentProvider.createdPaymentResponse.right
//                           is NoDataFoundException),
//               child: CustomCircularProgressIndicator())
//         ],
//       );
//     });
//   }

//   Widget fetchCurrentPaymentsModeWidget({required PaymentType paymentType}) {
//     switch (paymentType) {
//       case PaymentType.cod:
//         return codCard();

//       case PaymentType.credit:
//         return creditCard();

//       case PaymentType.cheque:
//         return chequeCard();

//       case PaymentType.online:
//         return onlineCard();

//       default:
//         return codCard();
//     }
//   }

//   Widget codCard() {
//     return Column(
//       children: [
//         InputField(
//             prefixSymbol: true,
//             controller: codController,
//             label: LocaleKeys.cod.tr(),
//             hintText: LocaleKeys.enter_cod_value.tr()),
//         InputField(
//             prefixSymbol: true,
//             controller: cashGivenController,
//             label: LocaleKeys.cash_given.tr(),
//             hintText: LocaleKeys.enter_cash_given_value.tr()),
//         InputField(
//             readOnly: true,
//             prefixSymbol: true,
//             controller: changeGivenController,
//             label: LocaleKeys.change_given.tr(),
//             hintText: LocaleKeys.enter_change_given_value.tr()),
//         InputField(
//           controller: codRemarksController,
//           label: LocaleKeys.remarks.tr(),
//           hintText: LocaleKeys.enter_remarks.tr(),
//           validator: (val) {
//             if (val!.isEmpty) {
//               return '${LocaleKeys.please_enter_remark.tr()}!';
//             }
//             return null;
//           },
//         ),
//       ],
//     );
//   }

//   Widget creditCard() {
//     return Column(
//       children: [
//         InputField(
//             prefixSymbol: true,
//             controller: creditController,
//             label: LocaleKeys.cod.tr(),
//             hintText: LocaleKeys.enter_cod_value.tr()),
//         InputField(
//           controller: creditRemarksController,
//           label: LocaleKeys.remarks.tr(),
//           hintText: LocaleKeys.enter_remarks.tr(),
//           validator: (val) {
//             if (val!.isEmpty) {
//               return '${LocaleKeys.please_enter_remark.tr()}!';
//             }
//             return null;
//           },
//         ),
//       ],
//     );
//   }

//   Widget chequeCard() {
//     return Column(
//       children: [
//         InputField(
//             prefixSymbol: true,
//             controller: chequeController,
//             label: LocaleKeys.cod.tr(),
//             hintText: LocaleKeys.enter_cod_value.tr()),
//         InputField(
//           controller: chequeRemarksController,
//           label: LocaleKeys.remarks.tr(),
//           hintText: LocaleKeys.enter_remarks.tr(),
//           validator: (val) {
//             if (val!.isEmpty) {
//               return '${LocaleKeys.please_enter_remark.tr()}!';
//             }
//             return null;
//           },
//         ),
//       ],
//     );
//   }

//   Widget onlineCard() {
//     return Column(
//       children: [
//         InputField(
//             prefixSymbol: true,
//             controller: onlineController,
//             label: LocaleKeys.cod.tr(),
//             hintText: LocaleKeys.enter_cod_value.tr()),
//         InputField(
//           controller: onlineRemarksController,
//           label: LocaleKeys.remarks.tr(),
//           hintText: LocaleKeys.enter_remarks.tr(),
//           validator: (val) {
//             if (val!.isEmpty) {
//               return '${LocaleKeys.please_enter_remark.tr()}!';
//             }
//             return null;
//           },
//         ),
//       ],
//     );
//   }

//   Future<void> updatePaymentMode() async {
//     paymentList = [];
//     PaymentProvider paymentProvider = Provider.of(context, listen: false);
//     if (paymentProvider.currentPaymentMode.paymentType == PaymentType.cod) {
//       paymentList.add(CreatePaymentsList(
//         paymentMode: 'cod',
//         value: int.parse(codController.text),
//         paymentDate:
//             DateFormat('yyyy-MM-dd').format((DateTime.now())).toString(),
//         paymentRemark: codRemarksController.text,
//         paymentTypes: "CASH_ON_DELIVERY",
//         chequePaymentTypes: "NONE",
//       ));
//     }

//     if (paymentProvider.currentPaymentMode.paymentType == PaymentType.cheque) {
//       paymentList.add(CreatePaymentsList(
//         value: int.parse(creditController.text),
//         paymentDate:
//             DateFormat('yyyy-MM-dd').format((DateTime.now())).toString(),
//         paymentRemark: codRemarksController.text + "," + 'PDC',
//         paymentTypes: 'CHEQUE',
//         chequePaymentTypes: 'PDC',
//         paymentMode: 'cheque',
//       ));
//     }

//     if (paymentProvider.currentPaymentMode.paymentType == PaymentType.online) {
//       paymentList.add(CreatePaymentsList(
//         value: int.parse(creditController.text),
//         paymentDate:
//             DateFormat('yyyy-MM-dd').format((DateTime.now())).toString(),
//         paymentRemark: codRemarksController.text,
//         paymentTypes: 'ONLINE',
//         chequePaymentTypes: 'NONE',
//         paymentMode: 'online',
//       ));
//     }

//     if (paymentProvider.currentPaymentMode.paymentType == PaymentType.credit) {
//       paymentList.add(CreatePaymentsList(
//         value: int.parse(creditController.text),
//         paymentDate:
//             DateFormat('yyyy-MM-dd').format((DateTime.now())).toString(),
//         paymentRemark: codRemarksController.text,
//         paymentTypes: 'CREDIT',
//         chequePaymentTypes: 'NONE',
//         paymentMode: 'credit',
//       ));
//     }
//   }

//   String getPaymentName({required PaymentType paymentType}) {
//     switch (paymentType) {
//       case PaymentType.cod:
//         return LocaleKeys.cod.tr();
//       case PaymentType.credit:
//         return LocaleKeys.credit.tr();
//       case PaymentType.cheque:
//         return LocaleKeys.cheque.tr();
//       case PaymentType.online:
//         return LocaleKeys.online.tr();
//       default:
//         return '';
//     }
//   }
// }
