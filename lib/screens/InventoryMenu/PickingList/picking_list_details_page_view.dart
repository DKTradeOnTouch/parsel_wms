import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:parsel_flutter/models/PickingList.dart' as pl;
import 'package:parsel_flutter/models/picking_list_data_model.dart';
import 'package:parsel_flutter/resource/app_colors.dart';
import 'package:parsel_flutter/resource/app_strings.dart';
import 'package:parsel_flutter/resource/app_styles.dart';
import 'package:parsel_flutter/screens/InventoryMenu/InventoryDashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../api/api.dart';
import '../../../models/performActionPICKPACK_modal.dart';
import '../../../resource/app_helper.dart';

class PickingListDetailPageNew extends StatefulWidget {
  final PickingData pickingData;

  const PickingListDetailPageNew({Key? key, required this.pickingData})
      : super(key: key);

  @override
  State<PickingListDetailPageNew> createState() =>
      _PickingListDetailPageNewState();
}

class _PickingListDetailPageNewState extends State<PickingListDetailPageNew> {
  List<pl.ItemList>? itemList;
  String _scanBarcode = '';

  int? index1 = 0;

  bool _isLoading = false;

  String? userId = '';

  Future<void> getUserId() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    userId = sp.getString('userID');
    setState(() {});
  }

  // Future getPickingList(BuildContext context) async {
  //   return await API.getSTORAGEOrderList(
  //       context, 'STORAGE', 'PENDING', userId!);
  // }

  Future getPackingList(BuildContext context) async {
    final preference = await SharedPreferences.getInstance();
    return await API.getPICKINGList(context, 'PENDING', 'PACKING', userId!,
        Authtoken: preference.getString("token").toString());
  }

  Future performActionPickPack(
      BuildContext context, String salesOrderId, String status) async {
    final preference = await SharedPreferences.getInstance();
    setState(() {
      _isLoading = true;
    });
    return await API
        .performActionOnPICKPACK(context, salesOrderId, '', status,
            Authtoken: preference.getString("token").toString())
        .then(
      (PickPackPerformActionModal? response) async {
        setState(() {
          _isLoading = false;
        });
        print('PERFORM_PP_response-->' + response.toString());
        if (response!.message != null) {
          AppHelper.showSnackBar(context, response.message.toString());
        } else {
          AppHelper.showSnackBar(context, response.message.toString());
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
        title:
            Text(AppStrings.strPickingList, style: AppStyles.appBarTitleStyle),
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
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 13),
          child: SingleChildScrollView(
            child: Column(
              children: [
                intrinsicHeight(
                    subTitle: widget.pickingData.skus, title: 'Sku Name'),
                const SizedBox(height: 10),
                Center(child: Text('From', style: AppStyles.storageBlackBold)),
                const SizedBox(height: 10),
                intrinsicHeight(
                    subTitle: widget.pickingData.fromZone, title: 'Zone'),
                intrinsicHeight(
                    subTitle: widget.pickingData.fromRow, title: 'Row'),
                intrinsicHeight(
                    subTitle: widget.pickingData.fromRack, title: 'Rack'),
                const SizedBox(height: 10),
                Center(child: Text('TO', style: AppStyles.storageBlackBold)),
                const SizedBox(height: 10),
                Container(
                  height: 150,
                  padding: const EdgeInsets.only(right: 10),
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(left: 20, top: 10, bottom: 5),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, spreadRadius: 1)
                      ]),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Center(
                      child: Text(
                        'Pick Cart',
                        // widget.itemList!.itemList![index1].skuDetails!
                        // .name
                        // .toString(),
                        style: TextStyle(
                            color: AppColors.inwardDATAText,
                            letterSpacing: 0.1,
                            fontFamily: 'MavenPro',
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: InkWell(
        onTap: () async {
          // performAction(
          //   context,
          //   widget.itemList!.poId.toString(),
          //   widget.itemList!.itemList![index1].productCode.toString(),
          //   _listLocation[binIdIndex as int].id.toString(),
          // );
          // Navigator.push(context,
          //     MaterialPageRoute(builder: (_) => InventoryDashboardScreen()));
          SharedPreferences sp = await SharedPreferences.getInstance();
          String userId = sp.getString('userID') ?? '';
          if (userId.isNotEmpty) {
            _isLoading = true;
            setState(() {});
            await API
                .submitPickingListData(context, widget.pickingData.soId, userId)
                .then((value) async {
              _isLoading = false;
              setState(() {});
              if (value != null && value.status) {
                Fluttertoast.showToast(msg: value.message);
                _isLoading = true;
                setState(() {});
                await API
                    .updateWorkerApi(context, type: 'pick', userId: userId)
                    .then((res) {
                  _isLoading = false;
                  setState(() {});

                  if (res != null && res == 'success') {
                    Fluttertoast.showToast(
                        msg: 'Worker data updated successfully');
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => InventoryDashboardScreen()));
                  } else {
                    Fluttertoast.showToast(msg: 'Failed to update worker Data');
                  }
                });
              } else {
                Fluttertoast.showToast(msg: 'Failed to update Data');
              }
            });
            _isLoading = false;
            setState(() {});
          }
        },
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4), topRight: Radius.circular(4)),
            color: AppColors.blueColor,
          ),
          alignment: Alignment.center,
          height: 70,
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.white))
              : Text(
                  'SUBMIT',
                  style: AppStyles.submitButtonStyle,
                ),
        ),
      ),
    );
  }

  Widget intrinsicHeight({required String title, required String subTitle}) {
    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AppStyles.inward14TextBLUEStyle,
              ),
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    height: 40,
                    child: const VerticalDivider(
                      thickness: 2,
                    ),
                  ),
                  Container(
                    height: 40,
                    padding: const EdgeInsets.only(right: 10),
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.only(left: 20, top: 10, bottom: 5),
                    width: MediaQuery.of(context).size.width * 0.45,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: const [
                          BoxShadow(color: Colors.black12, spreadRadius: 1)
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        subTitle,
                        // widget.itemList!.itemList![index1].skuDetails!
                        // .name
                        // .toString(),
                        style: AppStyles.inwardTextDATAStyle,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
      ],
    );
  }
}
