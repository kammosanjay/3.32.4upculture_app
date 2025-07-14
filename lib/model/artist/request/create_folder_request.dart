class CreateFolderRequest {
  int? uId;
  String? name;

  CreateFolderRequest({this.uId, this.name});

  CreateFolderRequest.fromJson(Map<String, dynamic> json) {
    uId = json['u_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['u_id'] = uId;
    data['name'] = name;
    return data;
  }
}
