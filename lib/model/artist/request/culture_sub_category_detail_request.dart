class CultureSubCategoryDetailRequest {
  int? cultureSubCategoryId;

  CultureSubCategoryDetailRequest({this.cultureSubCategoryId});

  CultureSubCategoryDetailRequest.fromJson(Map<String, dynamic> json) {
    cultureSubCategoryId = json['culture_sub_category_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['culture_sub_category_id'] = cultureSubCategoryId;
    return data;
  }
}
