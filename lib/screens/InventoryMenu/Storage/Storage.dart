import 'package:flutter/material.dart';
import 'package:parsel_flutter/api/api.dart';
import 'package:parsel_flutter/models/storage_list_data_model.dart';
import 'package:parsel_flutter/resource/app_helper.dart';
import 'package:parsel_flutter/screens/InventoryMenu/InventoryDashboard.dart';
import 'package:parsel_flutter/screens/InventoryMenu/Storage/storage_list_new.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageScreen extends StatefulWidget {
  const StorageScreen({Key? key}) : super(key: key);

  @override
  State<StorageScreen> createState() => _StorageScreenState();
}

class _StorageScreenState extends State<StorageScreen> {
  String? userId = '';
  List<StorageData> storageList = [];
  bool isStartApiCall = false;
  Future getPurchaseOrderList(BuildContext context) async {
    // await getUserId();
    SharedPreferences sp = await SharedPreferences.getInstance();
    userId = sp.getString('userID');
    setState(() {
      isStartApiCall = true;
    });
    try {
      StorageListData? storageListData = await API.fetchStorageListData(
          context, 'STORAGE', 'PENDING', userId!);
      if (storageListData != null) {
        storageList = storageListData.storageData;
      }
      isStartApiCall = false;
      setState(() {});
    } catch (e) {
      storageList = [];
      isStartApiCall = false;
      setState(() {});
    }
    isStartApiCall = false;
    setState(() {});
  }

  Future<void> getUserId() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    userId = sp.getString('userID');

    setState(() {});
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await getPurchaseOrderList(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppHelper.appBar(context, 'STORAGE', InventoryDashboardScreen(),
            Icons.arrow_back_ios),
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: storageList.isNotEmpty
                      ? ListView.builder(
                          itemCount: storageList.length,
                          itemBuilder: (context, index) {
                            return StorageListNew(
                              itemList: storageList[index],
                            );
                          },
                        )
                      : isStartApiCall
                          ? const SizedBox()
                          : const Center(child: Text('No Data')),
                )),

                // Expanded(
                //   child: Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: FutureBuilder(
                //         future: getPurchaseOrderList(context),
                //         builder: (ctx, asyncSnapshot) {
                //           if (asyncSnapshot.connectionState ==
                //               ConnectionState.done) {
                //             if (asyncSnapshot.data != null) {
                //               StorageListData storageListData =
                //                   asyncSnapshot.data as StorageListData;
                //               return storageListData.storageData.isNotEmpty
                //                   ? ListView.builder(
                //                       itemCount: storageListData.storageData.length,
                //                       itemBuilder: (context, index) {
                //                         return StorageList(
                //                           itemList:
                //                               storageListData.storageData[index],
                //                         );
                //                       },
                //                     )
                //                   : const Center(child: Text('No Data'));
                //             } else {
                //               return const Center(child: Text('No Data'));
                //             }
                //           } else if (asyncSnapshot.connectionState ==
                //               ConnectionState.waiting) {
                //             return const Center(
                //               child: CircularProgressIndicator.adaptive(),
                //             );
                //           } else {
                //             return Container();
                //           }
                //         }),
                //   ),
                // ),
              ],
            ),
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
