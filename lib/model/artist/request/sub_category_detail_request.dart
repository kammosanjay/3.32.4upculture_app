class SubCategoryDetailRequest {
  int? subId;

  SubCategoryDetailRequest({this.subId});

  SubCategoryDetailRequest.fromJson(Map<String, dynamic> json) {
    subId = json['sub_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sub_id'] = subId;
    return data;
  }
}
