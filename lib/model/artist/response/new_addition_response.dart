class NewAdditionResponse {
  bool? status;
  int? code;
  String? type;
  String? message;
  List<NewAddition>? data;

  NewAdditionResponse(
      {this.status, this.code, this.type, this.message, this.data});

  NewAdditionResponse.fromJson(Map<dynamic, dynamic> json) {
    status = json['status'];
    code = json['code'];
    type = json['type'];
    message = json['message'];
    if (json['data'] != null) {
      data = <NewAddition>[];
      json['data'].forEach((v) {
        data!.add(NewAddition.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['code'] = code;
    data['type'] = type;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NewAddition {
  int? id;
  String? name;
  String? photo;
  String? type;

  NewAddition({this.id, this.name, this.photo, this.type});

  NewAddition.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    photo = json['photo'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['photo'] = photo;
    data['type'] = type;
    return data;
  }
}
