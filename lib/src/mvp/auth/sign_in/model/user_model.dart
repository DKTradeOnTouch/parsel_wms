import 'dart:convert';

UserResponse userResponseFromJson(String str) =>
    UserResponse.fromJson(json.decode(str));

String userResponseToJson(UserResponse data) => json.encode(data.toJson());

class UserResponse {
  final String sub;
  final User user;
  final int iat;
  final int exp;

  UserResponse({
    required this.sub,
    required this.user,
    required this.iat,
    required this.exp,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) => UserResponse(
        sub: json["sub"],
        user: User.fromJson(json["user"]),
        iat: json["iat"],
        exp: json["exp"],
      );

  Map<String, dynamic> toJson() => {
        "sub": sub,
        "user": user.toJson(),
        "iat": iat,
        "exp": exp,
      };
}

class User {
  final String id;
  final String email;
  final List<Authority> authorities;
  final dynamic master;
  final List<String> selectedWarehouses;
  final bool enabled;
  final dynamic username;
  final int phoneNumber;
  final bool accountNonExpired;
  final bool accountNonLocked;
  final bool credentialsNonExpired;

  User({
    required this.id,
    required this.email,
    required this.authorities,
    required this.master,
    required this.selectedWarehouses,
    required this.enabled,
    required this.username,
    required this.phoneNumber,
    required this.accountNonExpired,
    required this.accountNonLocked,
    required this.credentialsNonExpired,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        email: json["email"],
        authorities: List<Authority>.from(
            json["authorities"].map((x) => Authority.fromJson(x))),
        master: json["master"],
        selectedWarehouses:
            List<String>.from(json["selectedWarehouses"].map((x) => x)),
        enabled: json["enabled"],
        username: json["username"],
        phoneNumber: json["phoneNumber"],
        accountNonExpired: json["accountNonExpired"],
        accountNonLocked: json["accountNonLocked"],
        credentialsNonExpired: json["credentialsNonExpired"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "authorities": List<dynamic>.from(authorities.map((x) => x.toJson())),
        "master": master,
        "selectedWarehouses":
            List<dynamic>.from(selectedWarehouses.map((x) => x)),
        "enabled": enabled,
        "username": username,
        "phoneNumber": phoneNumber,
        "accountNonExpired": accountNonExpired,
        "accountNonLocked": accountNonLocked,
        "credentialsNonExpired": credentialsNonExpired,
      };
}

class Authority {
  final String authority;

  Authority({
    required this.authority,
  });

  factory Authority.fromJson(Map<String, dynamic> json) => Authority(
        authority: json["authority"],
      );

  Map<String, dynamic> toJson() => {
        "authority": authority,
      };
}
