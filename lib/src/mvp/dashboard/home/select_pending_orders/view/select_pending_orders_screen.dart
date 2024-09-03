import 'package:easy_localization/easy_localization.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/select_pending_orders/model/loaded_truck_model.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/select_pending_orders/provider/select_pending_orders_provider.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/select_pending_orders/widget/expandable_text.dart';
import 'package:parsel_flutter/src/widget/widget.dart';
import 'package:parsel_flutter/utils/utils.dart';
import 'package:provider/provider.dart';

class SelectPendingOrdersScreen extends StatefulWidget {
  const SelectPendingOrdersScreen({Key? key, required this.warehouseName})
      : super(key: key);

  @override
  State<SelectPendingOrdersScreen> createState() =>
      _SelectPendingOrdersScreenState();
  final String warehouseName;
}

class _SelectPendingOrdersScreenState extends State<SelectPendingOrdersScreen>
    with TickerProviderStateMixin {
  TextEditingController skuController = TextEditingController();
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _heightAnimation;
  late Animation<double> _fadeAnimation;
  @override
  void initState() {
    SelectPendingOrdersProvider selectPendingOrdersProvider =
        Provider.of(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      selectPendingOrdersProvider.getSkuGroupByUserIdResponse =
          Right(StaticException());
      selectPendingOrdersProvider.isAllOrdersSelected = false;
      selectPendingOrdersProvider.pendingOrderList = [];
      selectPendingOrdersProvider.searchPendingOrderList = [];
      selectPendingOrdersProvider.selectedPendingOrderList = [];
      await selectPendingOrdersProvider.getSkuGroupByUserId(context);
      await selectPendingOrdersProvider.callLoadedTruckApi(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (skuController.text.isNotEmpty) {
          skuController.text = '';
          setState(() {});
          return false;
        }
        return Future.value(true);
      },
      child: Consumer(builder: (context,
          SelectPendingOrdersProvider selectPendingOrdersProvider, _) {
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
                        height: 150,
                        decoration: const BoxDecoration(
                            // color: ColorUtils.blueColor,
                            image: DecorationImage(
                                image: AssetImage(AssetUtils.authBgImage),
                                fit: BoxFit.cover)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const SizedBox(height: 5),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Row(children: [
                                      IconButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          icon: Image.asset(
                                            AssetUtils.cancelImage,
                                            height: 15,
                                            width: 15,
                                          )),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          '${selectPendingOrdersProvider.selectedPendingOrderList.length} ${LocaleKeys.selected_of_orders.tr()} ${selectPendingOrdersProvider.pendingOrderList.length} ${LocaleKeys.orders.tr()}',
                                          maxLines: 2,
                                          style: FontUtilities.h20(
                                              fontColor: ColorUtils.whiteColor),
                                        ),
                                      )
                                    ]),
                                  ),
                                  skuController.text.isNotEmpty
                                      ? const SizedBox()
                                      : GestureDetector(
                                          onTap: () async {
                                            selectPendingOrdersProvider
                                                .selectAllItem();
                                          },
                                          child: Container(
                                              color: Colors.transparent,
                                              height: 50,
                                              width: 50,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    height: 22,
                                                    width: 22,
                                                    decoration: BoxDecoration(
                                                        color:
                                                            Colors.transparent,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(3),
                                                        border: Border.all(
                                                            color: ColorUtils
                                                                .whiteColor,
                                                            width: 1.5)),
                                                    child: selectPendingOrdersProvider
                                                            .isAllOrdersSelected
                                                        ? const Center(
                                                            child: Icon(
                                                              Icons.check,
                                                              size: 17,
                                                              color: ColorUtils
                                                                  .whiteColor,
                                                            ),
                                                          )
                                                        : const SizedBox(),
                                                  ),
                                                ],
                                              )),
                                        )
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 18.0),
                              child: InputField(
                                onChanged: (String val) {
                                  if (val.isEmpty) {
                                    selectPendingOrdersProvider
                                        .searchPendingOrderList = [];
                                    return;
                                  }
                                  selectPendingOrdersProvider
                                      .searchPendingOrderList = [];

                                  for (int i = 0;
                                      i <
                                          selectPendingOrdersProvider
                                              .pendingOrderList.length;
                                      i++) {
                                    if (selectPendingOrdersProvider
                                        .pendingOrderList[i].skuName
                                        .toLowerCase()
                                        .contains(val.toLowerCase())) {
                                      selectPendingOrdersProvider
                                          .searchPendingOrderList
                                          .add(selectPendingOrdersProvider
                                              .pendingOrderList[i]);
                                    }
                                  }
                                },
                                prefixIcon: const Icon(
                                  Icons.search,
                                  size: 25,
                                  color: ColorUtils.blackColor,
                                ),
                                controller: skuController,
                                label: '',
                                hintTextStyle: FontUtilities.h16(
                                    fontColor: ColorUtils.colorA4A9B0),
                                hintText: LocaleKeys.search_sku_here.tr(),

                                ///If we need to add sku dialog just uncomment this...
                                // suffixIcon: Column(
                                //   crossAxisAlignment: CrossAxisAlignment.center,
                                //   mainAxisAlignment: MainAxisAlignment.center,
                                //   children: [
                                //     InkWell(
                                //       onTap: () {
                                //         _animationController =
                                //             AnimationController(
                                //           duration:
                                //               const Duration(milliseconds: 800),
                                //           vsync: this,
                                //         );

                                //         final curvedAnimation = CurvedAnimation(
                                //           parent: _animationController,
                                //           curve: Curves.easeInOut,
                                //         );

                                //         _slideAnimation = Tween<Offset>(
                                //           begin: const Offset(0,
                                //               -1), // Start from the bottom of the screen
                                //           end: Offset.zero,
                                //         ).animate(curvedAnimation);

                                //         _fadeAnimation = Tween<double>(
                                //           begin: 0.0,
                                //           end: 1.0,
                                //         ).animate(curvedAnimation);

                                //         _animationController.forward();

                                //         MixpanelManager.trackEvent(
                                //             eventName: 'OpenDialog',
                                //             properties: {
                                //               'Dialog':
                                //                   'ShowPendingOrderListDialog'
                                //             });

                                //         showDialog(
                                //             context: context,
                                //             builder: (_) {
                                //               return FadeTransition(
                                //                 opacity: _fadeAnimation,
                                //                 child: SlideTransition(
                                //                     position: _slideAnimation,
                                //                     child: Padding(
                                //                       padding:
                                //                           const EdgeInsets.all(
                                //                               15.0),
                                //                       child: Material(
                                //                         color:
                                //                             Colors.transparent,
                                //                         borderRadius:
                                //                             BorderRadius
                                //                                 .circular(20),
                                //                         child: Center(
                                //                           child: Container(
                                //                             width:
                                //                                 VariableUtilities
                                //                                     .screenSize
                                //                                     .width,
                                //                             decoration:
                                //                                 BoxDecoration(
                                //                               color: ColorUtils
                                //                                   .whiteColor,
                                //                               borderRadius:
                                //                                   BorderRadius
                                //                                       .circular(
                                //                                           10),
                                //                             ),
                                //                             child:
                                //                                 SingleChildScrollView(
                                //                               child: Padding(
                                //                                 padding: const EdgeInsets
                                //                                     .symmetric(
                                //                                     vertical:
                                //                                         15.0),
                                //                                 child: Stack(
                                //                                   children: [
                                //                                     Column(
                                //                                         children: [
                                //                                           ListView.builder(
                                //                                               physics: const NeverScrollableScrollPhysics(),
                                //                                               shrinkWrap: true,
                                //                                               itemCount: selectPendingOrdersProvider.pendingOrderList.length,
                                //                                               itemBuilder: (_, index) {
                                //                                                 return Padding(
                                //                                                   padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                //                                                   child: Column(
                                //                                                     children: [
                                //                                                       Row(
                                //                                                         crossAxisAlignment: CrossAxisAlignment.center,
                                //                                                         mainAxisAlignment: MainAxisAlignment.center,
                                //                                                         children: [
                                //                                                           Image.asset(
                                //                                                             AssetUtils.parselSkuIconImage,
                                //                                                             height: 40,
                                //                                                             width: 40,
                                //                                                           ),
                                //                                                           const SizedBox(width: 15),
                                //                                                           Expanded(
                                //                                                             child: Text(selectPendingOrdersProvider.pendingOrderList[index].skuName, overflow: TextOverflow.ellipsis, maxLines: 2, style: FontUtilities.h15(fontColor: ColorUtils.color3F3E3E)),
                                //                                                           ),
                                //                                                         ],
                                //                                                       ),
                                //                                                       (index == selectPendingOrdersProvider.pendingOrderList.length - 1)
                                //                                                           ? const SizedBox()
                                //                                                           : Column(
                                //                                                               children: [
                                //                                                                 const SizedBox(height: 10),
                                //                                                                 Container(
                                //                                                                   width: VariableUtilities.screenSize.width,
                                //                                                                   height: 1,
                                //                                                                   color: ColorUtils.colorC8D3E7,
                                //                                                                 ),
                                //                                                                 const SizedBox(height: 10),
                                //                                                               ],
                                //                                                             ),
                                //                                                     ],
                                //                                                   ),
                                //                                                 );
                                //                                               })
                                //                                         ]),
                                //                                     Visibility(
                                //                                       visible: selectPendingOrdersProvider
                                //                                           .pendingOrderList
                                //                                           .isEmpty,
                                //                                       child:
                                //                                           Center(
                                //                                         child: Lottie.asset(
                                //                                             AssetUtils
                                //                                                 .notAssignedPendingOrdersLottie,
                                //                                             height:
                                //                                                 250),
                                //                                       ),
                                //                                     ),
                                //                                   ],
                                //                                 ),
                                //                               ),
                                //                             ),
                                //                           ),
                                //                         ),
                                //                       ),
                                //                     )),
                                //               );
                                //             }).then((value) {
                                //           MixpanelManager.trackEvent(
                                //               eventName: 'CloseDialog',
                                //               properties: {
                                //                 'Dialog':
                                //                     'ShowPendingOrderListDialog'
                                //               });

                                //           _animationController.dispose();
                                //         });
                                //       },
                                //       child: Image.asset(
                                //         AssetUtils.skuIconImage,
                                //         height: 35,
                                //         width: 35,
                                //       ),
                                //     ),
                                //   ],
                                // ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Stack(
                          children: [
                            Column(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: VariableUtilities.screenSize.height,
                                    width: VariableUtilities.screenSize.width,
                                    decoration: const BoxDecoration(
                                        color: ColorUtils.whiteColor,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                        )),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20.0, vertical: 20),
                                          child: Text(
                                            '${LocaleKeys.today.tr()}, ${GlobalVariablesUtils.getCurrentDate(locale: EasyLocalization.of(context)?.currentLocale?.languageCode ?? '')}',
                                            style: FontUtilities.h18(
                                              fontColor: ColorUtils.color2B2A2A,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Stack(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 10,
                                                    right: 15,
                                                    left: 10),
                                                child: ListView.builder(
                                                    physics:
                                                        const BouncingScrollPhysics(),
                                                    shrinkWrap: true,
                                                    itemCount: skuController
                                                            .text.isEmpty
                                                        ? selectPendingOrdersProvider
                                                            .pendingOrderList
                                                            .length
                                                        : selectPendingOrdersProvider
                                                            .searchPendingOrderList
                                                            .length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                        children: [
                                                          GestureDetector(
                                                            onTap: () {
                                                              if (skuController
                                                                  .text
                                                                  .isEmpty) {
                                                                selectPendingOrdersProvider.selectItem(
                                                                    skuName: selectPendingOrdersProvider
                                                                        .pendingOrderList[
                                                                            index]
                                                                        .skuName);
                                                              } else {
                                                                selectPendingOrdersProvider.selectSearchItem(
                                                                    selectPendingOrdersProvider
                                                                        .searchPendingOrderList[
                                                                            index]
                                                                        .skuName);
                                                              }
                                                            },
                                                            child: Container(
                                                                color: Colors
                                                                    .transparent,
                                                                height: 60,
                                                                width: 50,
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Container(
                                                                        height:
                                                                            22,
                                                                        width:
                                                                            22,
                                                                        decoration: BoxDecoration(
                                                                            color: Colors.transparent,
                                                                            borderRadius: BorderRadius.circular(3),
                                                                            border: Border.all(
                                                                                width: 1.5,
                                                                                color: skuController.text.isEmpty
                                                                                    ? selectPendingOrdersProvider.pendingOrderList[index].isItemSelected
                                                                                        ? ColorUtils.primaryColor
                                                                                        : ColorUtils.colorC8D3E7
                                                                                    : selectPendingOrdersProvider.searchPendingOrderList[index].isItemSelected
                                                                                        ? ColorUtils.primaryColor
                                                                                        : ColorUtils.colorC8D3E7)),
                                                                        child: skuController.text.isEmpty
                                                                            ? selectPendingOrdersProvider.pendingOrderList[index].isItemSelected
                                                                                ? Center(
                                                                                    child: Icon(
                                                                                      Icons.check,
                                                                                      size: 17,
                                                                                      color: selectPendingOrdersProvider.pendingOrderList[index].isItemSelected ? ColorUtils.primaryColor : ColorUtils.colorC8D3E7,
                                                                                    ),
                                                                                  )
                                                                                : const SizedBox()
                                                                            : selectPendingOrdersProvider.searchPendingOrderList[index].isItemSelected
                                                                                ? Center(
                                                                                    child: Icon(
                                                                                      Icons.check,
                                                                                      size: 17,
                                                                                      color: selectPendingOrdersProvider.searchPendingOrderList[index].isItemSelected ? ColorUtils.primaryColor : ColorUtils.colorC8D3E7,
                                                                                    ),
                                                                                  )
                                                                                : const SizedBox())
                                                                  ],
                                                                )),
                                                          ),
                                                          Expanded(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      bottom:
                                                                          8.0),
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                    border: Border.all(
                                                                        color: ColorUtils
                                                                            .colorC8D3E7)),
                                                                child: Column(
                                                                  children: [
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .all(
                                                                          10.0),
                                                                      child:
                                                                          Row(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Image
                                                                              .asset(
                                                                            AssetUtils.parselSkuIconImage,
                                                                            height:
                                                                                40,
                                                                            width:
                                                                                40,
                                                                          ),
                                                                          const SizedBox(
                                                                              width: 5),
                                                                          Expanded(
                                                                            child:
                                                                                Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                ExpandableText(capitalizeFirstLetter(skuController.text.isEmpty ? selectPendingOrdersProvider.pendingOrderList[index].skuName : selectPendingOrdersProvider.searchPendingOrderList[index].skuName)),
                                                                                const SizedBox(height: 8),
                                                                                Row(
                                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  children: [
                                                                                    Text(
                                                                                      '${LocaleKeys.qty.tr()} : ${skuController.text.isEmpty ? selectPendingOrdersProvider.pendingOrderList[index].qty : selectPendingOrdersProvider.searchPendingOrderList[index].qty}',
                                                                                      style: FontUtilities.h14(fontColor: ColorUtils.colorA4A9B0),
                                                                                    ),
                                                                                    Row(
                                                                                      children: [
                                                                                        BorderContainer(
                                                                                          onTap: () {
                                                                                            if (skuController.text.isEmpty) {
                                                                                              selectPendingOrdersProvider.decreaseItemQty(selectPendingOrdersProvider.pendingOrderList[index].skuName);
                                                                                            } else {
                                                                                              selectPendingOrdersProvider.decreaseItemQty(selectPendingOrdersProvider.searchPendingOrderList[index].skuName);
                                                                                            }
                                                                                          },
                                                                                          isBorderLeft: true,
                                                                                          isBorderTop: true,
                                                                                          isBorderBottom: true,
                                                                                          isBorderRadiusTopLeft: true,
                                                                                          isBorderRadiusBottomLeft: true,
                                                                                          isBorderRight: true,
                                                                                          child: Image.asset(
                                                                                            AssetUtils.minusIconImage,
                                                                                            width: 15,
                                                                                          ),
                                                                                        ),
                                                                                        BorderContainer(
                                                                                            isCenter: true,
                                                                                            isBorderTop: true,
                                                                                            isBorderBottom: true,
                                                                                            isBorderRight: true,
                                                                                            isBorderLeft: true,
                                                                                            child: Expanded(
                                                                                              child: Center(
                                                                                                child: Text('${skuController.text.isEmpty ? selectPendingOrdersProvider.pendingOrderList[index].qty : selectPendingOrdersProvider.searchPendingOrderList[index].qty}', style: FontUtilities.h14(fontColor: ColorUtils.primaryColor)),
                                                                                              ),
                                                                                            )),
                                                                                        BorderContainer(
                                                                                          onTap: () {
                                                                                            if (skuController.text.isEmpty) {
                                                                                              selectPendingOrdersProvider.increaseItemQty(selectPendingOrdersProvider.pendingOrderList[index].skuName);
                                                                                            } else {
                                                                                              selectPendingOrdersProvider.increaseItemQty(selectPendingOrdersProvider.searchPendingOrderList[index].skuName);
                                                                                            }
                                                                                          },
                                                                                          isBorderRight: true,
                                                                                          isBorderTop: true,
                                                                                          isBorderBottom: true,
                                                                                          isBorderLeft: true,
                                                                                          isBorderRadiusTopRight: true,
                                                                                          isBorderRadiusBottomRight: true,
                                                                                          child: Image.asset(AssetUtils.plusIconImage, width: 15),
                                                                                        ),
                                                                                      ],
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      );
                                                    }),
                                              ),
                                              Visibility(
                                                visible: ((skuController
                                                            .text.isNotEmpty &&
                                                        selectPendingOrdersProvider
                                                            .searchPendingOrderList
                                                            .isEmpty) ||
                                                    (selectPendingOrdersProvider
                                                        .pendingOrderList
                                                        .isEmpty)),
                                                child: Center(
                                                  child: Lottie.asset(
                                                      AssetUtils
                                                          .notAssignedPendingOrdersLottie,
                                                      height: 250),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Visibility(
                                visible: (selectPendingOrdersProvider
                                            .getSkuGroupByUserIdResponse
                                            .isRight &&
                                        selectPendingOrdersProvider
                                            .getSkuGroupByUserIdResponse
                                            .right is NoDataFoundException) ||
                                    (selectPendingOrdersProvider
                                            .loadedTruckResponse.isRight &&
                                        selectPendingOrdersProvider
                                            .loadedTruckResponse
                                            .right is NoDataFoundException),
                                child: CustomCircularProgressIndicator(
                                  backgroundColor: ColorUtils.whiteColor,
                                ))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: Visibility(
                visible: ((skuController.text.isNotEmpty &&
                        selectPendingOrdersProvider
                            .searchPendingOrderList.isNotEmpty) ||
                    (skuController.text.isEmpty &&
                        selectPendingOrdersProvider
                            .pendingOrderList.isNotEmpty)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(children: [
                    Expanded(
                      child: PrimaryButton(
                          width: VariableUtilities.screenSize.width / 2,
                          onTap: () {
                            Navigator.pop(context);
                          },
                          title: LocaleKeys.cancel.tr()),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: PrimaryButton(
                          borderColor: ColorUtils.color0D1F3D,
                          titleColor: ColorUtils.color0D1F3D,
                          color: Colors.transparent,
                          width: VariableUtilities.screenSize.width / 2,
                          onTap: () {
                            if (selectPendingOrdersProvider
                                .selectedPendingOrderList.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: LocaleKeys.please_pick_at_least_one_order
                                      .tr());
                              return;
                            }

                            MixpanelManager.trackEvent(
                                eventName: 'OpenDialog',
                                properties: {'Dialog': 'ReadyToPickUpDialog'});

                            showDialog(
                                context: context,
                                builder: (context) {
                                  return CustomAlertDialog(
                                    imageUrl: AssetUtils.pickUpTruckIconImage,
                                    rejectOnTap: () {
                                      Navigator.pop(context);
                                    },
                                    rejectTitle: LocaleKeys.reject.tr(),
                                    subTitle: LocaleKeys.pickup_title.tr(),
                                    submitOnTap: () {
                                      MixpanelManager.trackEvent(
                                          eventName: 'CloseDialog',
                                          properties: {
                                            'Dialog': 'ReadyToPickUpDialog'
                                          });

                                      Navigator.pop(context);
                                      MixpanelManager.trackEvent(
                                          eventName: 'OpenBottomSheet',
                                          properties: {
                                            'BottomSheet':
                                                'ReadyToPickUpBottomSheet'
                                          });
                                      showModalBottomSheet(
                                          context: context,
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(20),
                                                  topRight:
                                                      Radius.circular(20))),
                                          builder: (context) {
                                            return Theme(
                                              data: ThemeData(
                                                  useMaterial3: false),
                                              child: PickUpLoadBottomSheet(
                                                warehouseName:
                                                    widget.warehouseName,
                                                loadedTruckModel:
                                                    selectPendingOrdersProvider
                                                            .loadedTruckResponse
                                                            .isLeft
                                                        ? selectPendingOrdersProvider
                                                            .loadedTruckResponse
                                                            .left
                                                        : LoadedTruckModel(
                                                            data: TruckData(
                                                                compartments: [],
                                                                vehicleNumber:
                                                                    '',
                                                                weightMeta: ''),
                                                            message: '',
                                                            status: false),
                                                onOkPress: () {
                                                  Navigator.pop(context);
                                                  print(
                                                      'selectPendingOrdersProvider --> ${selectPendingOrdersProvider.getSkuGroupByUserIdResponse.isLeft}');
                                                  if (selectPendingOrdersProvider
                                                      .getSkuGroupByUserIdResponse
                                                      .isLeft) {
                                                    MixpanelManager.trackEvent(
                                                        eventName: 'ScreenView',
                                                        properties: {
                                                          'Screen':
                                                              'DispatchSummaryScreen'
                                                        });

                                                    selectPendingOrdersProvider
                                                        .pendingOrderList;
                                                    Navigator.pushNamed(
                                                        context,
                                                        RouteUtilities
                                                            .dispatchSummaryScreen,
                                                        arguments:
                                                            selectPendingOrdersProvider
                                                                .getSkuGroupByUserIdResponse
                                                                .left
                                                                .body
                                                                .data);
                                                  }
                                                },
                                              ),
                                            );
                                          }).then((value) {
                                        MixpanelManager.trackEvent(
                                            eventName: 'CloseBottomSheet',
                                            properties: {
                                              'BottomSheet':
                                                  'ReadyToPickUpBottomSheet'
                                            });
                                      });
                                    },
                                    submitTitle: LocaleKeys.pick_up_load.tr(),
                                    title: LocaleKeys.ready_to_pickup.tr(),
                                  );
                                });
                          },
                          title: LocaleKeys.pick_up.tr()),
                    )
                  ]),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  String addThreeDotsBeforeLastWord(String text) {
    // Split the text into words
    List<String> words = text.split(" ");

    if (words.length <= 1) {
      // If there's only one word, return the original text
      return text;
    } else {
      // Get the last word
      String lastWord = words.removeLast();

      // Combine the remaining words with three dots before the last word
      return words.join(" ") + " .... " + lastWord;
    }
  }
}
