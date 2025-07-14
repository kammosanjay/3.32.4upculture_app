class BannerDetailRequest {
  int? bannerId;

  BannerDetailRequest({this.bannerId});

  BannerDetailRequest.fromJson(Map<String, dynamic> json) {
    bannerId = json['banner_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['banner_id'] = bannerId;
    return data;
  }
}
