class ExternalDetailResponse {
  bool? status;
  int? code;
  String? type;
  String? message;
  Data? data;

  ExternalDetailResponse(
      {this.status, this.code, this.type, this.message, this.data});

  ExternalDetailResponse.fromJson(Map<dynamic, dynamic> json) {
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
  String? name;
  String? url;
  String? photo;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? logo;
  String? description;

  Data(
      {this.id,
        this.name,
        this.url,
        this.photo,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.logo,
        this.description});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    url = json['url'];
    photo = json['photo'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    logo = json['logo'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['url'] = url;
    data['photo'] = photo;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['logo'] = logo;
    data['description'] = description;
    return data;
  }
}
