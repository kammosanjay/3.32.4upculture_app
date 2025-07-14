class HeritageDetailRequest {
  int? cultureHeritageId;

  HeritageDetailRequest({this.cultureHeritageId});

  HeritageDetailRequest.fromJson(Map<String, dynamic> json) {
    cultureHeritageId = json['culture_heritage_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['culture_heritage_id'] = cultureHeritageId;
    return data;
  }
}
