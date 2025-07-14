class CultureSubCategoryListRequest {
  int? cultureCategoryId;

  CultureSubCategoryListRequest({this.cultureCategoryId});

  CultureSubCategoryListRequest.fromJson(Map<String, dynamic> json) {
    cultureCategoryId = json['culture_category_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['culture_category_id'] = cultureCategoryId;
    return data;
  }
}
