import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:parsel_flutter/models/despatch_sum_model.dart';
import 'package:parsel_flutter/resource/app_logs.dart';
import 'package:parsel_flutter/resource/app_styles.dart';
import 'package:parsel_flutter/src/widget/widget.dart';
import 'package:parsel_flutter/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/api.dart';
import '../../models/GetuserbyID_model.dart';
import '../../resource/app_colors.dart';
import '../../resource/app_helper.dart';
import '../../resource/app_strings.dart';
import 'PendingfirstScreen.dart';
import 'PickupOrders.dart';

/*
class  PickUpPointScreen extends StatefulWidget{
  @override
  createState() {
 return  PickUpPoint_state();
  }

}


class PickUpPoint_state extends State<PickUpPointScreen>{
  int  tabSelection= 2;
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Scaffold(
        body:
      ListView.builder(itemBuilder: (BuildContext context,index){
        return Container();
      }),
        appBar: AppBar(
          bottom: PreferredSize(
            child: Container(
             child: Padding(
               padding: const EdgeInsets.all(8.0),
               child: TextFormField(decoration: InputDecoration(suffixIcon: IconButton(icon: Icon(Icons.search), onPressed: () {  },),
                 hintText: "Search",),

               ),
             ),
            ),
            preferredSize: Size.fromHeight(4.0)),
          title: Text("PickUpPoint"),
          leading: IconButton(icon: Icon(Icons.arrow_back_ios,),
            onPressed: () { Navigator.of(context).pop(true); },),)
    );
  }

}*/
class Pickuppoint extends StatefulWidget {
  final DespatchSummaryDetails despatchDetails;

  const Pickuppoint({Key? key, required this.despatchDetails})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return PickupPointState();
  }
}

class PickupPointState extends State<Pickuppoint> {
  var _isLoading = false;
  List<SelectedWarehousesDetail> _listSWHD = [];

  Future getUSERbyID(BuildContext context) async {
    final preference = await SharedPreferences.getInstance();
    setState(() {
      _isLoading = true;
    });
    return await API
        .getUserById(context,
            USERID: preference.getString('userID').toString(),
            Authtoken: preference.getString('token').toString())
        .then(
      (GetuserbyID_model? response) async {
        setState(() {
          _isLoading = false;
        });
        if (response != null) {
          response.body!.userDetails!.selectedWarehousesDetail!
              .map((e) => _listSWHD.add(e))
              .toList();
          if (_listSWHD.isNotEmpty) {
            VariableUtilities.preferences.setString(
                LocalCacheKey.pickUpPointCityList, jsonEncode(_listSWHD));
          }
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
  void initState() {
    appLogs('Pick up points');

    super.initState();
    if (ConnectivityHandler.connectivityResult
        .contains(ConnectivityResult.none)) {
      String pickUpPointCityList = VariableUtilities.preferences.getString(
            LocalCacheKey.pickUpPointCityList,
          ) ??
          '';
      if (pickUpPointCityList.isNotEmpty) {
        List<SelectedWarehousesDetail> prefsListSWHD =
            List<SelectedWarehousesDetail>.from(jsonDecode(pickUpPointCityList)
                .map((x) => SelectedWarehousesDetail.fromJson(x)));

        _listSWHD = prefsListSWHD;
      }
    } else {
      getUSERbyID(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppHelper.appBar(context, 'PICK UP POINT',
              const PendingfirstScreen(), Icons.arrow_back_ios),
          body: Column(children: [
            Container(
                height: 64,
                width: double.infinity,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 30),
                decoration: const BoxDecoration(
                  color: AppColors.whiteColor,
                  boxShadow: [
                    BoxShadow(
                      color:
                          AppColors.dashBoardCardBackground, //color of shadow
                      spreadRadius: 1, //spread radius
                      blurRadius: 1, // blur radius
                    ),
                    //you can set more BoxShadow() here
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.search,
                      color: AppColors.blueColor,
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Text('Search', style: AppStyles.pickUpPoint),
                  ],
                )),
            SizedBox(
                height: 500,
                child: _listSWHD.isNotEmpty
                    ? ListView.builder(
                        itemCount: _listSWHD.length,
                        itemBuilder: (BuildContext context, index) {
                          return Card(
                            child: SizedBox(
                              height: 93,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              const PickupOrderScreen()));
                                },
                                child: Stack(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 35.0, top: 15),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 4.0, horizontal: 0.0),
                                            child: Text(
                                              _listSWHD[index]
                                                  .wareHouseName
                                                  .toString(),
                                              style:
                                                  AppStyles.pickUpPointHeading,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(0.0),
                                            child: Text(
                                              " ${_listSWHD[index].city.toString()}",
                                              // -400067",
                                              style: AppStyles.pickUpPoint,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    const Positioned(
                                        right: 30,
                                        left: null,
                                        top: 20,
                                        child: SizedBox(
                                          child: Icon(
                                            Icons.star_border,
                                            color: Colors.grey,
                                          ),
                                          height: 24,
                                          width: 24,
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          );
                        })
                    : const Center(child: Text('No Data'))

                // child: Container(
                //   height: 93,
                //   width: double.infinity,
                //   child: InkWell(
                //     onTap: () {
                //       Navigator.push(
                //           context,
                //           MaterialPageRoute(
                //               builder: (_) => pickupOrderScreen()));
                //     },
                //     child: Stack(
                //       children: [
                //         Padding(
                //           padding: const EdgeInsets.only(left: 35.0, top: 15),
                //           child: Column(
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             children: [
                //               Padding(
                //                 padding: EdgeInsets.symmetric(
                //                     vertical: 4.0, horizontal: 0.0),
                //                 child: Text(
                //                   "Rajeev chok",
                //                   style: AppStyles.pickUpPointHeading,
                //                 ),
                //               ),
                //               Padding(
                //                 padding: EdgeInsets.all(0.0),
                //                 child: Text(
                //                   "Delhi",
                //                   style: AppStyles.pickUpPoint,
                //                 ),
                //               )
                //             ],
                //           ),
                //         ),
                //         Positioned(
                //             right: 30,
                //             left: null,
                //             top: 20,
                //             child: Container(
                //               child: Icon(
                //                 Icons.star_border,
                //                 color: Colors.grey,
                //               ),
                //               height: 24,
                //               width: 24,
                //             )),
                //       ],
                //     ),
                //   ),
                // ),

                )
          ]),
        ),
        Visibility(
            visible: _isLoading, child: CustomCircularProgressIndicator())
      ],
    );
  }
}
