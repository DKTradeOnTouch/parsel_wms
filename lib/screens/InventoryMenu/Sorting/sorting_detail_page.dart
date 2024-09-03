import 'package:flutter/material.dart';

import 'package:parsel_flutter/api/api.dart';
import 'package:parsel_flutter/models/skuSubCategory.dart';
import 'package:parsel_flutter/models/sku_classification_model.dart';
import 'package:parsel_flutter/resource/app_helper.dart';
import 'package:parsel_flutter/resource/app_strings.dart';
import 'package:parsel_flutter/screens/InventoryMenu/InventoryDashboard.dart';
import 'package:parsel_flutter/screens/InventoryMenu/Sorting/sorting_detail_list_item.dart';
import 'package:parsel_flutter/screens/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:parsel_flutter/models/sku_classification_model.dart' as sku;

import '../../../models/purchase_order_list_model.dart' as PO;
import '../../../models/purchase_order_list_model.dart';
import '../../../resource/app_colors.dart';
import '../../../resource/app_styles.dart';

class SortingDetailPage extends StatefulWidget {
  final String poId;
  final String productCode;
  final String skuCount;

  int isSelect;
  SortingDetailPage(
    this.isSelect, {
    Key? key,
    required this.poId,
    required this.productCode,
    required this.skuCount,
  }) : super(key: key);
  @override
  State<SortingDetailPage> createState() => _SortingDetailPageState();
}

class _SortingDetailPageState extends State<SortingDetailPage> {
  TextEditingController valueController = TextEditingController();
  String? title;
  List<TextEditingController> _value1Controllers = [];
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  PO.PurchaseOrderResultList? resultList;
  PO.ItemList? itemList;
  int? isSelect1;
  List<Classifications> subList = [];

  List<int> qty = [];
  List<int> catID = [];
  int i = 0;
  String? level;

  int? index1;

  int? subLength;
  List<SubCategoryList> _subList = [];
  @override
  void initState() {
    super.initState();
    // subLength;
    SkuClassificationButton(context, subList);
  }

  var index = 0;
  Future getSkuClassificationList(BuildContext context) async {
    return await API.getSkuClassificationListFinished(
        context, widget.poId, widget.productCode, 'FINISHED',
        subList: subList);
  }

  bool _isLoading = false;

  String? userId = '';

  int? count = 0;

  static void showLog(String message) {
    print(message.toString());
  }

  Future SkuClassificationButton(
    BuildContext context,
    List<Classifications> subList,
  ) async {
    final preference = await SharedPreferences.getInstance();
    setState(() {
      _isLoading = true;
    });
    return await API
        .getSkuClassificationListFinished(
            context, widget.poId, widget.productCode, 'FINISHED',
            subList: subList)
        .then(
      (SkuClassificationModel? response) async {
        setState(() {
          _isLoading = false;
        });
        if (response != null) {
          subLength = response.body!.purchaseOrder!.itemList![index].category!
              .subCategoryList!.length;
          response
              .body!.purchaseOrder!.itemList![index].category!.subCategoryList!
              .map((e) => _subList.add(e))
              .toList();
          // print('Sublength-->' + _subList.length.toString());
          for (i = 0; i < subLength!; i++) {
            catID.add(_subList[i].id!);
          }
          AppHelper.showSnackBar(context, response.message.toString());
        } else {
          AppHelper.showSnackBar(context, AppStrings.strSomethingWentWrong);
        }
      },
    ).onError((error, stackTrace) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  getsubList(subList, List<TextEditingController> _value1Controllers) {
    int sum = 0;

    for (int i = 0; i < subLength!; i++) {
      // print('_value1Controllers-->' + _value1Controllers[i].text);
      subList.add(Classifications(
          catId: catID[i], qty: int.parse(_value1Controllers[i].text)));
      sum += int.parse(_value1Controllers[i].text);
    }
    print('sum-->' + sum.toString());
    if (sum != int.parse(widget.skuCount)) {
      AppHelper.showSnackBar(
          context, 'SubCategory values should be equal to SKU COUNT');
    } else if (sum > int.parse(widget.skuCount)) {
      AppHelper.showSnackBar(
          context, 'SubCategory values should be less than SKU COUNT');
    } else {
      SkuClassificationButton(context, subList);
      AppHelper.showAlert('', 'CONFIRMED', context, InventoryDashboardScreen());
    }
    // print('here');
    // SkuClassificationButton(context, subList);
    // print('subList11-->' + subList.toString());
  }

  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text('SORTING', style: AppStyles.appBarTitleStyle),
          leading: GestureDetector(
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Container(
                height: 15,
                width: 15,
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  iconSize: 20.0,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          width: 130,
                          child: Text(
                            'SKU COUNT',
                            style: AppStyles.sortingTextStyle,
                          ),
                        ),
                        Text(
                          widget.skuCount.toString(),
                          style: AppStyles.inwardSKUCount,
                        )
                      ],
                    ),
                    Flexible(
                      child: FutureBuilder(
                          future: getSkuClassificationList(context),
                          builder: (ctx, asyncSnapshot) {
                            if (asyncSnapshot.connectionState ==
                                ConnectionState.done) {
                              SkuClassificationModel data =
                                  asyncSnapshot.data as SkuClassificationModel;
                              return data.body!.purchaseOrder!.itemList![index]
                                      .category!.subCategoryList!.isNotEmpty
                                  ? ListView.builder(
                                      itemCount: data
                                          .body!
                                          .purchaseOrder!
                                          .itemList![index]
                                          .category!
                                          .subCategoryList!
                                          .length,
                                      itemBuilder: (context, index) {
                                        _value1Controllers
                                            .add(TextEditingController());
                                        return SortingDetailListItem(
                                          poList: data.body!.purchaseOrder,
                                          subList: data
                                              .body!
                                              .purchaseOrder!
                                              .itemList![0]
                                              .category!
                                              .subCategoryList![index],
                                          v1Controller:
                                              _value1Controllers[index],
                                          // formKey1: formKey,
                                        );
                                      },
                                    )
                                  : Center(child: Text('No Data'));
                            } else if (asyncSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator.adaptive(),
                              );
                            } else {
                              return Container();
                            }
                          }),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                // if (formKey.currentState!.validate()) {
                getsubList(subList, _value1Controllers);
                // }
              },
              child: Container(
                height: 60,
                decoration: const BoxDecoration(
                  color: AppColors.blueColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0)),
                ),
                width: double.infinity,
                child: Center(
                  child: Text(
                    AppStrings.strSubmit,
                    style: AppStyles.buttonTextStyle,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
