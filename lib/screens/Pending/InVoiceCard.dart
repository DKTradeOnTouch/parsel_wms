// import 'package:flutter/material.dart';
// import 'package:parsel_flutter/models/InvoiceList_model.dart';
// import 'package:parsel_flutter/models/sku_classification_model.dart';
// import 'package:parsel_flutter/resource/app_colors.dart';
// import 'package:parsel_flutter/resource/app_fonts.dart';
// import 'package:parsel_flutter/resource/app_strings.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../Utils/colors.dart';
// import '../../api/api.dart';
// import '../../models/SKU_model.dart';
// import '../../models/countPending_model.dart';
// import '../../resource/app_helper.dart';
// import '../dashboard.dart';

// class InVoice extends StatefulWidget {
//   InVoice({
//     Key? key,
//   }) : super(key: key);

//   @override
//   State<InVoice> createState() => _InVoiceState();
// }

// class _InVoiceState extends State<InVoice> {
//   final List<ResultList> _listInvoice = [];
//   bool _isLoading = false;
//   @override
//   Future getSalesOrderListByStatus(BuildContext context) async {
//     final preference = await SharedPreferences.getInstance();
//     setState(() {
//       _isLoading = true;
//     });
//     return await API
//         .getSalesOrderListByStatus(
//       context,
//       showNoInternet: true,
//       Authtoken: preference.getString("token").toString(),
//       DEIVERID: preference.getString("userID").toString(),
//       STATUS: 'DRIVER_ASSIGNED',
//       TODAYDATE: '2022-08-09',
//       //DateFormat('yyyy-MM-dd').format((DateTime.now()))
//     )
//         .then(
//       (SKU_Model? response) async {
//         setState(() {
//           _isLoading = false;
//         });
//         print('rsponse-->' + response.toString());
//         if (response != null) {
//           response.body!.data!.resultList!
//               .map((e) => _listInvoice.add(e))
//               .toList();
//         } else {
//           AppHelper.showSnackBar(context, AppStrings.strSomethingWentWrong);
//         }
//       },
//     ).onError((error, stackTrace) {
//       setState(() {
//         _isLoading = false;
//       });
//     });
//   }

//   Widget build(BuildContext context) {
//     return _listInvoice.isNotEmpty
//         ? ListView.builder(
//             itemCount: _listInvoice.length,
//             itemBuilder: (BuildContext context, index) {
//               return Stack(
//                 clipBehavior: Clip.antiAlias,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 20, vertical: 10),
//                     child: Card(
//                       elevation: 4,
//                       shadowColor: Colors.black.withOpacity(0.2),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(6),
//                       ),
//                       child: Column(
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 vertical: 2.0, horizontal: 8.0),
//                             child: Row(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 const Expanded(
//                                   flex: 2,
//                                   child: Padding(
//                                     padding: EdgeInsets.all(8.0),
//                                     child: Text(
//                                       'CUSTOMER ID',
//                                       style: TextStyle(
//                                           fontFamily: appFontFamily,
//                                           fontWeight: FontWeight.w500,
//                                           color: AppColors.blueColor),
//                                     ),
//                                   ),
//                                 ),
//                                 Expanded(
//                                   flex: 3,
//                                   child: Text(_listInvoice[index].id.toString(),
//                                       style: TextStyle(
//                                           fontFamily: appFontFamily,
//                                           fontWeight: FontWeight.w500,
//                                           color: AppColors.black2Color
//                                               .withOpacity(0.6))),
//                                 )
//                               ],
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 vertical: 2.0, horizontal: 8.0),
//                             child: Row(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 const Expanded(
//                                   flex: 2,
//                                   child: Padding(
//                                     padding: EdgeInsets.all(8.0),
//                                     child: Text(
//                                       'CUSTOMER NAME',
//                                       style: TextStyle(
//                                           fontFamily: appFontFamily,
//                                           fontWeight: FontWeight.w500,
//                                           color: AppColors.blueColor),
//                                     ),
//                                   ),
//                                 ),
//                                 Expanded(
//                                   flex: 3,
//                                   child: Text(
//                                       _listInvoice[index]
//                                           .store!
//                                           .storeName
//                                           .toString(),
//                                       style: TextStyle(
//                                           fontFamily: appFontFamily,
//                                           fontWeight: FontWeight.w500,
//                                           color: AppColors.black2Color
//                                               .withOpacity(0.6))),
//                                 )
//                               ],
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 vertical: 2.0, horizontal: 8.0),
//                             child: Row(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               children: [
//                                 const Expanded(
//                                   flex: 2,
//                                   child: Padding(
//                                     padding: EdgeInsets.all(8.0),
//                                     child: Text(
//                                       'ADDRESS',
//                                       style: TextStyle(
//                                           fontFamily: appFontFamily,
//                                           fontWeight: FontWeight.w500,
//                                           color: AppColors.blueColor),
//                                     ),
//                                   ),
//                                 ),
//                                 Expanded(
//                                   flex: 3,
//                                   child: Column(
//                                     children: [
//                                       Text(
//                                           _listInvoice[index]
//                                               .store!
//                                               .storeAddress
//                                               .toString(),
//                                           style: TextStyle(
//                                               fontFamily: appFontFamily,
//                                               fontWeight: FontWeight.w500,
//                                               color: AppColors.black2Color
//                                                   .withOpacity(0.6))),
//                                     ],
//                                   ),
//                                 )
//                               ],
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 vertical: 2.0, horizontal: 8.0),
//                             child: Row(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 const Expanded(
//                                   flex: 2,
//                                   child: Padding(
//                                     padding: EdgeInsets.all(8.0),
//                                     child: Text(
//                                       'INVOICE NO.',
//                                       style: TextStyle(
//                                           fontFamily: appFontFamily,
//                                           fontWeight: FontWeight.w500,
//                                           color: AppColors.blueColor),
//                                     ),
//                                   ),
//                                 ),
//                                 Expanded(
//                                   flex: 3,
//                                   child: Text(
//                                       _listInvoice[index]
//                                           .salesOrderId
//                                           .toString(),
//                                       style: TextStyle(
//                                           fontFamily: appFontFamily,
//                                           fontWeight: FontWeight.w500,
//                                           color: AppColors.black2Color
//                                               .withOpacity(0.6))),
//                                 )
//                               ],
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                       right: 35,
//                       left: null,
//                       top: 22,
//                       child: Container(
//                         child: const Icon(
//                           Icons.phone,
//                           size: 30,
//                           color: Colors.white,
//                         ),
//                         decoration: new BoxDecoration(
//                           shape: BoxShape
//                               .circle, // You can use like this way or like the below line
//                           //borderRadius: new BorderRadius.circular(30.0),
//                           color: blueColor,
//                         ),
//                         height: 40,
//                         width: 40,
//                       )),
//                 ],
//               );
//             })
//         : Center(child: CircularProgressIndicator());
//   }
// }
