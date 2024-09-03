class UploadDocModel {
  bool? status;
  String? message;

  // UploadDocModel({this.status, this.message, this.body});

  UploadDocModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status.toString();
    data['message'] = this.message;

    return data;
  }
}

// class Body {
//   SalesOrderDetail? salesOrderDetail;

//   Body({this.salesOrderDetail});

//   Body.fromJson(Map<String, dynamic> json) {
//     salesOrderDetail = json['salesOrderDetail'] != null
//         ? new SalesOrderDetail.fromJson(json['salesOrderDetail'])
//         : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.salesOrderDetail != null) {
//       data['salesOrderDetail'] = this.salesOrderDetail!.toJson();
//     }
//     return data;
//   }
// }

// class SalesOrderDetail {
//   String? id;
//   String? salesOrderId;

//   String? creationTime;
//   String? updatedOn;
//   String? createdBy;

//   String? executionStatus;

//   String? salesOrderValue;
//   String? totalCollectedPayment;
//   String? totalReturnSkuValue;
//   String? difference;
//   String? vehicleNumber;
//   String? salesOrderPaymentStatus;
//   String? temperature;

//   SalesOrderDetail(
//       {this.id,
//       this.salesOrderId,
//       this.creationTime,
//       this.updatedOn,
//       this.createdBy,
//       this.executionStatus,
//       this.salesOrderValue,
//       this.totalCollectedPayment,
//       this.totalReturnSkuValue,
//       this.difference,
//       this.vehicleNumber,
//       this.salesOrderPaymentStatus,
//       this.temperature});

//   SalesOrderDetail.fromJson(Map<String, dynamic> json) {
//     id = json['id'].toString();
//     salesOrderId = json['salesOrderId'];
//     creationTime = json['creationTime'];
//     updatedOn = json['updatedOn'];
//     createdBy = json['createdBy'].toString();
//     executionStatus = json['executionStatus'];
//     salesOrderValue = json['salesOrderValue'].toString();
//     totalCollectedPayment = json['totalCollectedPayment'].toString();
//     totalReturnSkuValue = json['totalReturnSkuValue'].toString();
//     difference = json['difference'];
//     vehicleNumber = json['vehicleNumber'];
//     salesOrderPaymentStatus = json['salesOrderPaymentStatus'];
//     temperature = json['temperature'].toString();
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id.toString();
//     data['salesOrderId'] = this.salesOrderId;

//     data['creationTime'] = this.creationTime;
//     data['updatedOn'] = this.updatedOn;
//     data['createdBy'] = this.createdBy.toString();

//     data['executionStatus'] = this.executionStatus;

//     data['salesOrderValue'] = this.salesOrderValue.toString();
//     data['totalCollectedPayment'] = this.totalCollectedPayment.toString();
//     data['totalReturnSkuValue'] = this.totalReturnSkuValue.toString();
//     data['difference'] = this.difference.toString();
//     data['vehicleNumber'] = this.vehicleNumber;

//     data['salesOrderPaymentStatus'] = this.salesOrderPaymentStatus;
//     data['temperature'] = this.temperature;
//     return data;
//   }
// }

// class Docs {
//   List<String>? images;

//   Docs({this.images});

//   Docs.fromJson(Map<String, dynamic> json) {
//     images = json['images'].cast<String>();
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['images'] = this.images;
//     return data;
//   }
// }

// class Assignments {
//   InGroup? inGroup;
//   InGroup? arrived;

//   Assignments({this.inGroup, this.arrived});

//   Assignments.fromJson(Map<String, dynamic> json) {
//     inGroup = json['in_group'] != null
//         ? new InGroup.fromJson(json['in_group'])
//         : null;
//     arrived =
//         json['arrived'] != null ? new InGroup.fromJson(json['arrived']) : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.inGroup != null) {
//       data['in_group'] = this.inGroup!.toJson();
//     }
//     if (this.arrived != null) {
//       data['arrived'] = this.arrived!.toJson();
//     }
//     return data;
//   }
// }

// class InGroup {
//   String? userId;
//   String? timestamp;

//   InGroup({this.userId, this.timestamp});

//   InGroup.fromJson(Map<String, dynamic> json) {
//     userId = json['userId'];
//     timestamp = json['timestamp'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['userId'] = this.userId;
//     data['timestamp'] = this.timestamp;
//     return data;
  // }
// }
