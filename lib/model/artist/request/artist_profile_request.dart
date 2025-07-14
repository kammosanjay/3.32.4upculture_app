class ArtistProfileRequest {
  int? uId;

  ArtistProfileRequest({this.uId});

  ArtistProfileRequest.fromJson(Map<String, dynamic> json) {
    uId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = uId;
    return data;
  }
}
