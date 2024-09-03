// To parse this JSON data, do
//
//     final packingListModel = packingListModelFromJson(jsonString);

import 'dart:convert';

PackingListModel packingListModelFromJson(String str) =>
    PackingListModel.fromJson(json.decode(str));

String packingListModelToJson(PackingListModel data) =>
    json.encode(data.toJson());

class PackingListModel {
  final bool status;
  final String message;
  final Body body;

  PackingListModel({
    required this.status,
    required this.message,
    required this.body,
  });

  PackingListModel copyWith({
    bool? status,
    String? message,
    Body? body,
  }) =>
      PackingListModel(
        status: status ?? this.status,
        message: message ?? this.message,
        body: body ?? this.body,
      );

  factory PackingListModel.fromJson(Map<String, dynamic> json) =>
      PackingListModel(
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
  final List<ItemList> itemList;
  final Store store;
  final DeliveryAddressCoordinates deliveryAddressCoordinates;
  final Routes routes;
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
    Routes? routes,
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
        routes: routes ?? this.routes,
        warehouse: warehouse ?? this.warehouse,
        userDetails: userDetails ?? this.userDetails,
      );

  factory ResultList.fromJson(Map<String, dynamic> json) => ResultList(
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
        temperature: double.parse(json["temperature"].toString()),
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
        routes: Routes.fromJson(json["routes"]),
        warehouse: json["warehouse"],
        userDetails: UserDetails.fromJson(json["user_details"]),
      );

  Map<String, dynamic> toJson() => {
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
        "itemList": List<dynamic>.from(itemList.map((x) => x)),
        "store": store.toJson(),
        "deliveryAddressCoordinates": deliveryAddressCoordinates.toJson(),
        "routes": routes.toJson(),
        "warehouse": warehouse,
        "user_details": userDetails.toJson(),
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

class DeliveryAddressCoordinates {
  final int lat;
  final int long;

  DeliveryAddressCoordinates({
    required this.lat,
    required this.long,
  });

  DeliveryAddressCoordinates copyWith({
    int? lat,
    int? long,
  }) =>
      DeliveryAddressCoordinates(
        lat: lat ?? this.lat,
        long: long ?? this.long,
      );

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

class Routes {
  final int id;
  final dynamic createdBy;
  final int createdTime;
  final String routeName;
  final int updatedOn;

  Routes({
    required this.id,
    required this.createdBy,
    required this.createdTime,
    required this.routeName,
    required this.updatedOn,
  });

  Routes copyWith({
    int? id,
    dynamic createdBy,
    int? createdTime,
    String? routeName,
    int? updatedOn,
  }) =>
      Routes(
        id: id ?? this.id,
        createdBy: createdBy ?? this.createdBy,
        createdTime: createdTime ?? this.createdTime,
        routeName: routeName ?? this.routeName,
        updatedOn: updatedOn ?? this.updatedOn,
      );

  factory Routes.fromJson(Map<String, dynamic> json) => Routes(
        id: json["id"],
        createdBy: json["created_by"],
        createdTime: json["created_time"],
        routeName: json["route_name"],
        updatedOn: json["updated_on"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created_by": createdBy,
        "created_time": createdTime,
        "route_name": routeName,
        "updated_on": updatedOn,
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
  final dynamic address;
  final dynamic city;
  final dynamic countryCode;
  final dynamic createdOn;
  final dynamic description;
  final dynamic deviceType;
  final String domain;
  final String email;
  final bool isBlocked;
  final dynamic landmark;
  final dynamic locality;
  final String masters;
  final String password;
  final int phoneNumber;
  final dynamic pinNumber;
  final String selectedWarehouses;
  final dynamic state;
  final dynamic updatedOn;
  final dynamic userType;
  final String username;
  final dynamic vehicleNumber;
  final String workStatus;
  final String attendenceStatus;

  UserDetails({
    required this.id,
    required this.address,
    required this.city,
    required this.countryCode,
    required this.createdOn,
    required this.description,
    required this.deviceType,
    required this.domain,
    required this.email,
    required this.isBlocked,
    required this.landmark,
    required this.locality,
    required this.masters,
    required this.password,
    required this.phoneNumber,
    required this.pinNumber,
    required this.selectedWarehouses,
    required this.state,
    required this.updatedOn,
    required this.userType,
    required this.username,
    required this.vehicleNumber,
    required this.workStatus,
    required this.attendenceStatus,
  });

  UserDetails copyWith({
    String? id,
    dynamic address,
    dynamic city,
    dynamic countryCode,
    dynamic createdOn,
    dynamic description,
    dynamic deviceType,
    String? domain,
    String? email,
    bool? isBlocked,
    dynamic landmark,
    dynamic locality,
    String? masters,
    String? password,
    int? phoneNumber,
    dynamic pinNumber,
    String? selectedWarehouses,
    dynamic state,
    dynamic updatedOn,
    dynamic userType,
    String? username,
    dynamic vehicleNumber,
    String? workStatus,
    String? attendenceStatus,
  }) =>
      UserDetails(
        id: id ?? this.id,
        address: address ?? this.address,
        city: city ?? this.city,
        countryCode: countryCode ?? this.countryCode,
        createdOn: createdOn ?? this.createdOn,
        description: description ?? this.description,
        deviceType: deviceType ?? this.deviceType,
        domain: domain ?? this.domain,
        email: email ?? this.email,
        isBlocked: isBlocked ?? this.isBlocked,
        landmark: landmark ?? this.landmark,
        locality: locality ?? this.locality,
        masters: masters ?? this.masters,
        password: password ?? this.password,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        pinNumber: pinNumber ?? this.pinNumber,
        selectedWarehouses: selectedWarehouses ?? this.selectedWarehouses,
        state: state ?? this.state,
        updatedOn: updatedOn ?? this.updatedOn,
        userType: userType ?? this.userType,
        username: username ?? this.username,
        vehicleNumber: vehicleNumber ?? this.vehicleNumber,
        workStatus: workStatus ?? this.workStatus,
        attendenceStatus: attendenceStatus ?? this.attendenceStatus,
      );

  factory UserDetails.fromJson(Map<String, dynamic> json) => UserDetails(
        id: json["id"],
        address: json["address"],
        city: json["city"],
        countryCode: json["country_code"],
        createdOn: json["created_on"],
        description: json["description"],
        deviceType: json["device_type"],
        domain: json["domain"],
        email: json["email"],
        isBlocked: json["is_blocked"],
        landmark: json["landmark"],
        locality: json["locality"],
        masters: json["masters"],
        password: json["password"],
        phoneNumber: json["phone_number"],
        pinNumber: json["pin_number"],
        selectedWarehouses: json["selected_warehouses"],
        state: json["state"],
        updatedOn: json["updated_on"],
        userType: json["user_type"],
        username: json["username"],
        vehicleNumber: json["vehicle_number"],
        workStatus: json["work_status"],
        attendenceStatus: json["attendence_status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "address": address,
        "city": city,
        "country_code": countryCode,
        "created_on": createdOn,
        "description": description,
        "device_type": deviceType,
        "domain": domain,
        "email": email,
        "is_blocked": isBlocked,
        "landmark": landmark,
        "locality": locality,
        "masters": masters,
        "password": password,
        "phone_number": phoneNumber,
        "pin_number": pinNumber,
        "selected_warehouses": selectedWarehouses,
        "state": state,
        "updated_on": updatedOn,
        "user_type": userType,
        "username": username,
        "vehicle_number": vehicleNumber,
        "work_status": workStatus,
        "attendence_status": attendenceStatus,
      };
}
