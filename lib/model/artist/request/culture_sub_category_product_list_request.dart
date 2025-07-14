class CultureSubCategoryProductListRequest {
  int? subCategoryId;

  CultureSubCategoryProductListRequest({this.subCategoryId});

  CultureSubCategoryProductListRequest.fromJson(Map<String, dynamic> json) {
    subCategoryId = json['sub_category_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sub_category_id'] = subCategoryId;
    return data;
  }
}

class CultureSubCategoryProductItemListRequest {
  int? subCategoryId;

  CultureSubCategoryProductItemListRequest({this.subCategoryId});

  CultureSubCategoryProductItemListRequest.fromJson(Map<String, dynamic> json) {
    subCategoryId = json['item_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['item_id'] = subCategoryId;
    return data;
  }
}
