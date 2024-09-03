import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:parsel_flutter/api/api.dart';
import 'package:parsel_flutter/resource/app_colors.dart';
import 'package:parsel_flutter/resource/app_strings.dart';
import 'package:parsel_flutter/resource/app_styles.dart';
import 'package:parsel_flutter/screens/InventoryMenu/Inward/inward_list_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/InwardList_model.dart' as In;
import '../../../models/locationDropdown_model.dart';
import '../../../resource/app_helper.dart';

class InwardListPage extends StatefulWidget {
  @override
  State<InwardListPage> createState() => _InwardListPageState();
}

class _InwardListPageState extends State<InwardListPage> {
  String userId = '';

  int? index = 0;

  bool? _isLoading;

  List<In.ResultList> _resultList = [];

  String? barcodeId;

  List<ResultList> _listLocation = [];

  Future<void> getUserId() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    userId = sp.getString('userID').toString();
    setState(() {});
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
    return await API.getInwardList(context, 'INWARD', 'PENDING', userId).then(
      (In.InwardListModal? response) async {
        setState(() {
          _isLoading = false;
        });
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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('INWARD', style: AppStyles.appBarTitleStyle),
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
                child: InwardListItem(resultList: _resultList)),
          ),
        ],
      ),
    );
  }
}
