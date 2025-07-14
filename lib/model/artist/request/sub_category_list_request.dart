class SubCategoryListRequest {
  int? cId;


  SubCategoryListRequest({this.cId});

  SubCategoryListRequest.fromJson(Map<String, dynamic> json) {
    cId = json['c_id'];
   
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['c_id'] = cId;
   
    return data;
  }
}
