class LogInModel {
  String? token;
  String? type;
  String? id;
  String? phoneNumber;
  String? email;
  List<String>? roles;

  LogInModel(
      {this.token,
      this.type,
      this.id,
      this.phoneNumber,
      this.email,
      this.roles});

  LogInModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    type = json['type'];
    id = json['id'].toString();
    phoneNumber = json['phone_number'].toString();
    email = json['email'];
    roles = json['roles'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    data['type'] = type;
    data['id'] = id;
    data['phone_number'] = phoneNumber;
    data['email'] = email;
    data['roles'] = roles;
    return data;
  }
}
