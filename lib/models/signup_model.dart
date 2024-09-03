class SignInModel {
  String? token;
  String? type;
  int? id;
  int? phoneNumber;
  String? email;
  List<String>? roles;

  SignInModel(
      {this.token,
      this.type,
      this.id,
      this.phoneNumber,
      this.email,
      this.roles});

  SignInModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    type = json['type'];
    id = json['id'];
    phoneNumber = json['phone_number'];
    email = json['email'];
    roles = json['roles'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['type'] = this.type;
    data['id'] = this.id;
    data['phone_number'] = this.phoneNumber;
    data['email'] = this.email;
    data['roles'] = this.roles;
    return data;
  }
}

