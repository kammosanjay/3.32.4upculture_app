class CultureProgramDetailsResponse {
  bool? status;
  int? code;
  String? type;
  String? message;
  CultureDetails? data;

  CultureProgramDetailsResponse(
      {this.status, this.code, this.type, this.message, this.data});

  CultureProgramDetailsResponse.fromJson(Map<dynamic, dynamic> json) {
    status = json['status'];
    code = json['code'];
    type = json['type'];
    message = json['message'];
    data = json['data'] != null ? CultureDetails.fromJson(json['data']) : null;
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

class CultureDetails {
  int? id;
  String? name;
  String? image;
  String? content;
  int? status;
  String? createdAt;
  String? updatedAt;

  CultureDetails(
      {this.id,
        this.name,
        this.image,
        this.content,
        this.status,
        this.createdAt,
        this.updatedAt});

  CultureDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    content = json['content'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    data['content'] = content;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}