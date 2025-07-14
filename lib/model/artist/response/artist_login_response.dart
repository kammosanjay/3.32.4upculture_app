class ArtistLoginResponse {
  bool? status;
  int? code;
  String? type;
  String? message;
  Data? data;

  ArtistLoginResponse(
      {this.status, this.code, this.type, this.message, this.data});

  ArtistLoginResponse.fromJson(Map<dynamic, dynamic> json) {
    status = json['status'];
    code = json['code'];
    type = json['type'];
    message = json['message'];
    data = json['data'] != null?  Data.fromJson(json['data']) : null;
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
  int? user_id;
  // String? name;
  // String? email;
  // Null? emailVerifiedAt;
  // String? createdAt;
  // String? updatedAt;
  // int? role;
  // String? mobile;
  // int? status;
  int? otp;

  Data(
      {this.user_id,
        // this.name,
        // this.email,
        // this.emailVerifiedAt,
        // this.createdAt,
        // this.updatedAt,
        // this.role,
        // this.mobile,
        // this.status,
        this.otp});

  Data.fromJson(Map<String, dynamic> json) {
    user_id = json['user_id'];
    // name = json['name'];
    // email = json['email'];
    // emailVerifiedAt = json['email_verified_at'];
    // createdAt = json['created_at'];
    // updatedAt = json['updated_at'];
    // role = json['role'];
    // mobile = json['mobile'];
    // status = json['status'];
    otp = json['otp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = user_id;
    // data['name'] = this.name;
    // data['email'] = this.email;
    // data['email_verified_at'] = this.emailVerifiedAt;
    // data['created_at'] = this.createdAt;
    // data['updated_at'] = this.updatedAt;
    // data['role'] = this.role;
    // data['mobile'] = this.mobile;
    // data['status'] = this.status;
    data['otp'] = otp;
    return data;
  }
}
