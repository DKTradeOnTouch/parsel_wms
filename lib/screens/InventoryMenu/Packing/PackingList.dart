import 'package:flutter/material.dart';
import 'package:parsel_flutter/models/packing_list_model.dart';
import 'package:parsel_flutter/resource/app_strings.dart';
import 'package:parsel_flutter/resource/app_styles.dart';
import 'package:parsel_flutter/screens/InventoryMenu/Storage/storage_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../api/api.dart';
import '../../../resource/app_helper.dart';
import 'packing_list_item.dart';

class PackingListScreen extends StatefulWidget {
  const PackingListScreen({Key? key}) : super(key: key);

  @override
  State<PackingListScreen> createState() => _PackingListScreenState();
}

class _PackingListScreenState extends State<PackingListScreen> {
  @override
  bool _isLoading = false;

  List<ResultList> _resultList = [];

  Data? data;

  List<ItemList> _itemList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((time) {
      getPickingList1(context);
    });
  }

  Future getPickingList1(BuildContext context) async {
    final preference = await SharedPreferences.getInstance();
    String userID = preference.getString('userID').toString();
    setState(() {
      _isLoading = true;
    });
    return await API
        .getPACKINGList(context, 'PACKING', 'ON_GOING', userID,
            Authtoken: preference.getString('token').toString())
        .then(
      (PackingListModel? response) async {
        setState(() {
          _isLoading = false;
        });
        print('response-->' + response.toString());
        if (response != null) {
          data = response.body!.data!;
          data!.resultList!.map((e) => _resultList.add(e)).toList();
          data!.resultList![index].itemList!
              .map((e) => _itemList.add(e))
              .toList();
          print('itemList length-->' + _itemList.length.toString());
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

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(AppStrings.strPackingList,
              style: AppStyles.appBarTitleStyle),
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
        body: Column(children: [
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _resultList.isNotEmpty
                      ? PackingList(
                          data: data!,
                          resultList: _resultList,
                          itemList: _itemList)
                      : Center(child: Text('No Data'))))
        ]));
  }
}
