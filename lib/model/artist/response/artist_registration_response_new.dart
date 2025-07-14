class ArtistRegistrationResponseNew {
  bool? status;
  int? code;
  String? type;
  String? message;
  Data? data;

  ArtistRegistrationResponseNew({this.status, this.code, this.type, this.message, this.data});

  ArtistRegistrationResponseNew.fromJson(Map<dynamic, dynamic> json){
    status = json['status'];
    code = json['code'];
    type = json['type'];
    message = json['message'];
    data = json['data'] != null ? Data?.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['code'] = code;
    data['type'] = type;
    data['message'] = message;
    // data['data'] = data!.toJson();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? user_id;
  int? otp;

  Data({this.user_id, this.otp});

  Data.fromJson(Map<String, dynamic> json) {
    user_id = json['user_id'];
    otp = json['otp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = user_id;
    data['otp'] = otp;
    return data;
  }
}
