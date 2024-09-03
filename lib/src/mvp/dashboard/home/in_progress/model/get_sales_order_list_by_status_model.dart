// import 'dart:convert';

// import 'package:flutter/material.dart';

// GetSalesOrderListByStatusModel getSalesOrderListByStatusModelFromJson(
//         String str) =>
//     GetSalesOrderListByStatusModel.fromJson(json.decode(str));

// String getSalesOrderListByStatusModelToJson(
//         GetSalesOrderListByStatusModel data) =>
//     json.encode(data.toJson());

// class GetSalesOrderListByStatusModel {
//   final int status;
//   final String message;
//   final Body body;

//   GetSalesOrderListByStatusModel({
//     required this.status,
//     required this.message,
//     required this.body,
//   });

//   GetSalesOrderListByStatusModel copyWith({
//     int? status,
//     String? message,
//     Body? body,
//   }) =>
//       GetSalesOrderListByStatusModel(
//         status: status ?? this.status,
//         message: message ?? this.message,
//         body: body ?? this.body,
//       );

//   factory GetSalesOrderListByStatusModel.fromJson(Map<String, dynamic> json) =>
//       GetSalesOrderListByStatusModel(
//         status: json["status"],
//         message: json["message"],
//         body: json["body"] == null
//             ? Body.fromJson({})
//             : Body.fromJson(json["body"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "status": status,
//         "message": message,
//         "body": body.toJson(),
//       };
// }

// class Body {
//   final Data data;

//   Body({
//     required this.data,
//   });

//   Body copyWith({
//     Data? data,
//   }) =>
//       Body(
//         data: data ?? this.data,
//       );

//   factory Body.fromJson(Map<String, dynamic> json) => Body(
//         data: Data.fromJson(json["data"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "data": data.toJson(),
//       };
// }

// class Data {
//   final List<ResultList> resultList;
//   final int totalCount;
//   final int noOfItems;
//   final int totalPages;

//   Data({
//     required this.resultList,
//     required this.totalCount,
//     required this.noOfItems,
//     required this.totalPages,
//   });

//   Data copyWith({
//     List<ResultList>? resultList,
//     int? totalCount,
//     int? noOfItems,
//     int? totalPages,
//   }) =>
//       Data(
//         resultList: resultList ?? this.resultList,
//         totalCount: totalCount ?? this.totalCount,
//         noOfItems: noOfItems ?? this.noOfItems,
//         totalPages: totalPages ?? this.totalPages,
//       );

//   factory Data.fromJson(Map<String, dynamic> json) => Data(
//         resultList: json["resultList"] == null
//             ? []
//             : List<ResultList>.from(
//                 json["resultList"].map((x) => ResultList.fromJson(x))),
//         totalCount: json["totalCount"] ?? 0,
//         noOfItems: json["noOfItems"] ?? 0,
//         totalPages: json["totalPages"] ?? 0,
//       );

//   Map<String, dynamic> toJson() => {
//         "resultList": List<dynamic>.from(resultList.map((x) => x.toJson())),
//         "totalCount": totalCount,
//         "noOfItems": noOfItems,
//         "totalPages": totalPages,
//       };
// }

// class ResultList {
//   final int id;
//   final String salesOrderId;
//   final List<ItemList> itemList;
//   final DateTime creationTime;
//   final DateTime updatedOn;
//   final dynamic createdBy;
//   final dynamic updatedBy;
//   final dynamic approvedBy;
//   final Store store;
//   final dynamic payments;
//   final String executionStatus;
//   final Routes routes;
//   final double salesOrderValue;
//   final double totalCollectedPayment;
//   final double totalReturnSkuValue;
//   final double difference;
//   final GroupId groupId;
//   final String vehicleNumber;
//   final dynamic docs;
//   final dynamic locationList;
//   final dynamic currentLocation;
//   final UserDetails userDetails;
//   final Assignments assignments;
//   final String salesOrderPaymentStatus;
//   final double temperature;
//   final String deliveryAddress;
//   final dynamic debitTo;
//   final dynamic newRoute;
//   final dynamic stopNumber;
//   final DeliveryAddressCordinates deliveryAddressCordinates;
//   final dynamic barCodeId;

//   ResultList({
//     required this.id,
//     required this.salesOrderId,
//     required this.itemList,
//     required this.creationTime,
//     required this.updatedOn,
//     required this.createdBy,
//     required this.updatedBy,
//     required this.approvedBy,
//     required this.store,
//     required this.payments,
//     required this.executionStatus,
//     required this.routes,
//     required this.salesOrderValue,
//     required this.totalCollectedPayment,
//     required this.totalReturnSkuValue,
//     required this.difference,
//     required this.groupId,
//     required this.vehicleNumber,
//     required this.docs,
//     required this.locationList,
//     required this.currentLocation,
//     required this.userDetails,
//     required this.assignments,
//     required this.salesOrderPaymentStatus,
//     required this.temperature,
//     required this.deliveryAddress,
//     required this.debitTo,
//     required this.newRoute,
//     required this.stopNumber,
//     required this.deliveryAddressCordinates,
//     required this.barCodeId,
//   });

//   ResultList copyWith(
//           {int? id,
//           String? salesOrderId,
//           List<ItemList>? itemList,
//           DateTime? creationTime,
//           DateTime? updatedOn,
//           dynamic createdBy,
//           dynamic updatedBy,
//           dynamic approvedBy,
//           Store? store,
//           dynamic payments,
//           String? executionStatus,
//           Routes? routes,
//           double? salesOrderValue,
//           double? totalCollectedPayment,
//           double? totalReturnSkuValue,
//           double? difference,
//           GroupId? groupId,
//           String? vehicleNumber,
//           dynamic docs,
//           dynamic locationList,
//           dynamic currentLocation,
//           UserDetails? userDetails,
//           Assignments? assignments,
//           String? salesOrderPaymentStatus,
//           double? temperature,
//           String? deliveryAddress,
//           dynamic debitTo,
//           dynamic newRoute,
//           dynamic stopNumber,
//           DeliveryAddressCordinates? deliveryAddressCordinates,
//           dynamic barCodeId,
//           TextEditingController? itemNameController,
//           TextEditingController? returnItemQtyController,
//           TextEditingController? totalQtyController,
//           String? selectedReturnReason}) =>
//       ResultList(
//         id: id ?? this.id,
//         salesOrderId: salesOrderId ?? this.salesOrderId,
//         itemList: itemList ?? this.itemList,
//         creationTime: creationTime ?? this.creationTime,
//         updatedOn: updatedOn ?? this.updatedOn,
//         createdBy: createdBy ?? this.createdBy,
//         updatedBy: updatedBy ?? this.updatedBy,
//         approvedBy: approvedBy ?? this.approvedBy,
//         store: store ?? this.store,
//         payments: payments ?? this.payments,
//         executionStatus: executionStatus ?? this.executionStatus,
//         routes: routes ?? this.routes,
//         salesOrderValue: salesOrderValue ?? this.salesOrderValue,
//         totalCollectedPayment:
//             totalCollectedPayment ?? this.totalCollectedPayment,
//         totalReturnSkuValue: totalReturnSkuValue ?? this.totalReturnSkuValue,
//         difference: difference ?? this.difference,
//         groupId: groupId ?? this.groupId,
//         vehicleNumber: vehicleNumber ?? this.vehicleNumber,
//         docs: docs ?? this.docs,
//         locationList: locationList ?? this.locationList,
//         currentLocation: currentLocation ?? this.currentLocation,
//         userDetails: userDetails ?? this.userDetails,
//         assignments: assignments ?? this.assignments,
//         salesOrderPaymentStatus:
//             salesOrderPaymentStatus ?? this.salesOrderPaymentStatus,
//         temperature: temperature ?? this.temperature,
//         deliveryAddress: deliveryAddress ?? this.deliveryAddress,
//         debitTo: debitTo ?? this.debitTo,
//         newRoute: newRoute ?? this.newRoute,
//         stopNumber: stopNumber ?? this.stopNumber,
//         deliveryAddressCordinates:
//             deliveryAddressCordinates ?? this.deliveryAddressCordinates,
//         barCodeId: barCodeId ?? this.barCodeId,
//       );

//   factory ResultList.fromJson(Map<String, dynamic> json) => ResultList(
//         id: json["id"],
//         salesOrderId: json["salesOrderId"],
//         itemList: List<ItemList>.from(
//             json["itemList"].map((x) => ItemList.fromJson(x))),
//         creationTime: DateTime.parse(json["creationTime"]),
//         updatedOn: DateTime.parse(json["updatedOn"]),
//         createdBy: json["createdBy"],
//         updatedBy: json["updatedBy"],
//         approvedBy: json["approvedBy"],
//         store: Store.fromJson(json["store"]),
//         payments: json["payments"],
//         executionStatus: json["executionStatus"],
//         routes: Routes.fromJson(json["routes"]),
//         salesOrderValue: json["salesOrderValue"]?.toDouble(),
//         totalCollectedPayment: json["totalCollectedPayment"],
//         totalReturnSkuValue: json["totalReturnSkuValue"],
//         difference: json["difference"]?.toDouble(),
//         groupId: GroupId.fromJson(json["groupId"]),
//         vehicleNumber: json["vehicleNumber"],
//         docs: json["docs"],
//         locationList: json["locationList"],
//         currentLocation: json["currentLocation"],
//         userDetails: UserDetails.fromJson(json["userDetails"]),
//         assignments: Assignments.fromJson(json["assignments"]),
//         salesOrderPaymentStatus: json["salesOrderPaymentStatus"],
//         temperature: json["temperature"],
//         deliveryAddress: json["deliveryAddress"],
//         debitTo: json["debitTo"],
//         newRoute: json["newRoute"],
//         stopNumber: json["stopNumber"],
//         deliveryAddressCordinates: DeliveryAddressCordinates.fromJson(
//             json["deliveryAddressCordinates"]),
//         barCodeId: json["barCodeId"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "salesOrderId": salesOrderId,
//         "itemList": List<dynamic>.from(itemList.map((x) => x.toJson())),
//         "creationTime": creationTime.toIso8601String(),
//         "updatedOn": updatedOn.toIso8601String(),
//         "createdBy": createdBy,
//         "updatedBy": updatedBy,
//         "approvedBy": approvedBy,
//         "store": store.toJson(),
//         "payments": payments,
//         "executionStatus": executionStatus,
//         "routes": routes.toJson(),
//         "salesOrderValue": salesOrderValue,
//         "totalCollectedPayment": totalCollectedPayment,
//         "totalReturnSkuValue": totalReturnSkuValue,
//         "difference": difference,
//         "groupId": groupId.toJson(),
//         "vehicleNumber": vehicleNumber,
//         "docs": docs,
//         "locationList": locationList,
//         "currentLocation": currentLocation,
//         "userDetails": userDetails.toJson(),
//         "assignments": assignments.toJson(),
//         "salesOrderPaymentStatus": salesOrderPaymentStatus,
//         "temperature": temperature,
//         "deliveryAddress": deliveryAddress,
//         "debitTo": debitTo,
//         "newRoute": newRoute,
//         "stopNumber": stopNumber,
//         "deliveryAddressCordinates": deliveryAddressCordinates.toJson(),
//         "barCodeId": barCodeId,
//       };
// }

// class Assignments {
//   final InGroup inGroup;

//   Assignments({
//     required this.inGroup,
//   });

//   Assignments copyWith({
//     InGroup? inGroup,
//   }) =>
//       Assignments(
//         inGroup: inGroup ?? this.inGroup,
//       );

//   factory Assignments.fromJson(Map<String, dynamic> json) => Assignments(
//         inGroup: InGroup.fromJson(json["in_group"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "in_group": inGroup.toJson(),
//       };
// }

// class InGroup {
//   final String userId;
//   final String timestamp;

//   InGroup({
//     required this.userId,
//     required this.timestamp,
//   });

//   InGroup copyWith({
//     String? userId,
//     String? timestamp,
//   }) =>
//       InGroup(
//         userId: userId ?? this.userId,
//         timestamp: timestamp ?? this.timestamp,
//       );

//   factory InGroup.fromJson(Map<String, dynamic> json) => InGroup(
//         userId: json["userId"],
//         timestamp: json["timestamp"],
//       );

//   Map<String, dynamic> toJson() => {
//         "userId": userId,
//         "timestamp": timestamp,
//       };
// }

// class DeliveryAddressCordinates {
//   double lat;
//   double long;

//   DeliveryAddressCordinates({
//     required this.lat,
//     required this.long,
//   });

//   DeliveryAddressCordinates copyWith({
//     double? lat,
//     double? long,
//   }) =>
//       DeliveryAddressCordinates(
//         lat: lat ?? this.lat,
//         long: long ?? this.long,
//       );

//   factory DeliveryAddressCordinates.fromJson(Map<String, dynamic> json) =>
//       DeliveryAddressCordinates(
//         lat: json["lat"]?.toDouble(),
//         long: json["long"]?.toDouble(),
//       );

//   Map<String, dynamic> toJson() => {
//         "lat": lat,
//         "long": long,
//       };
// }

// class GroupId {
//   final int id;
//   final String vehicleNo;
//   final double collectedCash;
//   final String status;
//   final double openingBalance;
//   final List<dynamic> skuDetails;
//   final dynamic debitToUserId;
//   final dynamic debitToUserDetails;
//   final dynamic createdByUserDetails;
//   final int noOfBoxes;
//   final double temperature;
//   final Docs extraInfo;
//   final Docs docs;
//   final dynamic optimizedRouteForSo;
//   final dynamic closingBalance;

//   GroupId({
//     required this.id,
//     required this.vehicleNo,
//     required this.collectedCash,
//     required this.status,
//     required this.openingBalance,
//     required this.skuDetails,
//     required this.debitToUserId,
//     required this.debitToUserDetails,
//     required this.createdByUserDetails,
//     required this.noOfBoxes,
//     required this.temperature,
//     required this.extraInfo,
//     required this.docs,
//     required this.optimizedRouteForSo,
//     required this.closingBalance,
//   });

//   GroupId copyWith({
//     int? id,
//     String? vehicleNo,
//     double? collectedCash,
//     String? status,
//     double? openingBalance,
//     List<dynamic>? skuDetails,
//     dynamic debitToUserId,
//     dynamic debitToUserDetails,
//     dynamic createdByUserDetails,
//     int? noOfBoxes,
//     double? temperature,
//     Docs? extraInfo,
//     Docs? docs,
//     dynamic optimizedRouteForSo,
//     dynamic closingBalance,
//   }) =>
//       GroupId(
//         id: id ?? this.id,
//         vehicleNo: vehicleNo ?? this.vehicleNo,
//         collectedCash: collectedCash ?? this.collectedCash,
//         status: status ?? this.status,
//         openingBalance: openingBalance ?? this.openingBalance,
//         skuDetails: skuDetails ?? this.skuDetails,
//         debitToUserId: debitToUserId ?? this.debitToUserId,
//         debitToUserDetails: debitToUserDetails ?? this.debitToUserDetails,
//         createdByUserDetails: createdByUserDetails ?? this.createdByUserDetails,
//         noOfBoxes: noOfBoxes ?? this.noOfBoxes,
//         temperature: temperature ?? this.temperature,
//         extraInfo: extraInfo ?? this.extraInfo,
//         docs: docs ?? this.docs,
//         optimizedRouteForSo: optimizedRouteForSo ?? this.optimizedRouteForSo,
//         closingBalance: closingBalance ?? this.closingBalance,
//       );

//   factory GroupId.fromJson(Map<String, dynamic> json) => GroupId(
//         id: json["id"],
//         vehicleNo: json["vehicleNo"],
//         collectedCash: json["collectedCash"],
//         status: json["status"],
//         openingBalance: json["openingBalance"],
//         skuDetails: List<dynamic>.from(json["skuDetails"].map((x) => x)),
//         debitToUserId: json["debitToUserId"],
//         debitToUserDetails: json["debitToUserDetails"],
//         createdByUserDetails: json["createdByUserDetails"],
//         noOfBoxes: json["noOfBoxes"],
//         temperature: json["temperature"],
//         extraInfo: Docs.fromJson(json["extraInfo"]),
//         docs: Docs.fromJson(json["docs"]),
//         optimizedRouteForSo: json["optimizedRouteForSO"],
//         closingBalance: json["closingBalance"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "vehicleNo": vehicleNo,
//         "collectedCash": collectedCash,
//         "status": status,
//         "openingBalance": openingBalance,
//         "skuDetails": List<dynamic>.from(skuDetails.map((x) => x)),
//         "debitToUserId": debitToUserId,
//         "debitToUserDetails": debitToUserDetails,
//         "createdByUserDetails": createdByUserDetails,
//         "noOfBoxes": noOfBoxes,
//         "temperature": temperature,
//         "extraInfo": extraInfo.toJson(),
//         "docs": docs.toJson(),
//         "optimizedRouteForSO": optimizedRouteForSo,
//         "closingBalance": closingBalance,
//       };
// }

// class Docs {
//   Docs();

//   // Docs copyWith({
//   // }) =>
//   //     Docs(
//   //     );

//   factory Docs.fromJson(Map<String, dynamic> json) => Docs();

//   Map<String, dynamic> toJson() => {};
// }

// class ItemList {
//   final int id;
//   final dynamic updatedOn;
//   final String productCode;
//   final String productName;
//   final dynamic batch;
//   final dynamic aging;
//   final double unitPrice;
//   final int qty;
//   final double totalPrice;
//   final int delivered;
//   final int returned;
//   final String status;
//   final DateTime creationTime;
//   final dynamic returnReason;
//   final String action;
//   final String returnInfo;
//   final dynamic updatedByUserDetails;
//   final dynamic boxName;
//   late TextEditingController? itemNameController;
//   late TextEditingController? returnItemQtyController;
//   late TextEditingController? totalQtyController;
//   late String selectedReturnReason;

//   ItemList({
// this.itemNameController,
// this.returnItemQtyController,
// this.totalQtyController,
// this.selectedReturnReason = 'Select Reason for Return',
//     required this.id,
//     required this.updatedOn,
//     required this.productCode,
//     required this.productName,
//     required this.batch,
//     required this.aging,
//     required this.unitPrice,
//     required this.qty,
//     required this.totalPrice,
//     required this.delivered,
//     required this.returned,
//     required this.status,
//     required this.creationTime,
//     required this.returnReason,
//     required this.action,
//     required this.returnInfo,
//     required this.updatedByUserDetails,
//     required this.boxName,
//   });

//   ItemList copyWith(
//           {int? id,
//           dynamic updatedOn,
//           String? productCode,
//           String? productName,
//           dynamic batch,
//           dynamic aging,
//           double? unitPrice,
//           int? qty,
//           double? totalPrice,
//           int? delivered,
//           int? returned,
//           String? status,
//           DateTime? creationTime,
//           dynamic returnReason,
//           String? action,
//           String? returnInfo,
//           dynamic updatedByUserDetails,
//           dynamic boxName,
//           TextEditingController? itemNameController,
//           TextEditingController? returnItemQtyController,
//           TextEditingController? totalQtyController,
//           String? selectedReturnReason}) =>
//       ItemList(
//         id: id ?? this.id,
//         updatedOn: updatedOn ?? this.updatedOn,
//         productCode: productCode ?? this.productCode,
//         productName: productName ?? this.productName,
//         batch: batch ?? this.batch,
//         aging: aging ?? this.aging,
//         unitPrice: unitPrice ?? this.unitPrice,
//         qty: qty ?? this.qty,
//         totalPrice: totalPrice ?? this.totalPrice,
//         delivered: delivered ?? this.delivered,
//         returned: returned ?? this.returned,
//         status: status ?? this.status,
//         creationTime: creationTime ?? this.creationTime,
//         returnReason: returnReason ?? this.returnReason,
//         action: action ?? this.action,
//         returnInfo: returnInfo ?? this.returnInfo,
//         updatedByUserDetails: updatedByUserDetails ?? this.updatedByUserDetails,
//         boxName: boxName ?? this.boxName,
//         itemNameController: itemNameController ?? this.itemNameController,
//         returnItemQtyController:
//             returnItemQtyController ?? this.returnItemQtyController,
//         totalQtyController: totalQtyController ?? this.totalQtyController,
//         selectedReturnReason: selectedReturnReason ?? this.selectedReturnReason,
//       );

//   factory ItemList.fromJson(Map<String, dynamic> json) => ItemList(
//         id: json["id"],
//         updatedOn: json["updatedOn"],
//         productCode: json["productCode"],
//         productName: json["productName"],
//         batch: json["batch"],
//         aging: json["aging"],
//         unitPrice: json["unitPrice"]?.toDouble(),
//         qty: json["qty"],
//         totalPrice: json["totalPrice"]?.toDouble(),
//         delivered: json["delivered"],
//         returned: json["returned"],
//         status: json["status"],
//         creationTime: DateTime.parse(json["creationTime"]),
//         returnReason: json["returnReason"],
//         action: json["action"],
//         returnInfo: json["returnInfo"],
//         updatedByUserDetails: json["updatedByUserDetails"],
//         boxName: json["boxname"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "updatedOn": updatedOn,
//         "productCode": productCode,
//         "productName": productName,
//         "batch": batch,
//         "aging": aging,
//         "unitPrice": unitPrice,
//         "qty": qty,
//         "totalPrice": totalPrice,
//         "delivered": delivered,
//         "returned": returned,
//         "status": status,
//         "creationTime": creationTime.toIso8601String(),
//         "returnReason": returnReason,
//         "action": action,
//         "returnInfo": returnInfo,
//         "updatedByUserDetails": updatedByUserDetails,
//         "boxname": boxName,
//       };
// }

// class Routes {
//   final int id;
//   final String routeName;

//   Routes({
//     required this.id,
//     required this.routeName,
//   });

//   Routes copyWith({
//     int? id,
//     String? routeName,
//   }) =>
//       Routes(
//         id: id ?? this.id,
//         routeName: routeName ?? this.routeName,
//       );

//   factory Routes.fromJson(Map<String, dynamic> json) => Routes(
//         id: json["id"],
//         routeName: json["routeName"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "routeName": routeName,
//       };
// }

// class Store {
//   final int id;
//   final String storeName;
//   final List<dynamic> addressList;
//   final String phoneNumber;

//   Store({
//     required this.id,
//     required this.storeName,
//     required this.addressList,
//     required this.phoneNumber,
//   });

//   Store copyWith({
//     int? id,
//     String? storeName,
//     List<dynamic>? addressList,
//     String? phoneNumber,
//   }) =>
//       Store(
//         id: id ?? this.id,
//         storeName: storeName ?? this.storeName,
//         addressList: addressList ?? this.addressList,
//         phoneNumber: phoneNumber ?? this.phoneNumber,
//       );

//   factory Store.fromJson(Map<String, dynamic> json) => Store(
//         id: json["id"],
//         storeName: json["storeName"],
//         addressList: List<dynamic>.from(json["addressList"].map((x) => x)),
//         phoneNumber: json["phoneNumber"] ?? '',
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "storeName": storeName,
//         "addressList": List<dynamic>.from(addressList.map((x) => x)),
//         "phoneNumber": phoneNumber,
//       };
// }

// class UserDetails {
//   final String id;
//   final String username;
//   final String email;
//   final List<Role> roles;

//   UserDetails({
//     required this.id,
//     required this.username,
//     required this.email,
//     required this.roles,
//   });

//   UserDetails copyWith({
//     String? id,
//     String? username,
//     String? email,
//     List<Role>? roles,
//   }) =>
//       UserDetails(
//         id: id ?? this.id,
//         username: username ?? this.username,
//         email: email ?? this.email,
//         roles: roles ?? this.roles,
//       );

//   factory UserDetails.fromJson(Map<String, dynamic> json) => UserDetails(
//         id: json["id"],
//         username: json["username"],
//         email: json["email"],
//         roles: List<Role>.from(json["roles"].map((x) => Role.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "username": username,
//         "email": email,
//         "roles": List<dynamic>.from(roles.map((x) => x.toJson())),
//       };
// }

// class Role {
//   final int id;
//   final String name;
//   final List<dynamic> functionList;

//   Role({
//     required this.id,
//     required this.name,
//     required this.functionList,
//   });

//   Role copyWith({
//     int? id,
//     String? name,
//     List<dynamic>? functionList,
//   }) =>
//       Role(
//         id: id ?? this.id,
//         name: name ?? this.name,
//         functionList: functionList ?? this.functionList,
//       );

//   factory Role.fromJson(Map<String, dynamic> json) => Role(
//         id: json["id"],
//         name: json["name"],
//         functionList: List<dynamic>.from(json["functionList"].map((x) => x)),
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//         "functionList": List<dynamic>.from(functionList.map((x) => x)),
//       };
// }

// To parse this JSON data, do
//
//     final getSalesOrderListByStatusModel = getSalesOrderListByStatusModelFromJson(jsonString);

// To parse this JSON data, do
//
//     final getSalesOrderListByStatusModel = getSalesOrderListByStatusModelFromJson(jsonString);
///Second Response
// import 'dart:convert';

// import 'package:flutter/material.dart';

// GetSalesOrderListByStatusModel getSalesOrderListByStatusModelFromJson(
//         String str) =>
//     GetSalesOrderListByStatusModel.fromJson(json.decode(str));

// String getSalesOrderListByStatusModelToJson(
//         GetSalesOrderListByStatusModel data) =>
//     json.encode(data.toJson());

// class GetSalesOrderListByStatusModel {
//   final bool status;
//   final String message;
//   final Body body;

//   GetSalesOrderListByStatusModel({
//     required this.status,
//     required this.message,
//     required this.body,
//   });

//   GetSalesOrderListByStatusModel copyWith({
//     bool? status,
//     String? message,
//     Body? body,
//   }) =>
//       GetSalesOrderListByStatusModel(
//         status: status ?? this.status,
//         message: message ?? this.message,
//         body: body ?? this.body,
//       );

//   factory GetSalesOrderListByStatusModel.fromJson(Map<String, dynamic> json) =>
//       GetSalesOrderListByStatusModel(
//         status: json["status"],
//         message: json["message"],
//         body: Body.fromJson(json["body"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "status": status,
//         "message": message,
//         "body": body.toJson(),
//       };
// }

// class Body {
//   final Data data;

//   Body({
//     required this.data,
//   });

//   Body copyWith({
//     Data? data,
//   }) =>
//       Body(
//         data: data ?? this.data,
//       );

//   factory Body.fromJson(Map<String, dynamic> json) => Body(
//         data: Data.fromJson(json["data"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "data": data.toJson(),
//       };
// }

// class Data {
//   final int noOfItems;
//   final List<ResultList> resultList;
//   final int totalCount;
//   final int totalPages;

//   Data({
//     required this.noOfItems,
//     required this.resultList,
//     required this.totalCount,
//     required this.totalPages,
//   });

//   Data copyWith({
//     int? noOfItems,
//     List<ResultList>? resultList,
//     int? totalCount,
//     int? totalPages,
//   }) =>
//       Data(
//         noOfItems: noOfItems ?? this.noOfItems,
//         resultList: resultList ?? this.resultList,
//         totalCount: totalCount ?? this.totalCount,
//         totalPages: totalPages ?? this.totalPages,
//       );

//   factory Data.fromJson(Map<String, dynamic> json) => Data(
//         noOfItems: json["noOfItems"],
//         resultList: List<ResultList>.from(
//             json["resultList"].map((x) => ResultList.fromJson(x))),
//         totalCount: json["totalCount"],
//         totalPages: json["totalPages"],
//       );

//   Map<String, dynamic> toJson() => {
//         "noOfItems": noOfItems,
//         "resultList": List<dynamic>.from(resultList.map((x) => x.toJson())),
//         "totalCount": totalCount,
//         "totalPages": totalPages,
//       };
// }

// class ResultList {
//   final int id;
//   final dynamic approvedBy;
//   final String assignedUser;
//   final String assignments;
//   final dynamic createdBy;
//   final DateTime createdTime;
//   final String deliveryAddress;
//   final dynamic docs;
//   final String executionStatus;
//   final String salesOrderId;
//   final double temperature;
//   final dynamic updatedBy;
//   final DateTime updatedOn;
//   final String vehicleNumber;
//   final int groupId;
//   final int routesId;
//   final String storeName;
//   final dynamic debitTo;
//   final dynamic newRoute;
//   final dynamic stopNumber;
//   final dynamic barCodeId;
//   final dynamic polylineStr;
//   final int distanceFromDepot;
//   final List<ItemList> itemList;
//   final Store store;
//   final DeliveryAddressCoordinates deliveryAddressCoordinates;
//   final List<Route> routes;
//   final String warehouse;
//   final UserDetails userDetails;

//   ResultList({
//     required this.id,
//     required this.approvedBy,
//     required this.assignedUser,
//     required this.assignments,
//     required this.createdBy,
//     required this.createdTime,
//     required this.deliveryAddress,
//     required this.docs,
//     required this.executionStatus,
//     required this.salesOrderId,
//     required this.temperature,
//     required this.updatedBy,
//     required this.updatedOn,
//     required this.vehicleNumber,
//     required this.groupId,
//     required this.routesId,
//     required this.storeName,
//     required this.debitTo,
//     required this.newRoute,
//     required this.stopNumber,
//     required this.barCodeId,
//     required this.polylineStr,
//     required this.distanceFromDepot,
//     required this.itemList,
//     required this.store,
//     required this.deliveryAddressCoordinates,
//     required this.routes,
//     required this.warehouse,
//     required this.userDetails,
//   });

//   ResultList copyWith({
//     int? id,
//     dynamic approvedBy,
//     String? assignedUser,
//     String? assignments,
//     dynamic createdBy,
//     DateTime? createdTime,
//     String? deliveryAddress,
//     dynamic docs,
//     String? executionStatus,
//     String? salesOrderId,
//     double? temperature,
//     dynamic updatedBy,
//     DateTime? updatedOn,
//     String? vehicleNumber,
//     int? groupId,
//     int? routesId,
//     String? storeName,
//     dynamic debitTo,
//     dynamic newRoute,
//     dynamic stopNumber,
//     dynamic barCodeId,
//     dynamic polylineStr,
//     int? distanceFromDepot,
//     List<ItemList>? itemList,
//     Store? store,
//     DeliveryAddressCoordinates? deliveryAddressCoordinates,
//     List<Route>? routes,
//     String? warehouse,
//     UserDetails? userDetails,
//   }) =>
//       ResultList(
//         id: id ?? this.id,
//         approvedBy: approvedBy ?? this.approvedBy,
//         assignedUser: assignedUser ?? this.assignedUser,
//         assignments: assignments ?? this.assignments,
//         createdBy: createdBy ?? this.createdBy,
//         createdTime: createdTime ?? this.createdTime,
//         deliveryAddress: deliveryAddress ?? this.deliveryAddress,
//         docs: docs ?? this.docs,
//         executionStatus: executionStatus ?? this.executionStatus,
//         salesOrderId: salesOrderId ?? this.salesOrderId,
//         temperature: temperature ?? this.temperature,
//         updatedBy: updatedBy ?? this.updatedBy,
//         updatedOn: updatedOn ?? this.updatedOn,
//         vehicleNumber: vehicleNumber ?? this.vehicleNumber,
//         groupId: groupId ?? this.groupId,
//         routesId: routesId ?? this.routesId,
//         storeName: storeName ?? this.storeName,
//         debitTo: debitTo ?? this.debitTo,
//         newRoute: newRoute ?? this.newRoute,
//         stopNumber: stopNumber ?? this.stopNumber,
//         barCodeId: barCodeId ?? this.barCodeId,
//         polylineStr: polylineStr ?? this.polylineStr,
//         distanceFromDepot: distanceFromDepot ?? this.distanceFromDepot,
//         itemList: itemList ?? this.itemList,
//         store: store ?? this.store,
//         deliveryAddressCoordinates:
//             deliveryAddressCoordinates ?? this.deliveryAddressCoordinates,
//         routes: routes ?? this.routes,
//         warehouse: warehouse ?? this.warehouse,
//         userDetails: userDetails ?? this.userDetails,
//       );

//   factory ResultList.fromJson(Map<String, dynamic> json) => ResultList(
//         id: json["id"],
//         approvedBy: json["approved_by"],
//         assignedUser: json["assigned_user"],
//         assignments: json["assignments"],
//         createdBy: json["created_by"],
//         createdTime: DateTime.parse(json["created_time"]),
//         deliveryAddress: json["delivery_address"],
//         docs: json["docs"],
//         executionStatus: json["execution_status"],
//         salesOrderId: json["sales_order_id"],
//         temperature: json["temperature"],
//         updatedBy: json["updated_by"],
//         updatedOn: DateTime.parse(json["updated_on"]),
//         vehicleNumber: json["vehicle_number"],
//         groupId: json["group_id"],
//         routesId: json["routes_id"],
//         storeName: json["store_name"],
//         debitTo: json["debit_to"],
//         newRoute: json["new_route"],
//         stopNumber: json["stop_number"],
//         barCodeId: json["bar_code_id"],
//         polylineStr: json["polyline_str"],
//         distanceFromDepot: json["distance_from_depot"],
//         itemList: List<ItemList>.from(
//             json["itemList"].map((x) => ItemList.fromJson(x))),
//         store: Store.fromJson(json["store"]),
//         deliveryAddressCoordinates: DeliveryAddressCoordinates.fromJson(
//             json["deliveryAddressCoordinates"]),
//         routes: List<Route>.from(json["routes"].map((x) => Route.fromJson(x))),
//         warehouse: json["warehouse"],
//         userDetails: UserDetails.fromJson(json["user_details"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "approved_by": approvedBy,
//         "assigned_user": assignedUser,
//         "assignments": assignments,
//         "created_by": createdBy,
//         "created_time": createdTime.toIso8601String(),
//         "delivery_address": deliveryAddress,
//         "docs": docs,
//         "execution_status": executionStatus,
//         "sales_order_id": salesOrderId,
//         "temperature": temperature,
//         "updated_by": updatedBy,
//         "updated_on": updatedOn.toIso8601String(),
//         "vehicle_number": vehicleNumber,
//         "group_id": groupId,
//         "routes_id": routesId,
//         "store_name": storeName,
//         "debit_to": debitTo,
//         "new_route": newRoute,
//         "stop_number": stopNumber,
//         "bar_code_id": barCodeId,
//         "polyline_str": polylineStr,
//         "distance_from_depot": distanceFromDepot,
//         "itemList": List<dynamic>.from(itemList.map((x) => x.toJson())),
//         "store": store.toJson(),
//         "deliveryAddressCoordinates": deliveryAddressCoordinates.toJson(),
//         "routes": List<dynamic>.from(routes.map((x) => x.toJson())),
//         "warehouse": warehouse,
//         "user_details": userDetails.toJson(),
//       };
// }

// class DeliveryAddressCoordinates {
//   double lat;
//   double long;

//   DeliveryAddressCoordinates({
//     required this.lat,
//     required this.long,
//   });

//   DeliveryAddressCoordinates copyWith({
//     double? lat,
//     double? long,
//   }) =>
//       DeliveryAddressCoordinates(
//         lat: lat ?? this.lat,
//         long: long ?? this.long,
//       );

//   factory DeliveryAddressCoordinates.fromJson(Map<String, dynamic> json) =>
//       DeliveryAddressCoordinates(
//         lat: json["lat"],
//         long: json["long"],
//       );

//   Map<String, dynamic> toJson() => {
//         "lat": lat,
//         "long": long,
//       };
// }

// class ItemList {
//   final int id;
//   final String action;
//   final dynamic aging;
//   final dynamic batch;
//   final DateTime createdTime;
//   final int delivered;
//   final String doneHistory;
//   final String productCode;
//   final String productName;
//   final int qty;
//   final String returnInfo;
//   final dynamic returnReason;
//   final int returned;
//   final String status;
//   final double totalPrice;
//   final double unitPrice;
//   final dynamic updatedByUserId;
//   final dynamic updatedOn;
//   final int salesOrder;
//   final dynamic boxname;
//   final int tsl;
//   final int escalation;
//   final int deadStock;

//   late TextEditingController? itemNameController;
//   late TextEditingController? returnItemQtyController;
//   late TextEditingController? totalQtyController;
//   late String selectedReturnReason;

//   ItemList({
//     this.itemNameController,
//     this.returnItemQtyController,
//     this.totalQtyController,
//     this.selectedReturnReason = 'Select Reason for Return',
//     required this.id,
//     required this.action,
//     required this.aging,
//     required this.batch,
//     required this.createdTime,
//     required this.delivered,
//     required this.doneHistory,
//     required this.productCode,
//     required this.productName,
//     required this.qty,
//     required this.returnInfo,
//     required this.returnReason,
//     required this.returned,
//     required this.status,
//     required this.totalPrice,
//     required this.unitPrice,
//     required this.updatedByUserId,
//     required this.updatedOn,
//     required this.salesOrder,
//     required this.boxname,
//     required this.tsl,
//     required this.escalation,
//     required this.deadStock,
//   });

//   ItemList copyWith({
//     TextEditingController? itemNameController,
//     TextEditingController? returnItemQtyController,
//     TextEditingController? totalQtyController,
//     String? selectedReturnReason,
//     int? id,
//     String? action,
//     dynamic aging,
//     dynamic batch,
//     DateTime? createdTime,
//     int? delivered,
//     String? doneHistory,
//     String? productCode,
//     String? productName,
//     int? qty,
//     String? returnInfo,
//     dynamic returnReason,
//     int? returned,
//     String? status,
//     double? totalPrice,
//     double? unitPrice,
//     dynamic updatedByUserId,
//     dynamic updatedOn,
//     int? salesOrder,
//     dynamic boxname,
//     int? tsl,
//     int? escalation,
//     int? deadStock,
//   }) =>
//       ItemList(
//         itemNameController: itemNameController ?? this.itemNameController,
//         returnItemQtyController:
//             returnItemQtyController ?? this.returnItemQtyController,
//         totalQtyController: totalQtyController ?? this.totalQtyController,
//         selectedReturnReason: selectedReturnReason ?? this.selectedReturnReason,
//         id: id ?? this.id,
//         action: action ?? this.action,
//         aging: aging ?? this.aging,
//         batch: batch ?? this.batch,
//         createdTime: createdTime ?? this.createdTime,
//         delivered: delivered ?? this.delivered,
//         doneHistory: doneHistory ?? this.doneHistory,
//         productCode: productCode ?? this.productCode,
//         productName: productName ?? this.productName,
//         qty: qty ?? this.qty,
//         returnInfo: returnInfo ?? this.returnInfo,
//         returnReason: returnReason ?? this.returnReason,
//         returned: returned ?? this.returned,
//         status: status ?? this.status,
//         totalPrice: totalPrice ?? this.totalPrice,
//         unitPrice: unitPrice ?? this.unitPrice,
//         updatedByUserId: updatedByUserId ?? this.updatedByUserId,
//         updatedOn: updatedOn ?? this.updatedOn,
//         salesOrder: salesOrder ?? this.salesOrder,
//         boxname: boxname ?? this.boxname,
//         tsl: tsl ?? this.tsl,
//         escalation: escalation ?? this.escalation,
//         deadStock: deadStock ?? this.deadStock,
//       );

//   factory ItemList.fromJson(Map<String, dynamic> json) => ItemList(
//         id: json["id"],
//         action: json["action"],
//         aging: json["aging"],
//         batch: json["batch"],
//         createdTime: DateTime.parse(json["created_time"]),
//         delivered: json["delivered"],
//         doneHistory: json["done_history"],
//         productCode: json["product_code"],
//         productName: json["product_name"],
//         qty: json["qty"],
//         returnInfo: json["return_info"],
//         returnReason: json["return_reason"],
//         returned: json["returned"],
//         status: json["status"],
//         totalPrice: json["total_price"]?.toDouble(),
//         unitPrice: json["unit_price"]?.toDouble(),
//         updatedByUserId: json["updated_by_user_id"],
//         updatedOn: json["updated_on"],
//         salesOrder: json["sales_order"],
//         boxname: json["boxname"],
//         tsl: json["tsl"],
//         escalation: json["escalation"],
//         deadStock: json["dead_stock"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "action": action,
//         "aging": aging,
//         "batch": batch,
//         "created_time": createdTime.toIso8601String(),
//         "delivered": delivered,
//         "done_history": doneHistory,
//         "product_code": productCode,
//         "product_name": productName,
//         "qty": qty,
//         "return_info": returnInfo,
//         "return_reason": returnReason,
//         "returned": returned,
//         "status": status,
//         "total_price": totalPrice,
//         "unit_price": unitPrice,
//         "updated_by_user_id": updatedByUserId,
//         "updated_on": updatedOn,
//         "sales_order": salesOrder,
//         "boxname": boxname,
//         "tsl": tsl,
//         "escalation": escalation,
//         "dead_stock": deadStock,
//       };
// }

// class Route {
//   final int id;
//   final String routeName;

//   Route({
//     required this.id,
//     required this.routeName,
//   });

//   Route copyWith({
//     int? id,
//     String? routeName,
//   }) =>
//       Route(
//         id: id ?? this.id,
//         routeName: routeName ?? this.routeName,
//       );

//   factory Route.fromJson(Map<String, dynamic> json) => Route(
//         id: json["id"],
//         routeName: json["route_name"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "route_name": routeName,
//       };
// }

// class Store {
//   final int id;
//   final int createdOn;
//   final String? phoneNumber;
//   final String storeName;
//   final int updatedOn;
//   final dynamic routes;
//   final int warehouseId;
//   final List<AddressList> addressList;

//   Store({
//     required this.id,
//     required this.createdOn,
//     required this.phoneNumber,
//     required this.storeName,
//     required this.updatedOn,
//     required this.routes,
//     required this.warehouseId,
//     required this.addressList,
//   });

//   Store copyWith({
//     int? id,
//     int? createdOn,
//     String? phoneNumber,
//     String? storeName,
//     int? updatedOn,
//     dynamic routes,
//     int? warehouseId,
//     List<AddressList>? addressList,
//   }) =>
//       Store(
//         id: id ?? this.id,
//         createdOn: createdOn ?? this.createdOn,
//         phoneNumber: phoneNumber ?? this.phoneNumber,
//         storeName: storeName ?? this.storeName,
//         updatedOn: updatedOn ?? this.updatedOn,
//         routes: routes ?? this.routes,
//         warehouseId: warehouseId ?? this.warehouseId,
//         addressList: addressList ?? this.addressList,
//       );

//   factory Store.fromJson(Map<String, dynamic> json) => Store(
//         id: json["id"],
//         createdOn: json["created_on"],
//         phoneNumber: json["phone_number"],
//         storeName: json["store_name"],
//         updatedOn: json["updated_on"],
//         routes: json["routes"],
//         warehouseId: json["warehouse_id"],
//         addressList: List<AddressList>.from(
//             json["addressList"].map((x) => AddressList.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "created_on": createdOn,
//         "phone_number": phoneNumber,
//         "store_name": storeName,
//         "updated_on": updatedOn,
//         "routes": routes,
//         "warehouse_id": warehouseId,
//         "addressList": List<dynamic>.from(addressList.map((x) => x.toJson())),
//       };
// }

// class AddressList {
//   final int id;
//   final String address;
//   final double latitude;
//   final double longitude;
//   final int store;
//   final bool isUpdated;
//   final String? driverId;

//   AddressList({
//     required this.id,
//     required this.address,
//     required this.latitude,
//     required this.longitude,
//     required this.store,
//     required this.isUpdated,
//     required this.driverId,
//   });

//   AddressList copyWith({
//     int? id,
//     String? address,
//     double? latitude,
//     double? longitude,
//     int? store,
//     bool? isUpdated,
//     String? driverId,
//   }) =>
//       AddressList(
//         id: id ?? this.id,
//         address: address ?? this.address,
//         latitude: latitude ?? this.latitude,
//         longitude: longitude ?? this.longitude,
//         store: store ?? this.store,
//         isUpdated: isUpdated ?? this.isUpdated,
//         driverId: driverId ?? this.driverId,
//       );

//   factory AddressList.fromJson(Map<String, dynamic> json) => AddressList(
//         id: json["id"],
//         address: json["address"],
//         latitude: json["latitude"]?.toDouble(),
//         longitude: json["longitude"]?.toDouble(),
//         store: json["store"],
//         isUpdated: json["is_updated"],
//         driverId: json["driver_id"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "address": address,
//         "latitude": latitude,
//         "longitude": longitude,
//         "store": store,
//         "is_updated": isUpdated,
//         "driver_id": driverId,
//       };
// }

// class UserDetails {
//   final String id;
//   final String username;

//   UserDetails({
//     required this.id,
//     required this.username,
//   });

//   UserDetails copyWith({
//     String? id,
//     String? username,
//   }) =>
//       UserDetails(
//         id: id ?? this.id,
//         username: username ?? this.username,
//       );

//   factory UserDetails.fromJson(Map<String, dynamic> json) => UserDetails(
//         id: json["id"],
//         username: json["username"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "username": username,
//       };
// }

// To parse this JSON data, do
//
//     final getSalesOrderListByStatusModel = getSalesOrderListByStatusModelFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/payment/model/create_payment_mode_model.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/payment/model/payment_model.dart';

GetSalesOrderListByStatusModel getSalesOrderListByStatusModelFromJson(
        String str) =>
    GetSalesOrderListByStatusModel.fromJson(json.decode(str));

String getSalesOrderListByStatusModelToJson(
        GetSalesOrderListByStatusModel data) =>
    json.encode(data.toJson());

class GetSalesOrderListByStatusModel {
  final bool status;
  final String message;
  final Body body;

  GetSalesOrderListByStatusModel({
    required this.status,
    required this.message,
    required this.body,
  });

  GetSalesOrderListByStatusModel copyWith({
    bool? status,
    String? message,
    Body? body,
  }) =>
      GetSalesOrderListByStatusModel(
        status: status ?? this.status,
        message: message ?? this.message,
        body: body ?? this.body,
      );

  factory GetSalesOrderListByStatusModel.fromJson(Map<String, dynamic> json) =>
      GetSalesOrderListByStatusModel(
        status: json["status"],
        message: json["message"],
        body: Body.fromJson(json["body"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "body": body.toJson(),
      };
}

class Body {
  final Data data;

  Body({
    required this.data,
  });

  Body copyWith({
    Data? data,
  }) =>
      Body(
        data: data ?? this.data,
      );

  factory Body.fromJson(Map<String, dynamic> json) => Body(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class Data {
  final int noOfItems;
  final List<ResultList> resultList;
  final int totalCount;
  final int totalPages;

  Data({
    required this.noOfItems,
    required this.resultList,
    required this.totalCount,
    required this.totalPages,
  });

  Data copyWith({
    int? noOfItems,
    List<ResultList>? resultList,
    int? totalCount,
    int? totalPages,
  }) =>
      Data(
        noOfItems: noOfItems ?? this.noOfItems,
        resultList: resultList ?? this.resultList,
        totalCount: totalCount ?? this.totalCount,
        totalPages: totalPages ?? this.totalPages,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        noOfItems: json["noOfItems"],
        resultList: List<ResultList>.from(
            json["resultList"].map((x) => ResultList.fromJson(x))),
        totalCount: json["totalCount"],
        totalPages: json["totalPages"],
      );

  Map<String, dynamic> toJson() => {
        "noOfItems": noOfItems,
        "resultList": List<dynamic>.from(resultList.map((x) => x.toJson())),
        "totalCount": totalCount,
        "totalPages": totalPages,
      };
}

class BarcodeScan {
  final String barcodeValue;
  final BarcodeFormat formate;

  BarcodeScan({this.barcodeValue = '', this.formate = BarcodeFormat.upcE});
}

class ResultList {
  final int id;
  final dynamic approvedBy;
  final String assignedUser;
  final String assignments;
  final dynamic createdBy;
  final DateTime createdTime;
  final String deliveryAddress;
  final dynamic docs;
  final String executionStatus;
  final String salesOrderId;
  final double temperature;
  final dynamic updatedBy;
  final DateTime updatedOn;
  final String vehicleNumber;
  final int groupId;
  final int routesId;
  final String storeName;
  final dynamic debitTo;
  final dynamic newRoute;
  final dynamic stopNumber;
  final dynamic barCodeId;
  final dynamic polylineStr;
  final int distanceFromDepot;
  List<ItemList> itemList;
  final Store store;
  final DeliveryAddressCoordinates deliveryAddressCoordinates;
  // final List<Route> routes;
  final String warehouse;
  final UserDetails userDetails;
  List<int> invoiceList;
  List<ResultList> subResultList;
  String invoiceValue;
  String deliveredCount;
  String returnCount;
  String noOfBoxesCount;
  String skuTemperature;
  String totalQty;
  String remarks;

  String takePhotoFilePath;
  String signatureFilePath;
  String signatureName;
  String uploadDocFilePath;
  String scannedDocFilePath;
  List<ItemList> returnItemsList;

  GlobalKey? widgetsGlobalKey;
  List<PaymentModel> currentPaymentModeList;
  List<CreatePaymentsList> sendPaymentToAdminList;

  ///Payment screen variables
  TextEditingController? codController;
  TextEditingController? codRemarksController;

  TextEditingController? cashGivenController;
  TextEditingController? changeGivenController;

  TextEditingController? creditController;
  TextEditingController? creditRemarksController;

  TextEditingController? chequeController;
  TextEditingController? chequeRemarksController;

  TextEditingController? onlineController;
  TextEditingController? onlineRemarksController;

  ResultList(
      {this.codController,
      this.codRemarksController,
      this.cashGivenController,
      this.changeGivenController,
      this.creditController,
      this.creditRemarksController,
      this.chequeController,
      this.chequeRemarksController,
      this.onlineController,
      this.onlineRemarksController,
      this.invoiceValue = '',
      this.deliveredCount = '',
      this.returnCount = '',
      this.totalQty = '',
      this.noOfBoxesCount = '',
      this.skuTemperature = '',
      this.takePhotoFilePath = '',
      this.signatureFilePath = '',
      this.signatureName = '',
      this.uploadDocFilePath = '',
      this.scannedDocFilePath = '',
      this.remarks = '',
      required this.id,
      required this.approvedBy,
      required this.assignedUser,
      required this.assignments,
      required this.createdBy,
      required this.createdTime,
      required this.deliveryAddress,
      required this.docs,
      required this.executionStatus,
      required this.salesOrderId,
      required this.temperature,
      required this.updatedBy,
      required this.updatedOn,
      required this.vehicleNumber,
      required this.groupId,
      required this.routesId,
      required this.storeName,
      required this.debitTo,
      required this.newRoute,
      required this.stopNumber,
      required this.barCodeId,
      required this.polylineStr,
      required this.distanceFromDepot,
      required this.itemList,
      required this.store,
      required this.deliveryAddressCoordinates,
      // required this.routes,
      required this.warehouse,
      required this.userDetails,
      this.invoiceList = const [],
      this.subResultList = const [],
      this.returnItemsList = const [],
      this.currentPaymentModeList = const [],
      this.sendPaymentToAdminList = const [],
      this.widgetsGlobalKey});

  ResultList copyWith({
    int? id,
    dynamic approvedBy,
    String? assignedUser,
    String? assignments,
    dynamic createdBy,
    DateTime? createdTime,
    String? deliveryAddress,
    dynamic docs,
    String? executionStatus,
    String? salesOrderId,
    double? temperature,
    dynamic updatedBy,
    DateTime? updatedOn,
    String? vehicleNumber,
    int? groupId,
    int? routesId,
    String? storeName,
    dynamic debitTo,
    dynamic newRoute,
    dynamic stopNumber,
    dynamic barCodeId,
    dynamic polylineStr,
    int? distanceFromDepot,
    List<ItemList>? itemList,
    Store? store,
    DeliveryAddressCoordinates? deliveryAddressCoordinates,
    List<Route>? routes,
    String? warehouse,
    UserDetails? userDetails,
    List<int>? invoiceList,
    List<ResultList>? resultList,
    List<ItemList>? returnItemsList,
  }) =>
      ResultList(
        id: id ?? this.id,
        approvedBy: approvedBy ?? this.approvedBy,
        assignedUser: assignedUser ?? this.assignedUser,
        assignments: assignments ?? this.assignments,
        createdBy: createdBy ?? this.createdBy,
        createdTime: createdTime ?? this.createdTime,
        deliveryAddress: deliveryAddress ?? this.deliveryAddress,
        docs: docs ?? this.docs,
        executionStatus: executionStatus ?? this.executionStatus,
        salesOrderId: salesOrderId ?? this.salesOrderId,
        temperature: temperature ?? this.temperature,
        updatedBy: updatedBy ?? this.updatedBy,
        updatedOn: updatedOn ?? this.updatedOn,
        vehicleNumber: vehicleNumber ?? this.vehicleNumber,
        groupId: groupId ?? this.groupId,
        routesId: routesId ?? this.routesId,
        storeName: storeName ?? this.storeName,
        debitTo: debitTo ?? this.debitTo,
        newRoute: newRoute ?? this.newRoute,
        stopNumber: stopNumber ?? this.stopNumber,
        barCodeId: barCodeId ?? this.barCodeId,
        polylineStr: polylineStr ?? this.polylineStr,
        distanceFromDepot: distanceFromDepot ?? this.distanceFromDepot,
        itemList: itemList ?? this.itemList,
        store: store ?? this.store,
        deliveryAddressCoordinates:
            deliveryAddressCoordinates ?? this.deliveryAddressCoordinates,
        // routes: routes ?? this.routes,
        warehouse: warehouse ?? this.warehouse,
        userDetails: userDetails ?? this.userDetails,
        invoiceList: invoiceList ?? this.invoiceList,
        subResultList: subResultList,
        returnItemsList: returnItemsList ?? this.returnItemsList,
      );

  factory ResultList.fromJson(Map<String, dynamic> json) {
    return ResultList(
      id: json["id"],
      approvedBy: json["approved_by"],
      assignedUser: json["assigned_user"],
      assignments: json["assignments"],
      createdBy: json["created_by"],
      createdTime: DateTime.parse(json["created_time"]),
      deliveryAddress: json["delivery_address"],
      docs: json["docs"],
      executionStatus: json["execution_status"],
      salesOrderId: json["sales_order_id"],
      temperature: json["temperature"],
      updatedBy: json["updated_by"],
      updatedOn: DateTime.parse(json["updated_on"]),
      vehicleNumber: json["vehicle_number"],
      groupId: json["group_id"],
      routesId: json["routes_id"],
      storeName: json["store_name"],
      debitTo: json["debit_to"],
      newRoute: json["new_route"],
      stopNumber: json["stop_number"],
      barCodeId: json["bar_code_id"],
      polylineStr: json["polyline_str"],
      distanceFromDepot: json["distance_from_depot"],
      itemList: List<ItemList>.from(
          json["itemList"].map((x) => ItemList.fromJson(x))),
      store: Store.fromJson(json["store"]),
      deliveryAddressCoordinates: DeliveryAddressCoordinates.fromJson(
          json["deliveryAddressCoordinates"]),
      // routes: List<Route>.from(json["routes"].map((x) => Route.fromJson(x))),
      warehouse: json["warehouse"],
      userDetails: UserDetails.fromJson(json["user_details"]),
      invoiceList: json.containsKey('invoice_list')
          ? json['invoice_list'].isEmpty
              ? []
              : List<int>.from(json["invoice_list"].map((x) => x))
          : [],
      subResultList: json.containsKey('result_list')
          ? json['result_list'].isEmpty
              ? []
              : List<ResultList>.from(
                  json["result_list"].map((x) => ResultList.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    print(invoiceList);
    print(subResultList);
    return {
      "id": id,
      "approved_by": approvedBy,
      "assigned_user": assignedUser,
      "assignments": assignments,
      "created_by": createdBy,
      "created_time": createdTime.toIso8601String(),
      "delivery_address": deliveryAddress,
      "docs": docs,
      "execution_status": executionStatus,
      "sales_order_id": salesOrderId,
      "temperature": temperature,
      "updated_by": updatedBy,
      "updated_on": updatedOn.toIso8601String(),
      "vehicle_number": vehicleNumber,
      "group_id": groupId,
      "routes_id": routesId,
      "store_name": storeName,
      "debit_to": debitTo,
      "new_route": newRoute,
      "stop_number": stopNumber,
      "bar_code_id": barCodeId,
      "polyline_str": polylineStr,
      "distance_from_depot": distanceFromDepot,
      "itemList": List<dynamic>.from(itemList.map((x) => x.toJson())),
      "store": store.toJson(),
      "deliveryAddressCoordinates": deliveryAddressCoordinates.toJson(),
      // "routes": List<dynamic>.from(routes.map((x) => x.toJson())),
      "warehouse": warehouse,
      "user_details": userDetails.toJson(),
      "invoice_list": invoiceList.isEmpty
          ? []
          : List<dynamic>.from(invoiceList.map((x) => x)),
      "result_list": subResultList.isEmpty
          ? []
          : List<dynamic>.from(subResultList.map((x) => x.toJson())),
    };
  }
}

class DeliveryAddressCoordinates {
  double lat;
  double long;

  DeliveryAddressCoordinates({
    required this.lat,
    required this.long,
  });

  DeliveryAddressCoordinates copyWith({
    double? lat,
    double? long,
  }) =>
      DeliveryAddressCoordinates(
        lat: lat ?? this.lat,
        long: long ?? this.long,
      );

  factory DeliveryAddressCoordinates.fromJson(Map<String, dynamic> json) =>
      DeliveryAddressCoordinates(
        lat: json["lat"].runtimeType == int
            ? double.parse("${json["lat"]}")
            : json["lat"],
        long: json["lat"].runtimeType == int
            ? double.parse("${json["long"]}")
            : json["long"],
      );

  Map<String, dynamic> toJson() => {
        "lat": lat,
        "long": long,
      };
}

class GroupId {
  final int id;
  final int collectedCash;
  final int collectedChange;
  final String createdByUser;
  final DateTime createdTime;
  final dynamic debitToUserId;
  final String docs;
  final int noOfBoxes;
  final int openingBalance;
  final String optimizedRouteForso;
  final String route;
  final String status;
  final int temperature;
  final DateTime updatedOn;
  final String userId;
  final String vehicleNo;
  final dynamic closingBalance;

  GroupId({
    required this.id,
    required this.collectedCash,
    required this.collectedChange,
    required this.createdByUser,
    required this.createdTime,
    required this.debitToUserId,
    required this.docs,
    required this.noOfBoxes,
    required this.openingBalance,
    required this.optimizedRouteForso,
    required this.route,
    required this.status,
    required this.temperature,
    required this.updatedOn,
    required this.userId,
    required this.vehicleNo,
    required this.closingBalance,
  });

  GroupId copyWith({
    int? id,
    int? collectedCash,
    int? collectedChange,
    String? createdByUser,
    DateTime? createdTime,
    dynamic debitToUserId,
    String? docs,
    int? noOfBoxes,
    int? openingBalance,
    String? optimizedRouteForso,
    String? route,
    String? status,
    int? temperature,
    DateTime? updatedOn,
    String? userId,
    String? vehicleNo,
    dynamic closingBalance,
  }) =>
      GroupId(
        id: id ?? this.id,
        collectedCash: collectedCash ?? this.collectedCash,
        collectedChange: collectedChange ?? this.collectedChange,
        createdByUser: createdByUser ?? this.createdByUser,
        createdTime: createdTime ?? this.createdTime,
        debitToUserId: debitToUserId ?? this.debitToUserId,
        docs: docs ?? this.docs,
        noOfBoxes: noOfBoxes ?? this.noOfBoxes,
        openingBalance: openingBalance ?? this.openingBalance,
        optimizedRouteForso: optimizedRouteForso ?? this.optimizedRouteForso,
        route: route ?? this.route,
        status: status ?? this.status,
        temperature: temperature ?? this.temperature,
        updatedOn: updatedOn ?? this.updatedOn,
        userId: userId ?? this.userId,
        vehicleNo: vehicleNo ?? this.vehicleNo,
        closingBalance: closingBalance ?? this.closingBalance,
      );

  factory GroupId.fromJson(Map<String, dynamic> json) => GroupId(
        id: json["id"],
        collectedCash: json["collected_cash"],
        collectedChange: json["collected_change"],
        createdByUser: json["created_by_user"],
        createdTime: DateTime.parse(json["created_time"]),
        debitToUserId: json["debit_to_user_id"],
        docs: json["docs"],
        noOfBoxes: json["no_of_boxes"],
        openingBalance: json["opening_balance"],
        optimizedRouteForso: json["optimized_route_forso"],
        route: json["route"],
        status: json["status"],
        temperature: json["temperature"],
        updatedOn: DateTime.parse(json["updated_on"]),
        userId: json["user_id"],
        vehicleNo: json["vehicle_no"],
        closingBalance: json["closing_balance"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "collected_cash": collectedCash,
        "collected_change": collectedChange,
        "created_by_user": createdByUser,
        "created_time": createdTime.toIso8601String(),
        "debit_to_user_id": debitToUserId,
        "docs": docs,
        "no_of_boxes": noOfBoxes,
        "opening_balance": openingBalance,
        "optimized_route_forso": optimizedRouteForso,
        "route": route,
        "status": status,
        "temperature": temperature,
        "updated_on": updatedOn.toIso8601String(),
        "user_id": userId,
        "vehicle_no": vehicleNo,
        "closing_balance": closingBalance,
      };
}

class ItemList {
  final int id;
  final String action;
  final dynamic aging;
  final dynamic batch;
  final DateTime createdTime;
  final int delivered;
  final String doneHistory;
  final String productCode;
  final String productName;
  final int qty;
  final String returnInfo;
  final dynamic returnReason;
  final int returned;
  final String status;
  final double totalPrice;
  final double unitPrice;
  final dynamic updatedByUserId;
  final dynamic updatedOn;
  final int salesOrder;
  final dynamic boxname;
  final int tsl;
  final int escalation;
  final int deadStock;

  late TextEditingController? itemNameController;
  late TextEditingController? returnItemQtyController;
  late TextEditingController? totalQtyController;
  late String selectedReturnReason;

  ItemList({
    this.itemNameController,
    this.returnItemQtyController,
    this.totalQtyController,
    this.selectedReturnReason = 'Select Reason for Return',
    required this.id,
    required this.action,
    required this.aging,
    required this.batch,
    required this.createdTime,
    required this.delivered,
    required this.doneHistory,
    required this.productCode,
    required this.productName,
    required this.qty,
    required this.returnInfo,
    required this.returnReason,
    required this.returned,
    required this.status,
    required this.totalPrice,
    required this.unitPrice,
    required this.updatedByUserId,
    required this.updatedOn,
    required this.salesOrder,
    required this.boxname,
    required this.tsl,
    required this.escalation,
    required this.deadStock,
  });

  ItemList copyWith({
    TextEditingController? itemNameController,
    TextEditingController? returnItemQtyController,
    TextEditingController? totalQtyController,
    String? selectedReturnReason,
    int? id,
    String? action,
    dynamic aging,
    dynamic batch,
    DateTime? createdTime,
    int? delivered,
    String? doneHistory,
    String? productCode,
    String? productName,
    int? qty,
    String? returnInfo,
    dynamic returnReason,
    int? returned,
    String? status,
    double? totalPrice,
    double? unitPrice,
    dynamic updatedByUserId,
    dynamic updatedOn,
    int? salesOrder,
    dynamic boxname,
    int? tsl,
    int? escalation,
    int? deadStock,
  }) =>
      ItemList(
        itemNameController: itemNameController ?? this.itemNameController,
        returnItemQtyController:
            returnItemQtyController ?? this.returnItemQtyController,
        totalQtyController: totalQtyController ?? this.totalQtyController,
        selectedReturnReason: selectedReturnReason ?? this.selectedReturnReason,
        id: id ?? this.id,
        action: action ?? this.action,
        aging: aging ?? this.aging,
        batch: batch ?? this.batch,
        createdTime: createdTime ?? this.createdTime,
        delivered: delivered ?? this.delivered,
        doneHistory: doneHistory ?? this.doneHistory,
        productCode: productCode ?? this.productCode,
        productName: productName ?? this.productName,
        qty: qty ?? this.qty,
        returnInfo: returnInfo ?? this.returnInfo,
        returnReason: returnReason ?? this.returnReason,
        returned: returned ?? this.returned,
        status: status ?? this.status,
        totalPrice: totalPrice ?? this.totalPrice,
        unitPrice: unitPrice ?? this.unitPrice,
        updatedByUserId: updatedByUserId ?? this.updatedByUserId,
        updatedOn: updatedOn ?? this.updatedOn,
        salesOrder: salesOrder ?? this.salesOrder,
        boxname: boxname ?? this.boxname,
        tsl: tsl ?? this.tsl,
        escalation: escalation ?? this.escalation,
        deadStock: deadStock ?? this.deadStock,
      );

  factory ItemList.fromJson(Map<String, dynamic> json) => ItemList(
        id: json["id"],
        action: json["action"],
        aging: json["aging"],
        batch: json["batch"],
        createdTime: DateTime.parse(json["created_time"]),
        delivered: json["delivered"],
        doneHistory: json["done_history"],
        productCode: json["product_code"],
        productName: json["product_name"],
        qty: json["qty"],
        returnInfo: json["return_info"],
        returnReason: json["return_reason"],
        returned: json["returned"],
        status: json["status"],
        totalPrice: json["total_price"]?.toDouble(),
        unitPrice: json["unit_price"]?.toDouble(),
        updatedByUserId: json["updated_by_user_id"],
        updatedOn: json["updated_on"],
        salesOrder: json["sales_order"],
        boxname: json["boxname"],
        tsl: json["tsl"],
        escalation: json["escalation"],
        deadStock: json["dead_stock"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "action": action,
        "aging": aging,
        "batch": batch,
        "created_time": createdTime.toIso8601String(),
        "delivered": delivered,
        "done_history": doneHistory,
        "product_code": productCode,
        "product_name": productName,
        "qty": qty,
        "return_info": returnInfo,
        "return_reason": returnReason,
        "returned": returned,
        "status": status,
        "total_price": totalPrice,
        "unit_price": unitPrice,
        "updated_by_user_id": updatedByUserId,
        "updated_on": updatedOn,
        "sales_order": salesOrder,
        "boxname": boxname,
        "tsl": tsl,
        "escalation": escalation,
        "dead_stock": deadStock,
      };
}

class Route {
  final int id;
  final String routeName;

  Route({
    required this.id,
    required this.routeName,
  });

  Route copyWith({
    int? id,
    String? routeName,
  }) =>
      Route(
        id: id ?? this.id,
        routeName: routeName ?? this.routeName,
      );

  factory Route.fromJson(Map<String, dynamic> json) => Route(
        id: json["id"],
        routeName: json["route_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "route_name": routeName,
      };
}

class Store {
  final int id;
  final int createdOn;
  final String? phoneNumber;
  final String storeName;
  final int updatedOn;
  final dynamic routes;
  final int warehouseId;
  final List<AddressList> addressList;

  Store({
    required this.id,
    required this.createdOn,
    required this.phoneNumber,
    required this.storeName,
    required this.updatedOn,
    required this.routes,
    required this.warehouseId,
    required this.addressList,
  });

  Store copyWith({
    int? id,
    int? createdOn,
    String? phoneNumber,
    String? storeName,
    int? updatedOn,
    dynamic routes,
    int? warehouseId,
    List<AddressList>? addressList,
  }) =>
      Store(
        id: id ?? this.id,
        createdOn: createdOn ?? this.createdOn,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        storeName: storeName ?? this.storeName,
        updatedOn: updatedOn ?? this.updatedOn,
        routes: routes ?? this.routes,
        warehouseId: warehouseId ?? this.warehouseId,
        addressList: addressList ?? this.addressList,
      );

  factory Store.fromJson(Map<String, dynamic> json) => Store(
        id: json["id"],
        createdOn: json["created_on"],
        phoneNumber: json["phone_number"],
        storeName: json["store_name"],
        updatedOn: json["updated_on"],
        routes: json["routes"],
        warehouseId: json["warehouse_id"],
        addressList: List<AddressList>.from(
            json["addressList"].map((x) => AddressList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created_on": createdOn,
        "phone_number": phoneNumber,
        "store_name": storeName,
        "updated_on": updatedOn,
        "routes": routes,
        "warehouse_id": warehouseId,
        "addressList": List<dynamic>.from(addressList.map((x) => x.toJson())),
      };
}

class AddressList {
  final int id;
  final String address;
  final double latitude;
  final double longitude;
  final int store;
  final bool isUpdated;
  final String? driverId;

  AddressList({
    required this.id,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.store,
    required this.isUpdated,
    required this.driverId,
  });

  AddressList copyWith({
    int? id,
    String? address,
    double? latitude,
    double? longitude,
    int? store,
    bool? isUpdated,
    String? driverId,
  }) =>
      AddressList(
        id: id ?? this.id,
        address: address ?? this.address,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        store: store ?? this.store,
        isUpdated: isUpdated ?? this.isUpdated,
        driverId: driverId ?? this.driverId,
      );

  factory AddressList.fromJson(Map<String, dynamic> json) => AddressList(
        id: json["id"],
        address: json["address"] ?? '',
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        store: json["store"],
        isUpdated: json["is_updated"],
        driverId: json["driver_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "address": address,
        "latitude": latitude,
        "longitude": longitude,
        "store": store,
        "is_updated": isUpdated,
        "driver_id": driverId,
      };
}

class UserDetails {
  final String id;
  final String username;

  UserDetails({
    required this.id,
    required this.username,
  });

  UserDetails copyWith({
    String? id,
    String? username,
  }) =>
      UserDetails(
        id: id ?? this.id,
        username: username ?? this.username,
      );

  factory UserDetails.fromJson(Map<String, dynamic> json) => UserDetails(
        id: json["id"],
        username: json["username"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
      };
}
