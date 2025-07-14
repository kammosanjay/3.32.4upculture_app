class ArtistGalleryListRequest {
  int? uId;
  int? fId;

  ArtistGalleryListRequest({this.uId, this.fId});

  ArtistGalleryListRequest.fromJson(Map<String, dynamic> json) {
    uId = json['u_id'];
    fId = json['f_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['u_id'] = uId;
    data['f_id'] = fId;
    return data;
  }
}
