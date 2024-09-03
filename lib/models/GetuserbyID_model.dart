class GetuserbyID_model {
  int? status;
  String? message;
  Body? body;

  GetuserbyID_model({this.status, this.message, this.body});

  GetuserbyID_model.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    body = json['body'] != null ? new Body.fromJson(json['body']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.body != null) {
      data['body'] = this.body!.toJson();
    }
    return data;
  }
}

class Body {
  UserDetails? userDetails;

  Body({this.userDetails});

  Body.fromJson(Map<String, dynamic> json) {
    userDetails = json['userDetails'] != null
        ? new UserDetails.fromJson(json['userDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.userDetails != null) {
      data['userDetails'] = this.userDetails!.toJson();
    }
    return data;
  }
}

class UserDetails {
  String? id;
  String? username;
  String? email;
  String? password;
  List<Roles>? roles;
  String? domain;
  List<String>? selectedWarehouses;
  List<SelectedWarehousesDetail>? selectedWarehousesDetail;
  String? vehicleNumber;
  bool? isBlocked;

  UserDetails(
      {this.id,
      this.username,
      this.email,
      this.password,
      this.roles,
      this.domain,
      this.selectedWarehouses,
      this.selectedWarehousesDetail,
      this.vehicleNumber,
      this.isBlocked});

  UserDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    password = json['password'];
    if (json['roles'] != null) {
      roles = <Roles>[];
      json['roles'].forEach((v) {
        roles!.add(new Roles.fromJson(v));
      });
    }

    domain = json['domain'];

    selectedWarehouses = json['selectedWarehouses'].cast<String>();
    if (json['selectedWarehousesDetail'] != null) {
      selectedWarehousesDetail = <SelectedWarehousesDetail>[];
      json['selectedWarehousesDetail'].forEach((v) {
        selectedWarehousesDetail!.add(new SelectedWarehousesDetail.fromJson(v));
      });
    }
    vehicleNumber = json['vehicleNumber'];
    isBlocked = json['isBlocked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['email'] = this.email;
    data['password'] = this.password;
    if (this.roles != null) {
      data['roles'] = this.roles!.map((v) => v.toJson()).toList();
    }

    data['domain'] = this.domain;

    data['selectedWarehouses'] = this.selectedWarehouses;
    if (this.selectedWarehousesDetail != null) {
      data['selectedWarehousesDetail'] =
          this.selectedWarehousesDetail!.map((v) => v.toJson()).toList();
    }
    data['vehicleNumber'] = this.vehicleNumber;
    data['isBlocked'] = this.isBlocked;
    return data;
  }
}

class Roles {
  int? id;
  String? name;
  List<Null>? functionList;

  Roles({this.id, this.name, this.functionList});

  Roles.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    // if (json['functionList'] != null) {
    //   functionList = <Void>[];
    //   json['functionList'].forEach((v) {
    //     functionList!.add( Void.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    // if (functionList != null) {
    //   data['functionList'] = functionList!.map((v) => v!.toJson()).toList();
    // }
    return data;
  }
}

class SelectedWarehousesDetail {
  int? id;
  String? warehouseId;
  String? wareHouseName;
  String? city;
  int? createdBy;
  int? updatedOn;
  int? createdOn;

  SelectedWarehousesDetail(
      {this.id,
      this.warehouseId,
      this.wareHouseName,
      this.city,
      this.createdBy,
      this.updatedOn,
      this.createdOn});

  SelectedWarehousesDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    warehouseId = json['warehouseId'];
    wareHouseName = json['wareHouseName'];
    city = json['city'];
    createdBy = json['createdBy'];
    updatedOn = json['updatedOn'];
    createdOn = json['createdOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['warehouseId'] = this.warehouseId;
    data['wareHouseName'] = this.wareHouseName;
    data['city'] = this.city;
    data['createdBy'] = this.createdBy;
    data['updatedOn'] = this.updatedOn;
    data['createdOn'] = this.createdOn;
    return data;
  }
}
