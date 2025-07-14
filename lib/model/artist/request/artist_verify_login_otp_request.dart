class ArtistVerifyLoginOtpRequest {
  int? uId;
  int? otp;

  ArtistVerifyLoginOtpRequest({this.uId, this.otp});

  ArtistVerifyLoginOtpRequest.fromJson(Map<String, dynamic> json) {
    uId = json['u_id'];
    otp = json['otp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['u_id'] = uId;
    data['otp'] = otp;
    return data;
  }
}
