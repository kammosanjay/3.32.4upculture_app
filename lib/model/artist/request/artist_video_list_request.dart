class ArtistVideoListRequest {
  int? uId;

  ArtistVideoListRequest({this.uId});

  ArtistVideoListRequest.fromJson(Map<String, dynamic> json) {
    uId = json['u_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['u_id'] = uId;
    return data;
  }
}
