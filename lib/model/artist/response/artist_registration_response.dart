class ArtistRegistrationResponse {
  bool? status;
  int? code;
  String? type;
  String? message;

  ArtistRegistrationResponse({this.status, this.code, this.type, this.message});

  ArtistRegistrationResponse.fromJson(Map<dynamic, dynamic> json){
    status = json['status'];
    code = json['code'];
    type = json['type'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['code'] = code;
    data['type'] = type;
    data['message'] = message;
    return data;
  }
}
