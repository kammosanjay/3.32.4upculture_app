class CultureSubCategoryDetailResponse {
  bool? status;
  int? code;
  String? type;
  String? message;
  Data? data;

  CultureSubCategoryDetailResponse(
      {this.status, this.code, this.type, this.message, this.data});

  CultureSubCategoryDetailResponse.fromJson(Map<dynamic, dynamic> json) {
    status = json['status'];
    code = json['code'];
    type = json['type'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['code'] = code;
    data['type'] = type;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  String? cultureCategoryId;
  String? name;
  String? description;
  String? photo;
  String? status;
  dynamic createdAt;
  dynamic updatedAt;

  Data(
      {this.id,
        this.cultureCategoryId,
        this.name,
        this.description,
        this.photo,
        this.status,
        this.createdAt,
        this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cultureCategoryId = json['culture_category_id'];
    name = json['name'];
    description = json['description'];
    photo = json['photo'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['culture_category_id'] = cultureCategoryId;
    data['name'] = name;
    data['description'] = description;
    data['photo'] = photo;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
