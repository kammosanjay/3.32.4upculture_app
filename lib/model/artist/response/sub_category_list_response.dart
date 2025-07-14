class SubCategoryListResponse {
  bool? status;
  int? code;
  String? type;
  String? message;
  List<Data>? data;

  SubCategoryListResponse(
      {this.status, this.code, this.type, this.message, this.data});

  SubCategoryListResponse.fromJson(Map<dynamic, dynamic> json) {
    status = json['status'];
    code = json['code'];
    type = json['type'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
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

class Data {
  int? id;
  int? cId;
  String? name;
  String? photo;
  int? status;

  Data(
      {this.id,
        this.cId,
        this.name,
        this.photo,
        this.status,});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cId = json['c_id'];
    name = json['name'];
    photo = json['photo'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['c_id'] = cId;
    data['name'] = name;
    data['photo'] = photo;
    data['status'] = status;
    return data;
  }
}
