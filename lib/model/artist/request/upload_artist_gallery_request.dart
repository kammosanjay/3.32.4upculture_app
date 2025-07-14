class UploadArtistGalleryRequest {
  int? uId;
  int? fId;
  String? photo;

  UploadArtistGalleryRequest({this.uId, this.fId, this.photo});

  UploadArtistGalleryRequest.fromJson(Map<String, dynamic> json) {
    uId = json['u_id'];
    fId = json['f_id'];
    photo = json['photo[]'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['u_id'] = uId;
    data['f_id'] = fId;
    data['photo[]'] = photo;
    return data;
  }
}
