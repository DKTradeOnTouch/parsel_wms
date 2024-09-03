import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:parsel_flutter/src/mvp/dashboard/home/payment/model/payment_model.dart';
import 'package:parsel_flutter/utils/utils.dart';

typedef CallBack = Function(PaymentModel input);

class PaymentMethodView extends StatefulWidget {
  const PaymentMethodView(
      {super.key,
      required this.paymentModelList,
      required this.currentPaymentMode,
      required this.callBack,
      required this.currentPaymentModeList});
  final List<PaymentModel> paymentModelList;
  final PaymentModel currentPaymentMode;
  final List<PaymentModel> currentPaymentModeList;
  final CallBack callBack;
  @override
  State<PaymentMethodView> createState() => _PaymentMethodViewState();
}

class _PaymentMethodViewState extends State<PaymentMethodView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 2.5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                LocaleKeys.payment_method.tr(),
                style: FontUtilities.h20(fontColor: ColorUtils.color3F3E3E),
              ),
              const SizedBox(width: 10),
              CircleAvatar(
                backgroundColor: ColorUtils.colorF7E7E9,
                radius: 12,
                child: Center(
                  child: Image.asset(AssetUtils.lockIconImage, height: 12),
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
                widget.paymentModelList.length,
                (index) => Row(
                      children: [
                        index == 0
                            ? const SizedBox(width: 15)
                            : const SizedBox(),
                        GestureDetector(
                          onTap: () {
                            widget.callBack(widget.paymentModelList[index]);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Container(
                                height: 95,
                                width: 95,
                                decoration: BoxDecoration(
                                    color: ColorUtils.whiteColor,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: widget.currentPaymentModeList
                                                .contains(widget
                                                    .paymentModelList[index])
                                            ? ColorUtils.primaryColor
                                            : Colors.transparent),
                                    boxShadow: [
                                      BoxShadow(
                                          color: ColorUtils.blackColor
                                              .withOpacity(0.5),
                                          blurRadius: 4,
                                          spreadRadius: -2,
                                          offset: const Offset(0, 1))
                                    ]),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                        widget.paymentModelList[index].imageUrl,
                                        height: 40),
                                    const SizedBox(height: 5),
                                    Text(
                                      widget.paymentModelList[index].title,
                                      style: FontUtilities.h16(
                                          fontColor: ColorUtils.color3F3E3E),
                                    )
                                  ],
                                )),
                          ),
                        ),
                        index == 3
                            ? const SizedBox(width: 15)
                            : const SizedBox(),
                      ],
                    )),
          ),
        ),
      ],
    );
  }
}
