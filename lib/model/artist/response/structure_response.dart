class structureResponse {
  bool? status;
  int? code;
  String? type;
  String? message;
  Data? data;

  structureResponse(
      {this.status, this.code, this.type, this.message, this.data});

  structureResponse.fromJson(Map<dynamic, dynamic> json) {
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
  String? heading;
  String? photo;
  int? status;
  dynamic createdAt;
  dynamic updatedAt;
  String? path;
  int? type;

  Data(
      {this.id,
        this.heading,
        this.photo,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.path,
        this.type});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    heading = json['heading'];
    photo = json['photo'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    path = json['path'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['heading'] = heading;
    data['photo'] = photo;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['path'] = path;
    data['type'] = type;
    return data;
  }
}