import 'package:flutter/material.dart';
import 'package:parsel_flutter/models/PickingList.dart';
import 'package:parsel_flutter/models/picking_list_data_model.dart';
import 'package:parsel_flutter/resource/app_strings.dart';
import 'package:parsel_flutter/resource/app_styles.dart';
import 'package:parsel_flutter/screens/InventoryMenu/PickingList/picking_list_new.dart';
import 'package:parsel_flutter/screens/InventoryMenu/Storage/storage_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../api/api.dart';
import '../../../resource/app_helper.dart';
import 'pickingList_details.dart';

class PickingListScreen extends StatefulWidget {
  const PickingListScreen({Key? key}) : super(key: key);

  @override
  State<PickingListScreen> createState() => _PickingListScreenState();
}

class _PickingListScreenState extends State<PickingListScreen> {
  @override
  bool _isLoading = false;

  List<ResultList> _resultList = [];

  Data? data;

  List<ItemList> _itemList = [];

  List<PickingData> pickingList = [];
  bool isStartApiCall = false;
  Future fetchPickingListData(BuildContext context) async {
    // await getUserId();
    SharedPreferences sp = await SharedPreferences.getInstance();
    String userId = sp.getString('userID') ?? '';
    setState(() {
      isStartApiCall = true;
    });
    try {
      PickingListDataModel? storageListData =
          await API.fetchPickingListData(context, 'STORAGE', 'PENDING', userId);
      if (storageListData != null) {
        pickingList = storageListData.pickingData;
      }
      isStartApiCall = false;
      setState(() {});
    } catch (e) {
      pickingList = [];
      isStartApiCall = false;
      setState(() {});
    }
    isStartApiCall = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await fetchPickingListData(context);
    });
    // getPickingList1(context);
  }

  Future getPickingList1(BuildContext context) async {
    final preference = await SharedPreferences.getInstance();
    String userID = preference.getString('userID').toString();
    setState(() {
      _isLoading = true;
    });
    return await API
        .getPICKINGList(context, 'PENDING', 'PICKING', userID,
            Authtoken: preference.getString('token').toString())
        .then(
      (PickingListModal? response) async {
        setState(() {
          _isLoading = false;
        });
        print('response-->' + response.toString());
        if (response != null) {
          data = response.body.data;
          data!.resultList.map((e) => _resultList.add(e)).toList();
          data!.resultList[index].itemList
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(AppStrings.strPickingList,
              style: AppStyles.appBarTitleStyle),
          leading: GestureDetector(
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: SizedBox(
                height: 15,
                width: 15,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
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
        body: Stack(
          children: [
            Column(children: [
              Expanded(
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: pickingList.isNotEmpty
                          ? PickingListNew(pickingList: pickingList)
                          : isStartApiCall
                              ? const SizedBox()
                              : const Center(child: Text('No Data'))))
            ]),
            Visibility(
              visible: isStartApiCall,
              child: const Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            )
          ],
        ));
  }
}
