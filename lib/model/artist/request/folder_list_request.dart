class FolderListRequest {
  int? uId;

  FolderListRequest({this.uId});

  FolderListRequest.fromJson(Map<String, dynamic> json) {
    uId = json['u_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['u_id'] = uId;
    return data;
  }
}
