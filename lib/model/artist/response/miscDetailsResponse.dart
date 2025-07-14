class miscSubDetailResponse {
  bool? status;
  int? code;
  String? type;
  String? message;
  List<MiscData>? data;

  miscSubDetailResponse(
      {this.status, this.code, this.type, this.message, this.data});

  miscSubDetailResponse.fromJson(Map<dynamic, dynamic> json) {
    status = json['status'];
    code = json['code'];
    type = json['type'];
    message = json['message'];
    if (json['data'] != null) {
      data = <MiscData>[];
      json['data'].forEach((v) {
        data!.add(MiscData.fromJson(v));
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

class MiscData {
  int? id;
  String? name;
  String? photo;
  String? startTime;
  String? endTime;
  String? address;
  String? description;
  int? status;
  int? mId;
  String? createdAt;
  String? updatedAt;

  MiscData(
      {this.id,
      this.name,
      this.photo,
      this.startTime,
      this.endTime,
      this.address,
      this.description,
      this.status,
      this.mId,
      this.createdAt,
      this.updatedAt});

  MiscData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    photo = json['photo'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    address = json['address'];
    description = json['description'];
    status = json['status'];
    mId = json['m_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['photo'] = photo;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['address'] = address;
    data['description'] = description;
    data['status'] = status;
    data['m_id'] = mId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
