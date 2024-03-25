class checkattendace {
  String? course;
  String? date;
  String? id;

  checkattendace({this.course, this.date, this.id});

  checkattendace.fromJson(Map<String, dynamic> json) {
    course = json['course'];
    date = json['date'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['course'] = this.course;
    data['date'] = this.date;
    data['id'] = this.id;
    return data;
  }
}
