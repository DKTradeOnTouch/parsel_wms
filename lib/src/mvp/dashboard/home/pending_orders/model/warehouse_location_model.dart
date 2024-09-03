import 'package:freezed_annotation/freezed_annotation.dart';

part 'warehouse_location_model.freezed.dart';
part 'warehouse_location_model.g.dart';

@immutable
@freezed
class WarehouseLocationModel with _$WarehouseLocationModel {
  const factory WarehouseLocationModel({
    @JsonKey(name: 'status') required int status,
    @JsonKey(name: 'message') required String message,
    @JsonKey(name: 'body') required Body body,
  }) = _WarehouseLocationModel;

  factory WarehouseLocationModel.fromJson(Map<String, dynamic> json) =>
      _$WarehouseLocationModelFromJson(json);
}

@immutable
@freezed
class Body with _$Body {
  const factory Body({
    @JsonKey(name: 'userDetails') required UserDetails userDetails,
  }) = _Body;

  factory Body.fromJson(Map<String, dynamic> json) => _$BodyFromJson(json);
}

@immutable
@freezed
class UserDetails with _$UserDetails {
  const factory UserDetails({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'username') required String username,
    @JsonKey(name: 'email') required String email,
    @JsonKey(name: 'password') required String password,
    @JsonKey(name: 'roles') required List<Role> roles,
    @JsonKey(name: 'masters') required dynamic masters,
    @JsonKey(name: 'phone_number') required int phoneNumber,
    @JsonKey(name: 'address') required dynamic address,
    @JsonKey(name: 'country_code') required dynamic countryCode,
    @JsonKey(name: 'pin_number') required dynamic pinNumber,
    @JsonKey(name: 'state') required dynamic state,
    @JsonKey(name: 'city') required dynamic city,
    @JsonKey(name: 'landmark') required dynamic landmark,
    @JsonKey(name: 'locality') required dynamic locality,
    @JsonKey(name: 'user_type') required dynamic userType,
    @JsonKey(name: 'domain') required String domain,
    @JsonKey(name: 'description') required dynamic description,
    @JsonKey(name: 'device_type') required dynamic deviceType,
    @JsonKey(name: 'selectedWarehouses')
    required List<String> selectedWarehouses,
    @JsonKey(name: 'selectedWarehousesDetail')
    required List<SelectedWarehousesDetail> selectedWarehousesDetail,
    @JsonKey(name: 'vehicleNumber') required dynamic vehicleNumber,
    @JsonKey(name: 'isBlocked') required bool isBlocked,
    @JsonKey(name: 'createdOn') required dynamic createdOn,
    @JsonKey(name: 'updatedOn') required dynamic updatedOn,
  }) = _UserDetails;

  factory UserDetails.fromJson(Map<String, dynamic> json) =>
      _$UserDetailsFromJson(json);
}

@immutable
@freezed
class Role with _$Role {
  const factory Role(
          {@JsonKey(name: 'id') required int id,
          @JsonKey(name: 'name') required String name,
          @JsonKey(name: 'functionList') required List<dynamic> functionList}) =
      _Role;

  factory Role.fromJson(Map<String, dynamic> json) => _$RoleFromJson(json);
}

@immutable
@freezed
class SelectedWarehousesDetail with _$SelectedWarehousesDetail {
  const factory SelectedWarehousesDetail({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'warehouseId') required String warehouseId,
    @JsonKey(name: 'wareHouseName') required String wareHouseName,
    @JsonKey(name: 'city') required String city,
    @JsonKey(name: 'createdBy') required dynamic createdBy,
    @JsonKey(name: 'updatedOn') required int updatedOn,
    @JsonKey(name: 'createdOn') required int createdOn,
  }) = _SelectedWarehousesDetail;

  factory SelectedWarehousesDetail.fromJson(Map<String, dynamic> json) =>
      _$SelectedWarehousesDetailFromJson(json);
}
