// import 'package:flutter/material.dart';
// import 'package:hexcolor/hexcolor.dart';
// import 'package:parsel_flutter/resource/app_colors.dart';
// import 'package:parsel_flutter/resource/app_styles.dart';

// import '../../models/InvoiceList_model.dart';
// import '../../models/SKU_model.dart';

// class SKU extends StatelessWidget {
//   SKU({Key? key, required this.resultList}) : super(key: key);
//   final InvoiceResultList? resultList;
//   @override

//   Widget build(BuildContext context) {
//     return Padding(
//             padding:
//                 const EdgeInsets.symmetric(horizontal: 18.0, vertical: 0.0),
//             child: Container(
//               height: 100,
//               child: Card(
//                 child: Padding(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 14.0, vertical: 4),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Column(
//                           children: [
//                             Text(
//                              '',
//                               style: TextStyle(
//                                   fontSize: 13, fontWeight: FontWeight.w400),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(
//                             vertical: 0.0, horizontal: 8.0),
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Expanded(
//                               flex: 2,
//                               child: Padding(
//                                 padding: const EdgeInsets.all(4.0),
//                                 child: Text(
//                                   "COST",
//                                   style: TextStyle(
//                                       fontSize: 10,
//                                       color: HexColor('#99202020'),
//                                       fontWeight: FontWeight.w700),
//                                 ),
//                               ),
//                             ),
//                             Expanded(
//                               flex: 3,
//                               child: Text(
//                                 "QTY",
//                                 style: TextStyle(
//                                     fontSize: 10,
//                                     color: HexColor('#99202020'),
//                                     fontWeight: FontWeight.w700),
//                               ),
//                             )
//                           ],
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(
//                             vertical: 0.0, horizontal: 8.0),
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Expanded(
//                               flex: 2,
//                               child: Padding(
//                                 padding: const EdgeInsets.all(4.0),
//                                 child: Text(
//                                   ''
//                                   // "₹ ${itemList[index].unitPrice.toString()}",
//                                ,   style: TextStyle(
//                                       color: Colors.grey, fontSize: 12),
//                                 ),
//                               ),
//                             ),
//                             Expanded(
//                               flex: 3,
//                               child: Text(''
//                                 // itemList[index].qty.toString(),
//                              ,   style:
//                                     TextStyle(fontSize: 12, color: Colors.grey),
//                               ),
//                             )
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           );
        
//   }
// }
