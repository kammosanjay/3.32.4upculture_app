class CreateFolderResponse {
  bool? status;
  int? code;
  String? type;
  String? message;
  Data? data;

  CreateFolderResponse(
      {this.status, this.code, this.type, this.message, this.data});

  CreateFolderResponse.fromJson(Map<dynamic, dynamic> json) {
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
  String? uId;
  String? name;
  String? photo;
  String? updatedAt;
  String? createdAt;
  int? id;

  Data(
      {this.uId,
        this.name,
        this.photo,
        this.updatedAt,
        this.createdAt,
        this.id});

  Data.fromJson(Map<String, dynamic> json) {
    uId = json['u_id'];
    name = json['name'];
    photo = json['photo'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['u_id'] = uId;
    data['name'] = name;
    data['photo'] = photo;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['id'] = id;
    return data;
  }
}
