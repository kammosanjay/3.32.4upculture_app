class ArtistRegistrationRequestNew {
  String? name;
  int? mobile;
  String? email;
  String? language;

  ArtistRegistrationRequestNew(
      {this.name,
        this.mobile,
        this.email,
        this.language});

  ArtistRegistrationRequestNew.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    mobile = json['mobile'];
    email = json['email'];
    language = json['language'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['mobile'] = mobile;
    data['email'] = email;
    data['language'] = language;
    return data;
  }
}
