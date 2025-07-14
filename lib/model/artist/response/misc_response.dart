class MiscResponse {
  bool? status;
  int? code;
  String? type;
  String? message;
  List<Misc>? data;

  MiscResponse({this.status, this.code, this.type, this.message, this.data});

  MiscResponse.fromJson(Map<dynamic, dynamic> json) {
    status = json['status'];
    code = json['code'];
    type = json['type'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Misc>[];
      json['data'].forEach((v) {
        data!.add(Misc.fromJson(v));
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

class Misc {
  int? id;
  String? name;
  String? photo;
  int? status;

  Misc({this.id, this.name, this.photo, this.status});

  Misc.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    photo = json['photo'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['photo'] = photo;
    data['status'] = status;
    return data;
  }
}