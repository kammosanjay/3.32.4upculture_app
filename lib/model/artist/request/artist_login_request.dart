class ArtistLoginRequest {
  int? mobile;

  ArtistLoginRequest({this.mobile});

  ArtistLoginRequest.fromJson(Map<String, dynamic> json) {
    mobile = json['mobile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mobile'] = mobile;
    return data;
  }
}
