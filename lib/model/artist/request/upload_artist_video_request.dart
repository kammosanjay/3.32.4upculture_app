class UploadArtistVideoRequest {
  int? uId;
  String? link;

  UploadArtistVideoRequest({this.uId, this.link});

  UploadArtistVideoRequest.fromJson(Map<String, dynamic> json) {
    uId = json['u_id'];
    link = json['link[]'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['u_id'] = uId;
    data['link[]'] = link;
    return data;
  }
}
