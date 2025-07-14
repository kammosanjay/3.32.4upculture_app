class SubCategoryDetailResponse {
  bool? status;
  int? code;
  String? type;
  String? message;
  List<Data>? data;

  SubCategoryDetailResponse(
      {this.status, this.code, this.type, this.message, this.data});

  SubCategoryDetailResponse.fromJson(Map<dynamic, dynamic> json) {
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
  String? createdAt;
  String? updatedAt;
  String? address;
  String? description;

  Data(
      { this.id,
        this.cId,
        this.name,
        this.photo,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.address,
        this.description});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cId = json['c_id'];
    name = json['name'];
    photo = json['photo'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    address = json['address'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['c_id'] = cId;
    data['name'] = name;
    data['photo'] = photo;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['address'] = address;
    data['description'] = description;
    return data;
  }
}
