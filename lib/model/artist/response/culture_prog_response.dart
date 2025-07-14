class CultureProgramResponse {
  bool? status;
  int? code;
  String? type;
  String? message;
  List<CultureData>? data;

  CultureProgramResponse(
      {this.status, this.code, this.type, this.message, this.data});

  CultureProgramResponse.fromJson(Map<dynamic, dynamic> json) {
    status = json['status'];
    code = json['code'];
    type = json['type'];
    message = json['message'];
    if (json['data'] != null) {
      data = <CultureData>[];
      json['data'].forEach((v) {
        data!.add(CultureData.fromJson(v));
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

class CultureData {
  int? id;
  String? name;
  String? image;

  CultureData({this.id, this.name, this.image});

  CultureData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    return data;
  }
}