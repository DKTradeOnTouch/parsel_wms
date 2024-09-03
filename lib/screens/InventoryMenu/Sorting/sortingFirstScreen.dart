import 'package:flutter/material.dart';
import 'package:parsel_flutter/models/purchase_order_list_model.dart';
import 'package:parsel_flutter/resource/app_helper.dart';
import 'package:parsel_flutter/screens/InventoryMenu/InventoryDashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../api/api.dart';
import '../../../models/Storage_model.dart';
import '../../../resource/app_strings.dart';
import 'sortingList.dart';

class SortingFirstScreen extends StatefulWidget {
  const SortingFirstScreen({Key? key}) : super(key: key);

  @override
  State<SortingFirstScreen> createState() => _SortingFirstScreenState();
}

class _SortingFirstScreenState extends State<SortingFirstScreen> {
  String userId = '';

  int index = 0;

  bool? _isLoading;

  List<ResultList> _resultList = [];

  List<ResultList> _listLocation = [];

  Future<void> getUserId() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    userId = sp.getString('userID').toString();
    setState(() {});
  }

  Future getPurchaseOrderList(BuildContext context, index) async {
    return await API.getPurchaseOrderList(
        context, 'SORTING', 'PENDING', userId);
  }

  @override
  void initState() {
    getUserId();
    super.initState();
    getInwardList(context);
  }

  Future getInwardList(BuildContext context) async {
    final preference = await SharedPreferences.getInstance();
    setState(() {
      _isLoading = true;
    });
    return await API
        .getSTORAGEOrderList(context, 'SORTING', 'PENDING', userId)
        .then(
      (StorageModal? response) async {
        setState(() {
          _isLoading = false;
        });
        print('response Sorting-->' + response.toString());
        if (response != null) {
          response.body!.purchaseOrderList!.resultList!
              .map((e) => _resultList.add(e))
              .toList();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHelper.appBar(
          context, 'SORTING', InventoryDashboardScreen(), Icons.arrow_back_ios),
      body: Column(
        children: [
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: SortingList(resultList: _resultList))),
        ],
      ),
    );
  }
}
