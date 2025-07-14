class CultureSubCategorySliderRequest {
  int? subCategoryId;

  CultureSubCategorySliderRequest({this.subCategoryId});

  CultureSubCategorySliderRequest.fromJson(Map<String, dynamic> json) {
    subCategoryId = json['sub_category_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sub_category_id'] = subCategoryId;
    return data;
  }
}
