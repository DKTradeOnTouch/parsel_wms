// To parse this JSON data, do
//
//     final invoiceListModel = invoiceListModelFromJson(jsonString);

import 'dart:convert';

InvoiceListModel invoiceListModelFromJson(String str) =>
    InvoiceListModel.fromJson(json.decode(str));

String invoiceListModelToJson(InvoiceListModel data) =>
    json.encode(data.toJson());

class InvoiceListModel {
  final bool status;
  final String message;
  final Body body;

  InvoiceListModel({
    required this.status,
    required this.message,
    required this.body,
  });

  InvoiceListModel copyWith({
    bool? status,
    String? message,
    Body? body,
  }) =>
      InvoiceListModel(
        status: status ?? this.status,
        message: message ?? this.message,
        body: body ?? this.body,
      );

  factory InvoiceListModel.fromJson(Map<String, dynamic> json) =>
      InvoiceListModel(
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

class ResultList {
  final int id;
  final dynamic approvedBy;
  final String assignedUser;
  final Assignments assignments;
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
  // final GroupId groupId;
  final int groupId;
  final int routesId;
  final String storeName;
  final dynamic debitTo;
  final dynamic newRoute;
  final dynamic stopNumber;
  final dynamic barCodeId;
  final dynamic polylineStr;
  final int distanceFromDepot;
  final List<ItemList> itemList;
  final Store store;
  final DeliveryAddressCoordinates deliveryAddressCoordinates;
  // final List<Route> routes;
  final String warehouse;
  final UserDetails userDetails;

  ResultList({
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
  });

  ResultList copyWith({
    int? id,
    dynamic approvedBy,
    String? assignedUser,
    Assignments? assignments,
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
    // GroupId? groupId,
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
      );

  factory ResultList.fromJson(Map<String, dynamic> json) => ResultList(
        id: json["id"],
        approvedBy: json["approved_by"],
        assignedUser: json["assigned_user"],
        assignments: Assignments.fromJson(
            json["assignments"].runtimeType == String
                ? jsonDecode(json["assignments"])
                : json["assignments"]),
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
        // groupId: GroupId.fromJson(json["group_id"]),
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
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "approved_by": approvedBy,
        "assigned_user": assignedUser,
        "assignments": assignments.toJson(),
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
        // "group_id": groupId.toJson(),
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
      };
}

class Assignments {
  final InGroup inGroup;

  Assignments({
    required this.inGroup,
  });

  Assignments copyWith({
    InGroup? inGroup,
  }) =>
      Assignments(
        inGroup: inGroup ?? this.inGroup,
      );

  factory Assignments.fromJson(Map<String, dynamic> json) => Assignments(
        inGroup: InGroup.fromJson(json["in_group"]),
      );

  Map<String, dynamic> toJson() => {
        "in_group": inGroup.toJson(),
      };
}

class InGroup {
  final String userId;
  final String timestamp;

  InGroup({
    required this.userId,
    required this.timestamp,
  });

  InGroup copyWith({
    String? userId,
    String? timestamp,
  }) =>
      InGroup(
        userId: userId ?? this.userId,
        timestamp: timestamp ?? this.timestamp,
      );

  factory InGroup.fromJson(Map<String, dynamic> json) => InGroup(
        userId: json["userId"],
        timestamp: json["timestamp"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "timestamp": timestamp,
      };
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
        lat: double.parse(json["lat"].toString()),
        long: double.parse(json["long"].toString()),
      );

  Map<String, dynamic> toJson() => {
        "lat": lat,
        "long": long,
      };
}

class GroupId {
  final int id;
  final double collectedCash;
  final double collectedChange;
  final String createdByUser;
  final DateTime createdTime;
  final dynamic debitToUserId;
  final String docs;
  final int noOfBoxes;
  final double openingBalance;
  final String optimizedRouteForso;
  final String route;
  final String status;
  final double temperature;
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
    double? collectedCash,
    double? collectedChange,
    String? createdByUser,
    DateTime? createdTime,
    dynamic debitToUserId,
    String? docs,
    int? noOfBoxes,
    double? openingBalance,
    String? optimizedRouteForso,
    String? route,
    String? status,
    double? temperature,
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
        collectedCash: double.parse(json["collected_cash"].toString()),
        collectedChange: double.parse(json["collected_change"].toString()),
        createdByUser: json["created_by_user"],
        createdTime: DateTime.parse(json["created_time"]),
        debitToUserId: json["debit_to_user_id"],
        docs: json["docs"],
        noOfBoxes: json["no_of_boxes"],
        openingBalance: double.parse(json["opening_balance"].toString()),
        optimizedRouteForso: json["optimized_route_forso"],
        route: json["route"],
        status: json["status"],
        temperature: double.parse(json["temperature"].toString()),
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
  // final DoneHistory doneHistory;
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

  ItemList({
    required this.id,
    required this.action,
    required this.aging,
    required this.batch,
    required this.createdTime,
    required this.delivered,
    // required this.doneHistory,
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
    int? id,
    String? action,
    dynamic aging,
    dynamic batch,
    DateTime? createdTime,
    int? delivered,
    // DoneHistory? doneHistory,
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
        id: id ?? this.id,
        action: action ?? this.action,
        aging: aging ?? this.aging,
        batch: batch ?? this.batch,
        createdTime: createdTime ?? this.createdTime,
        delivered: delivered ?? this.delivered,
        // doneHistory: doneHistory ?? this.doneHistory,
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
        // doneHistory: DoneHistory.fromJson(jsonDecode(json["done_history"])),
        productCode: json["product_code"],
        productName: json["product_name"],
        qty: json["qty"],
        returnInfo: json["return_info"],
        returnReason: json["return_reason"],
        returned: json["returned"],
        status: json["status"],
        totalPrice: double.parse(json["total_price"].toString()),
        unitPrice: double.parse(json["unit_price"].toString()),
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
        // "done_history": doneHistory.toJson(),
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

class DoneHistory {
  DoneHistory();

  factory DoneHistory.fromJson(Map<String, dynamic> json) => DoneHistory();

  Map<String, dynamic> toJson() => {};
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
        address: json["address"],
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
