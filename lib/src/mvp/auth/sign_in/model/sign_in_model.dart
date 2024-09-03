import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_in_model.freezed.dart';
part 'sign_in_model.g.dart';

@immutable
@freezed
class SignInModel with _$SignInModel {
  const factory SignInModel({
    @JsonKey(name: 'token') required String token,
    @JsonKey(name: 'type') required String type,
    @JsonKey(name: 'id') required dynamic id,
    @JsonKey(name: 'phone_number') required int phoneNumber,
    @JsonKey(name: 'email') required String email,
    @JsonKey(name: 'roles') required List<String> roles,
  }) = _SignInModel;

  factory SignInModel.fromJson(Map<String, dynamic> json) =>
      _$SignInModelFromJson(json);
}
