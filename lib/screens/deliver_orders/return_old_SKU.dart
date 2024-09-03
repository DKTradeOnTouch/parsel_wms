import 'package:flutter/material.dart';
import 'package:parsel_flutter/utils/utils.dart';
import 'package:parsel_flutter/models/SalesOrderBYID_Model.dart';
import 'package:parsel_flutter/models/despatch_sum_item.dart';
import 'package:parsel_flutter/resource/app_colors.dart';
import 'package:parsel_flutter/resource/app_fonts.dart';
import 'package:parsel_flutter/resource/app_helper.dart';
import 'package:parsel_flutter/resource/app_strings.dart';

import '../../resource/app_styles.dart';
import 'delivery_summary_page.dart';

class ReturnOldSKU extends StatefulWidget {
  const ReturnOldSKU({Key? key}) : super(key: key);

  @override
  State<ReturnOldSKU> createState() => _ReturnOldSKUState();
}

class _ReturnOldSKUState extends State<ReturnOldSKU> {
  List<DespatchSummaryItem> _deliveryValues = [];

  //adding static data as despatch summary details -

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHelper.appbarWithActionIcon2(
          context,
          'RETURN OLD SKU',
          DeliverySummaryPage(
              salesOrder: SalesOrderBYID_Model(),
              id: '',
              Salesorderid: '',
              diff: '',
              dataList: [],
              dataup: [],
              deliverOrdersList: []),
          DeliverySummaryPage(
              salesOrder: SalesOrderBYID_Model(),
              id: '',
              Salesorderid: '',
              diff: '',
              dataList: [],
              dataup: [],
              deliverOrdersList: []),
          Icons.arrow_back_ios,
          Icons.add),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 56,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 35),
            color: AppColors.lightBlueColor,
            child: Text(
              AppStrings.strReSkuStore,
              style: TextStyle(
                  fontFamily: appFontFamily,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: AppColors.black2Color),
            ),
          ),
          Row(
            children: [
              Container(
                height: 40,
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                alignment: Alignment.centerRight,
                margin: EdgeInsets.only(left: 35, top: 10, bottom: 5),
                width: MediaQuery.of(context).size.width * 0.65,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(color: Colors.black12, spreadRadius: 1)
                    ]),
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.25,
                      child: TextField(
                        textAlign: TextAlign.start,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintStyle: AppStyles.inwardTextDATAStyle,
                            hintText: 'SKU Name'),
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      height: 40,
                      child: VerticalDivider(
                        thickness: 2,
                      ),
                    ),
                    SizedBox(
                      width: 14.5,
                    ),
                    // Text('Qty'),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: TextField(
                        textAlign: TextAlign.start,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintStyle: AppStyles.inwardTextDATAStyle,
                            hintText: 'QTY'),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 17,
              ),
              InkWell(
                  onTap: () {},
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(13),
                    decoration: BoxDecoration(
                      color: AppColors.black2Color,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          offset: Offset(5, 5),
                          blurRadius: 10,
                        )
                      ],
                    ),
                    child: Icon(
                      Icons.delete,
                      color: AppColors.whiteColor,
                      size: 16,
                    ),
                  )),
            ],
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: MaterialButton(
          height: 60.0,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DeliverySummaryPage(
                      salesOrder: SalesOrderBYID_Model(),
                      id: '',
                      Salesorderid: '',
                      diff: '',
                      dataList: [],
                      dataup: [],
                      deliverOrdersList: []),
                ));
          },
          child: const Text(
            AppConstants.kSAVE,
            style: TextStyle(
              color: Colors.white,
              fontFamily: appFontFamily,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          color: ColorUtils.kBottomButtonColor,
        ),
      ),
    );
  }
}
