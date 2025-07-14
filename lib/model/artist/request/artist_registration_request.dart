class ArtistRegistrationRequest {
  String? name;
  int? mobile;
  String? nameInstitution;
  String? email;
  String? address;
  int? city;
  int? typeArtist;
  int? exprience;
  int? gander;
  String? dateOfBirth;
  String? instagramLink;
  String? facebookLink;
  String? youtubeLink;

  ArtistRegistrationRequest(
      {this.name,
        this.mobile,
        this.nameInstitution,
        this.email,
        this.address,
        this.city,
        this.typeArtist,
        this.exprience,
        this.gander,
        this.dateOfBirth,
        this.instagramLink,
        this.facebookLink,
        this.youtubeLink});

  ArtistRegistrationRequest.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    mobile = json['mobile'];
    nameInstitution = json['name_institution'];
    email = json['email'];
    address = json['address'];
    city = json['city'];
    typeArtist = json['type_artist'];
    exprience = json['exprience'];
    gander = json['gander'];
    dateOfBirth = json['date_of_birth'];
    instagramLink = json['instagram_link'];
    facebookLink = json['facebook_link'];
    youtubeLink = json['youtube_link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['mobile'] = mobile;
    data['name_institution'] = nameInstitution;
    data['email'] = email;
    data['address'] = address;
    data['city'] = city;
    data['type_artist'] = typeArtist;
    data['exprience'] = exprience;
    data['gander'] = gander;
    data['date_of_birth'] = dateOfBirth;
    data['instagram_link'] = instagramLink;
    data['facebook_link'] = facebookLink;
    data['youtube_link'] = youtubeLink;
    return data;
  }
}
