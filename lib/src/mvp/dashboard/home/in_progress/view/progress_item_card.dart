import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:parsel_flutter/src/mvp/dashboard/home/in_progress/model/get_sales_order_list_by_status_model.dart';
import 'package:parsel_flutter/src/widget/widget.dart';
import 'package:parsel_flutter/utils/utils.dart';

class ProgressItemCard extends StatelessWidget {
  const ProgressItemCard(
      {Key? key,
      required this.inProgressItemModel,
      this.onArrivedTap,
      this.navigateFrom,
      this.onDirectionTap,
      required this.index})
      : super(key: key);
  final ResultList inProgressItemModel;
  final VoidCallback? onArrivedTap;
  final VoidCallback? onDirectionTap;
  final NavigateFrom? navigateFrom;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print(inProgressItemModel.subResultList.length);
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 15.0),
        child: Container(
          // padding: const EdgeInsets.all(10),
          width: VariableUtilities.screenSize.width,
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: ColorUtils.blackColor.withOpacity(0.1),
                    blurRadius: 4,
                    spreadRadius: -2,
                    offset: const Offset(0, -1))
              ],
              borderRadius: BorderRadius.circular(10),
              color: ColorUtils.whiteColor),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            capitalizeFirstLetter(
                                inProgressItemModel.storeName),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: FontUtilities.h16(
                                fontColor: ColorUtils.color3F3E3E),
                          ),
                        ),
                        const SizedBox(width: 3),
                        inProgressItemModel.subResultList.length <= 1
                            ? Text(
                                '#${inProgressItemModel.id}',
                                style: FontUtilities.h16(
                                    fontColor: ColorUtils.colorA4A9B0),
                              )
                            : const SizedBox(),
                        const SizedBox(width: 10),
                        // navigateFrom == NavigateFrom.inProgress
                        //     ? false
                        //         ? Container(
                        //             padding: const EdgeInsets.all(8),
                        //             decoration: BoxDecoration(
                        //                 borderRadius: BorderRadius.circular(5),
                        //                 color: ColorUtils.colorE9FAF2),
                        //             child: Row(children: [
                        //               Container(
                        //                 height: 18,
                        //                 width: 18,
                        //                 decoration: BoxDecoration(
                        //                     shape: BoxShape.circle,
                        //                     border: Border.all(
                        //                         width: 2,
                        //                         color: ColorUtils.color0DB65B)),
                        //                 child: Column(
                        //                     crossAxisAlignment:
                        //                         CrossAxisAlignment.center,
                        //                     mainAxisAlignment:
                        //                         MainAxisAlignment.center,
                        //                     children: [
                        //                       Container(
                        //                         height: 10,
                        //                         width: 10,
                        //                         decoration: const BoxDecoration(
                        //                           shape: BoxShape.circle,
                        //                           color: ColorUtils.color0DB65B,
                        //                         ),
                        //                       )
                        //                     ]),
                        //               ),
                        //               const SizedBox(width: 5),
                        //               Text(
                        //                 LocaleKeys.active.tr(),
                        //                 style: FontUtilities.h16(
                        //                     fontColor: ColorUtils.color0DB65B),
                        //               )
                        //             ]),
                        //           )
                        //         : const SizedBox()
                        //     : const SizedBox()
                      ],
                    ),
                    const SizedBox(height: 10),
                    inProgressItemModel.subResultList.length <= 1
                        ? const SizedBox()
                        : Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '${LocaleKeys.invoice_no.tr()}: ',
                                    style: FontUtilities.h16(
                                        fontColor: ColorUtils.colorA4A9B0),
                                  ),
                                  Expanded(
                                    child: SingleChildScrollView(
                                      physics: const BouncingScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 3.0),
                                        child: Text(
                                          inProgressItemModel.subResultList
                                              .map((e) => e.id)
                                              .toString()
                                              .replaceAll("(", "")
                                              .replaceAll(")", "")
                                              .split(",")
                                              .join(" |"),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: FontUtilities.h16(
                                              fontColor:
                                                  ColorUtils.color3F3E3E),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: ColorUtils.colorEDF1FF),
                          child: Center(
                              child: Image.asset(
                            AssetUtils.locationImage,
                            height: 20,
                            width: 20,
                            color: ColorUtils.color0640FC,
                          )),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                capitalizeFirstLetter(
                                    inProgressItemModel.deliveryAddress),
                                style: FontUtilities.h16(
                                    fontColor: ColorUtils.colorA4A9B1),
                              ),
                              const SizedBox(height: 10),
                              navigateFrom == NavigateFrom.inProgress
                                  ? Row(
                                      children: [
                                        Expanded(
                                          child: PrimaryButton(
                                              visibilityColor: (inProgressItemModel
                                                              .deliveryAddressCoordinates
                                                              .lat ==
                                                          0.0 ||
                                                      inProgressItemModel
                                                              .deliveryAddressCoordinates
                                                              .long ==
                                                          0.0)
                                                  ? ColorUtils.blackColor
                                                      .withOpacity(0.1)
                                                  : null,
                                              color: Colors.transparent,
                                              textStyle: FontUtilities.h18(
                                                  fontColor:
                                                      ColorUtils.color0D1F3D),
                                              height: 40,
                                              titleImage: Image.asset(
                                                AssetUtils.directionIconImage,
                                                height: 20,
                                                width: 20,
                                              ),
                                              onTap: onDirectionTap ?? () {},
                                              title: LocaleKeys.direction.tr()),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: PrimaryButton(
                                              titleImage: Image.asset(
                                                AssetUtils.arrivedIconImage,
                                                height: 20,
                                                width: 20,
                                              ),
                                              height: 40,
                                              onTap: onArrivedTap ?? () {},
                                              title: LocaleKeys.arrived.tr()),
                                        ),
                                      ],
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              inProgressItemModel.subResultList.length > 1
                  ? Container(
                      decoration: const BoxDecoration(
                          color: ColorUtils.colorEAEAEA,
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10))),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 2.5),
                      width: VariableUtilities.screenSize.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                              LocaleKeys.this_delivery_contains.plural(
                                  inProgressItemModel.subResultList.length),
                              maxLines: 2,
                              style: FontUtilities.h14(
                                  fontColor: ColorUtils.color828282)),
                        ],
                      ),
                    )
                  : const SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
