class SubCategoryGalleryResponse {
  bool? status;
  int? code;
  String? type;
  String? message;
  List<Data>? data;

  SubCategoryGalleryResponse(
      {this.status, this.code, this.type, this.message, this.data});

  SubCategoryGalleryResponse.fromJson(Map<dynamic, dynamic> json) {
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
  int? subId;
  String? photo;
  int? status;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
        this.subId,
        this.photo,
        this.status,
        this.createdAt,
        this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subId = json['sub_id'];
    photo = json['photo'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['sub_id'] = subId;
    data['photo'] = photo;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
