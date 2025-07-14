class AllUsersList {
  int? userId;
  String? name;
  String? vidhaName;
  String? districtsName;
  String? photo;
  String? actionBtn;

  AllUsersList(
      {this.userId,
        this.name,
        this.vidhaName,
        this.districtsName,
        this.photo,
        this.actionBtn});

  AllUsersList.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    name = json['name'];
    vidhaName = json['vidha_name'];
    districtsName = json['districts_name'];
    photo = json['photo'];
    actionBtn = json['action_btn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['vidha_name'] = this.vidhaName;
    data['districts_name'] = this.districtsName;
    data['photo'] = this.photo;
    data['action_btn'] = this.actionBtn;
    return data;
  }
}
