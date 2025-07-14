class ArtistGalleryListResponse {
  bool? status;
  int? code;
  String? type;
  String? message;
  List<Data>? data;

  ArtistGalleryListResponse(
      {this.status, this.code, this.type, this.message, this.data});

  ArtistGalleryListResponse.fromJson(Map<dynamic, dynamic> json) {
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
  int? uId;
  String? photo;
  String? createdAt;
  String? updatedAt;
  int? fId;
  int? status;

  Data(
      {this.id,
        this.uId,
        this.photo,
        this.createdAt,
        this.updatedAt,
        this.fId,
        this.status});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uId = json['u_id'];
    photo = json['photo'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    fId = json['f_id'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['u_id'] = uId;
    data['photo'] = photo;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['f_id'] = fId;
    data['status'] = status;
    return data;
  }
}
