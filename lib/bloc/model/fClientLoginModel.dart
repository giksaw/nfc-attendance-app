class clientLogin {
  String? id;
  String? password;

  clientLogin({this.id, this.password});

  clientLogin.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['password'] = this.password;
    return data;
  }
}
