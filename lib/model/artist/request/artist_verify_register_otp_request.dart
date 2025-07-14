class ArtistVerifyRegisterOtpRequest {
  int? user_id;
  int? otp;

  ArtistVerifyRegisterOtpRequest({this.user_id, this.otp});

  ArtistVerifyRegisterOtpRequest.fromJson(Map<String, dynamic> json) {
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
