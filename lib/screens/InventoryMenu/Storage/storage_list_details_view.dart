import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:parsel_flutter/api/api.dart';
import 'package:parsel_flutter/models/ExecuteStorage_model.dart';
import 'package:parsel_flutter/models/storage_list_data_model.dart';
import 'package:parsel_flutter/resource/app_colors.dart';
import 'package:parsel_flutter/resource/app_helper.dart';
import 'package:parsel_flutter/resource/app_styles.dart';
import 'package:parsel_flutter/screens/InventoryMenu/InventoryDashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageListDetailsView extends StatefulWidget {
  const StorageListDetailsView({Key? key, required this.storageData})
      : super(key: key);
  final StorageData storageData;

  @override
  State<StorageListDetailsView> createState() => _StorageListDetailsViewState();
}

class _StorageListDetailsViewState extends State<StorageListDetailsView> {
  bool _isLoading = false;
  Future performAction(BuildContext context, String poId, String productCode,
      String binID) async {
    setState(() {
      _isLoading = true;
    });
    return await API.executeStorage(context, poId, productCode, binID).then(
      (ExecuteStorageModal? response) async {
        setState(() {
          _isLoading = false;
        });
        print('response_Execute_Storage-->' + response.toString());
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
      backgroundColor: AppColors.whiteColor,
      appBar: AppHelper.appBar(
          context, 'STORAGE', InventoryDashboardScreen(), Icons.arrow_back_ios),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 13),
          child: SingleChildScrollView(
            child: Column(
              children: [
                intrinsicHeight(
                    subTitle: widget.storageData.skus, title: 'Sku Name'),
                const SizedBox(height: 10),
                Center(child: Text('From', style: AppStyles.storageBlackBold)),
                const SizedBox(height: 10),
                intrinsicHeight(
                    subTitle: widget.storageData.fromZone, title: 'Zone'),
                intrinsicHeight(
                    subTitle: widget.storageData.fromRow, title: 'Row'),
                intrinsicHeight(
                    subTitle: widget.storageData.fromRack, title: 'Rack'),
                const SizedBox(height: 10),
                Center(child: Text('TO', style: AppStyles.storageBlackBold)),
                const SizedBox(height: 10),
                intrinsicHeight(
                    subTitle: widget.storageData.toZone, title: 'Zone'),
                intrinsicHeight(
                    subTitle: widget.storageData.fromRow, title: 'Row'),
                intrinsicHeight(
                    subTitle: widget.storageData.fromRack, title: 'Rack'),
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
                .submitStorageData(context, widget.storageData.poId, userId)
                .then((value) async {
              _isLoading = false;
              setState(() {});
              if (value != null && value.status) {
                Fluttertoast.showToast(msg: value.message);
                _isLoading = true;
                setState(() {});
                await API
                    .updateWorkerApi(context, type: 'putaway', userId: userId)
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
