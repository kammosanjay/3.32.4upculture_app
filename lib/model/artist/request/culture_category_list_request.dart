class CultureCategoryListRequest {
  int? cultureId;

  CultureCategoryListRequest({this.cultureId});

  CultureCategoryListRequest.fromJson(Map<String, dynamic> json) {
    cultureId = json['culture_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['culture_id'] = cultureId;
    return data;
  }
}
