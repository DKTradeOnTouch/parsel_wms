// To parse this JSON data, do
//
//     final pickingListModal = pickingListModalFromJson(jsonString);

import 'dart:convert';

PickingListModal pickingListModalFromJson(String str) =>
    PickingListModal.fromJson(json.decode(str));

String pickingListModalToJson(PickingListModal data) =>
    json.encode(data.toJson());

class PickingListModal {
  final bool status;
  final String message;
  final Body body;

  PickingListModal({
    required this.status,
    required this.message,
    required this.body,
  });

  factory PickingListModal.fromJson(Map<String, dynamic> json) =>
      PickingListModal(
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
  final int temperature;
  final dynamic updatedBy;
  final DateTime updatedOn;
  final String vehicleNumber;
  final GroupId groupId;
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
  final List<Route> routes;
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
    required this.routes,
    required this.warehouse,
    required this.userDetails,
  });

  factory ResultList.fromJson(Map<String, dynamic> json) => ResultList(
        id: json["id"],
        approvedBy: json["approved_by"],
        assignedUser: json["assigned_user"],
        assignments: Assignments.fromJson(json["assignments"]),
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
        groupId: GroupId.fromJson(json["group_id"]),
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
        routes: List<Route>.from(json["routes"].map((x) => Route.fromJson(x))),
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
        "group_id": groupId.toJson(),
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
        "routes": List<dynamic>.from(routes.map((x) => x.toJson())),
        "warehouse": warehouse,
        "user_details": userDetails.toJson(),
      };
}

class Assignments {
  final InGroup inGroup;

  Assignments({
    required this.inGroup,
  });

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
  final int lat;
  final int long;

  DeliveryAddressCoordinates({
    required this.lat,
    required this.long,
  });

  factory DeliveryAddressCoordinates.fromJson(Map<String, dynamic> json) =>
      DeliveryAddressCoordinates(
        lat: json["lat"],
        long: json["long"],
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

  ItemList({
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

  factory UserDetails.fromJson(Map<String, dynamic> json) => UserDetails(
        id: json["id"],
        username: json["username"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
      };
}
