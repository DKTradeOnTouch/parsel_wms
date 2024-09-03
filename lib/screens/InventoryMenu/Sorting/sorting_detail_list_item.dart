import 'package:flutter/material.dart';
import 'package:parsel_flutter/models/sku_classification_model.dart';
import 'package:parsel_flutter/resource/app_colors.dart';
import 'package:parsel_flutter/resource/app_helper.dart';

import '../../../resource/app_styles.dart';

class SortingDetailListItem extends StatefulWidget {
  final PurchaseOrder? poList;
  final SubCategoryList subList;
  TextEditingController v1Controller;
  // var formKey1;

  SortingDetailListItem({
    Key? key,
    this.poList,
    required this.v1Controller,
    required this.subList,
    // required this.formKey1,
  }) : super(key: key);

  @override
  State<SortingDetailListItem> createState() => _SortingDetailListItemState();
}

class _SortingDetailListItemState extends State<SortingDetailListItem> {
  List<TextEditingController> valueController = [];
  // GlobalKey<FormState> formKey1 = GlobalKey<FormState>();

  bool _isLoading = false;
  List<ItemList> itemList = [];
  List<SubCategoryList> subList = [];
  String? userId = '';
  int? count = 0;
  int index = 0;
  int index1 = 0;
  List<int> text = [];
  String? title;
  int sum = 0;

  void _setText() {}

  @override
  void initState() {
    super.initState();
    // widget.formKey1 = formKey1;
  }

  saleBarcodeTextfield(TextEditingController? v1Controller) {
    return Container(
        height: 40,
        padding: EdgeInsets.only(right: 10, left: 14),
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.only(left: 20, top: 10, bottom: 5),
        width: MediaQuery.of(context).size.width * 0.50,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [BoxShadow(color: Colors.green, spreadRadius: 1)]),
        child: TextFormField(
          validator: (value) {
            if (value!.isEmpty) {
              AppHelper.showSnackBar(
                  context, 'SubCategory values cannot be empty');
            }
          },
          controller: v1Controller,
          // onChanged: (value) => title = value,
          textAlign: TextAlign.start,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              border: InputBorder.none,
              hintStyle: AppStyles.inwardTextDATAStyle,
              hintText: ''),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      // key: formKey1,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
                elevation: 0.8,
                shadowColor: AppColors.blackColor.withOpacity(0.2),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.white70, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child:
                    // ListView.builder(
                    //     itemCount: widget.poList!.itemList![index].category!.subCategoryList!.length,
                    //     itemBuilder: (context, index) {
                    //       return
                    Container(
                        padding: const EdgeInsets.only(
                            left: 16, right: 16, top: 22, bottom: 22),
                        width: double.infinity,
                        child: IntrinsicHeight(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.20,
                                  child: Text(
                                    widget.subList.name.toString(),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    // widget.poList!.itemList![index].category!
                                    //     .subCategoryList![index1].name
                                    //     .toString(),
                                    style: AppStyles.sortingLastList,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(top: 10),
                                  height: 40,
                                  child: VerticalDivider(
                                    thickness: 2,
                                  ),
                                ),
                              ),
                              saleBarcodeTextfield(widget.v1Controller),
                            ],
                          ),
                        ))),
            // InkWell(
            //   onTap: () {
            //     print('TextFieldValue-->' + widget.v1Controller.text);
            //   },
            //   child: Container(
            //     height: 40,
            //     width: 50,
            //     color: Colors.green,
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
