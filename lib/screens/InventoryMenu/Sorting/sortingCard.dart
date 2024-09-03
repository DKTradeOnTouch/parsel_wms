import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parsel_flutter/models/sku_classification_model.dart';
import 'package:parsel_flutter/screens/InventoryMenu/InventoryDashboard.dart';

import 'package:parsel_flutter/screens/InventoryMenu/Sorting/Sorting_detail.dart';
import 'package:parsel_flutter/screens/InventoryMenu/Sorting/sortingFirstScreen.dart';
import 'package:parsel_flutter/screens/InventoryMenu/Sorting/sorting_detail_page.dart';

import '../../../api/api.dart';
import '../../../models/purchase_order_list_model.dart';
import '../../../resource/app_colors.dart';
import '../../../resource/app_helper.dart';
import '../../../resource/app_strings.dart';
import '../../../resource/app_styles.dart';

class SortingCardScreen extends StatefulWidget {
  String? poIDcard;
  String? productCodeCard;
  String? skuCount;
  SortingCardScreen({
    Key? key,
    this.poIDcard,
    this.productCodeCard,
    this.skuCount,
  }) : super(key: key);
  @override
  @override
  State<SortingCardScreen> createState() => _SortingCardScreenState();
}

var category;
String? poIdcard1;
String? productCode1;
String? skuCount1;

class _SortingCardScreenState extends State<SortingCardScreen> {
  List<String> sortingList = [
    'Finished',
    'Semi-finished',
    'Short',
    'Rejected',
  ];
  int isSelect = 1;
  bool? _isLoading;

  String? level;
  @override
  void initState() {
    super.initState();
  }

  Future getSKUCLASSIFICATION(BuildContext context, level) async {
    setState(() {
      _isLoading = true;
    });
    return await API
        .getSkuClassificationList(
      context, widget.poIDcard.toString(),
      widget.productCodeCard.toString(), level!,
      //  subList: []
    )
        .then(
      (SkuClassificationModel? response) async {
        setState(() {
          _isLoading = false;
        });
        if (response != null) {
          if (response.message != null) {
            AppHelper.showSnackBar(context, response.message.toString());
          } else {
            AppHelper.showSnackBar(context, response.message.toString());
          }
        } else {
          AppHelper.showSnackBar(context, AppStrings.strSomethingWentWrong);
        }

        AppHelper.changeScreen(context, InventoryDashboardScreen());
      },
    ).onError((error, stackTrace) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppHelper.appBar(
          context, 'SORTING', SortingFirstScreen(), Icons.arrow_back_ios),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              height: MediaQuery.of(context).size.height * 0.82,
              width: double.infinity,
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 21),
                        padding: EdgeInsets.all(10),
                        height: 50,
                        width: 135,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.black12,
                                  spreadRadius: 1,
                                  blurRadius: 5)
                            ]),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  isSelect = 1;
                                });
                              },
                              child: isSelect == 1
                                  ? Icon(
                                      Icons.radio_button_checked,
                                      color: AppColors.blueColor,
                                    )
                                  : Icon(
                                      Icons.radio_button_off,
                                      color: AppColors.blueColor,
                                    ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              sortingList[0],
                              style: AppStyles.goodConsumableStyle,
                            )
                          ],
                        ),
                      ),
                      // SizedBox(width: 10),
                      Container(
                        height: 50,
                        width: 130,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black12,
                                  spreadRadius: 1,
                                  blurRadius: 5)
                            ]),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 5,
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  isSelect = 2;
                                });
                              },
                              child: isSelect == 2
                                  ? Icon(
                                      Icons.radio_button_checked,
                                      color: AppColors.blueColor,
                                    )
                                  : Icon(
                                      Icons.radio_button_off,
                                      color: AppColors.blueColor,
                                    ),
                            ),
                            SizedBox(width: 5),
                            Text(
                              sortingList[1],
                              style: AppStyles.goodConsumableStyle,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 21),
                        padding: EdgeInsets.all(10),
                        height: 50,
                        width: 135,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.black12,
                                  spreadRadius: 1,
                                  blurRadius: 5)
                            ]),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  isSelect = 3;
                                });
                              },
                              child: isSelect == 3
                                  ? Icon(
                                      Icons.radio_button_checked,
                                      color: AppColors.blueColor,
                                    )
                                  : Icon(
                                      Icons.radio_button_off,
                                      color: AppColors.blueColor,
                                    ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              sortingList[2],
                              style: AppStyles.goodConsumableStyle,
                            )
                          ],
                        ),
                      ),
                      // SizedBox(width: 10),
                      Container(
                        height: 50,
                        width: 130,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black12,
                                  spreadRadius: 1,
                                  blurRadius: 5)
                            ]),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 5,
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  isSelect = 4;
                                });
                              },
                              child: isSelect == 4
                                  ? Icon(
                                      Icons.radio_button_checked,
                                      color: AppColors.blueColor,
                                    )
                                  : Icon(
                                      Icons.radio_button_off,
                                      color: AppColors.blueColor,
                                    ),
                            ),
                            // SizedBox(width: 5),
                            Text(
                              sortingList[3],
                              style: AppStyles.goodConsumableStyle,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      )),
      bottomNavigationBar: InkWell(
        onTap: () {
          print('isSelect-->' + isSelect.toString());
          isSelect == 1
              ? AppHelper.changeScreen(
                  context,
                  SortingDetailPage(isSelect = isSelect,
                      skuCount: widget.skuCount.toString(),
                      poId: widget.poIDcard.toString(),
                      productCode: widget.productCodeCard.toString()))
              : isSelect == 2
                  ? getSKUCLASSIFICATION(context, 'SEMI_FINISHED')
                  : isSelect == 3
                      ? getSKUCLASSIFICATION(context, 'SHORT')
                      : getSKUCLASSIFICATION(context, 'REJECTED');
        },
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8), topRight: Radius.circular(8)),
            color: AppColors.blueColor,
          ),
          alignment: Alignment.center,
          height: 60,
          child: Text(
            'SUBMIT',
            style: AppStyles.submitButtonStyle,
          ),
        ),
      ),
    );
  }
}
