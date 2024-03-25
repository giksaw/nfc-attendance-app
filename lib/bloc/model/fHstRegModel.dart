class hostRegister {
  String? id;
  String? name;
  String? password;
  String? email;
  String? course;

  hostRegister({this.id, this.name, this.password, this.email, this.course});

  hostRegister.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    password = json['password'];
    email = json['email'];
    course = json['course'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['password'] = this.password;
    data['email'] = this.email;
    data['course'] = this.course;
    return data;
  }
}
