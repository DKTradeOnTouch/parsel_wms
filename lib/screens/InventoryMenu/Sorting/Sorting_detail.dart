// import 'package:flutter/material.dart';
// import 'package:parsel_flutter/models/sku_classification_model.dart';
// import 'package:parsel_flutter/screens/InventoryMenu/Sorting/sortingFirstScreen.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../../../api/api.dart';
// import '../../../models/purchase_order_list_model.dart';
// import '../../../resource/app_colors.dart';
// import '../../../resource/app_helper.dart';
// import '../../../resource/app_strings.dart';
// import '../../../resource/app_styles.dart';

// class SortingDetailScreen extends StatefulWidget {
//   const SortingDetailScreen({Key? key}) : super(key: key);

//   @override
//   State<SortingDetailScreen> createState() => _SortingDetailScreenState();
// }

// class _SortingDetailScreenState extends State<SortingDetailScreen> {
//   List<String> sortingList = [
//     'DELHI',
//     'SALE',
//     'SAMPLE',
//     'TESTER',
//   ];
//   bool _isLoading = false;

//   String userId = '';

//   int count =0;

//   @override
//   void initState() {
//     super.initState();
//     getPurchaseOrderList(context);
//   }

//   Future getPurchaseOrderList(BuildContext context) async {
//     final preference = await SharedPreferences.getInstance();
//     setState(() {
//       _isLoading = true;
//     });
//     return await API
//         .getPurchaseOrderList(context, 'SORTING', 'PENDING', userId)
//         .then(
//       (PurchaseOrderModel? response) async {
//         setState(() {
//           _isLoading = false;
//         });
//         if (response != null) {
//           count = response.body!.purchaseOrderList!.totalCount!;
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

//   // Future skuClassification(BuildContext context) async {
//   //   final preference = await SharedPreferences.getInstance();
//   //   setState(() {
//   //     _isLoading = true;
//   //   });
//   //   return API.getSkuClassificationList(
//   //       context, widget.poId, widget.productCode, 'FINISHED')
//   //       .then(
//   //     (SkuClassificationModel? response) async {
//   //       setState(() {
//   //         _isLoading = false;
//   //       });
//   //       if (response != null) {
//   //       } else {
//   //         AppHelper.showSnackBar(context, AppStrings.strSomethingWentWrong);
//   //       }
//   //     },
//   //   ).onError((error, stackTrace) {
//   //     setState(() {
//   //       _isLoading = false;
//   //     });
//   //   });
//   // }



//   saleBarcodeTextfield() {
//     return Container(
//       height: 40,
//       padding: EdgeInsets.only(right: 10, left: 14),
//       alignment: Alignment.centerLeft,
//       margin: EdgeInsets.only(left: 20, top: 10, bottom: 5),
//       width: MediaQuery.of(context).size.width * 0.50,
//       decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(8),
//           boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 1)]),
//       child: Text(
//         '00',
//         style: AppStyles.inwardTextDATAStyle,
//       ),
//     );
//   }

//   quantityBatchTextField(index) {
//     return Container(
//       height: 40,
//       padding: EdgeInsets.only(right: 10),
//       alignment: Alignment.centerRight,
//       margin: EdgeInsets.only(left: 20, top: 10, bottom: 5),
//       width: MediaQuery.of(context).size.width * 0.50,
//       decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(8),
//           boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 1)]),
//       child: TextField(
//         textAlign: TextAlign.end,
//         keyboardType: TextInputType.number,
//         decoration: InputDecoration(
//             border: InputBorder.none,
//             hintText: sortingList[index] == 'Batch' ? 'Enter Batch' : '00'),
//       ),
//     );
//   }

//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.whiteColor,
//       appBar: AppHelper.appbar(
//           context, 'SORTING', SortingFirstScreen(), Icons.arrow_back_ios),
//       body: SafeArea(
//           child: SingleChildScrollView(
//         child: Column(
//           children: [
//             Container(
//               margin: EdgeInsets.symmetric(horizontal: 23, vertical: 13),
//               height: MediaQuery.of(context).size.height * 0.82,
//               width: double.infinity,
//               child: Column(
//                 children: [
//                   Row(
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                         width: 130,
//                         child: Text(
//                           'SKU COUNT',
//                           style: AppStyles.sortingTextStyle,
//                         ),
//                       ),
//                       Text(
//                         count.toString(),
//                         style: AppStyles.inwardTextSKUOrders,
//                       )
//                     ],
//                   ),
//                   IntrinsicHeight(
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                           child: Text(
//                             sortingList[0],
//                             style: AppStyles.inwardTextBLUEStyle,
//                           ),
//                         ),
//                         Row(
//                           children: [
//                             Container(
//                               margin: EdgeInsets.only(top: 10),
//                               height: 40,
//                               child: VerticalDivider(
//                                 thickness: 2,
//                               ),
//                             ),
//                             saleBarcodeTextfield()
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   IntrinsicHeight(
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                           child: Text(
//                             sortingList[1],
//                             style: AppStyles.inwardTextBLUEStyle,
//                           ),
//                         ),
//                         Row(
//                           children: [
//                             Container(
//                               margin: EdgeInsets.only(top: 10),
//                               height: 40,
//                               child: VerticalDivider(
//                                 thickness: 2,
//                               ),
//                             ),
//                             saleBarcodeTextfield()
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   IntrinsicHeight(
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                           child: Text(
//                             sortingList[2],
//                             style: AppStyles.inwardTextBLUEStyle,
//                           ),
//                         ),
//                         Row(
//                           children: [
//                             Container(
//                               margin: EdgeInsets.only(top: 10),
//                               height: 40,
//                               child: VerticalDivider(
//                                 thickness: 2,
//                               ),
//                             ),
//                             saleBarcodeTextfield()
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   IntrinsicHeight(
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                           child: Text(
//                             sortingList[3],
//                             style: AppStyles.inwardTextBLUEStyle,
//                           ),
//                         ),
//                         Row(
//                           children: [
//                             Container(
//                               margin: EdgeInsets.only(top: 10),
//                               height: 40,
//                               child: VerticalDivider(
//                                 thickness: 2,
//                               ),
//                             ),
//                             saleBarcodeTextfield()
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       )),
//       bottomNavigationBar: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(8), topRight: Radius.circular(8)),
//           color: AppColors.blueColor,
//         ),
//         alignment: Alignment.center,
//         height: 60,
//         child: Text(
//           'SUBMIT',
//           style: AppStyles.submitButtonStyle,
//         ),
//       ),
//     );
//   }
// }
