class SubCategoryGalleryRequest {
  int? subId;

  SubCategoryGalleryRequest({this.subId});

  SubCategoryGalleryRequest.fromJson(Map<String, dynamic> json) {
    subId = json['sub_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sub_id'] = subId;
    return data;
  }
}
