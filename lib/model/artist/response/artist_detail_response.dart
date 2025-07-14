class ArtistDetailResponse {
  bool? status;
  int? code;
  String? type;
  String? message;
  Data? data;

  ArtistDetailResponse(
      {this.status, this.code, this.type, this.message, this.data});

  ArtistDetailResponse.fromJson(Map<dynamic, dynamic> json) {
    status = json['status'];
    code = json['code'];
    type = json['type'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['code'] = code;
    data['type'] = type;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  String? name;
  String? email;
  String? mobile;
  String? nameInstitution;
  String? address;
  String? city;
  String? typeArtist;
  String? exprience;
  String? gander;
  String? dateOfBirth;
  String? instagramLink;
  String? facebookLink;
  String? youtubeLink;
  String? photo;
  int? totalProgram;
  String? programParticipate;
  int? profileStatus;

  Data(
      {this.id,
        this.name,
        this.email,
        this.mobile,
        this.nameInstitution,
        this.address,
        this.city,
        this.typeArtist,
        this.exprience,
        this.gander,
        this.dateOfBirth,
        this.instagramLink,
        this.facebookLink,
        this.youtubeLink,
        this.photo,
        this.totalProgram,
        this.programParticipate,
        this.profileStatus});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    mobile = json['mobile'];
    nameInstitution = json['name_institution'];
    address = json['address'];
    city = json['city'];
    typeArtist = json['type_artist'];
    exprience = json['exprience'];
    gander = json['gander'];
    dateOfBirth = json['date_of_birth'];
    instagramLink = json['instagram_link'];
    facebookLink = json['facebook_link'];
    youtubeLink = json['youtube_link'];
    photo = json['photo'];
    totalProgram = json['total_program'];
    programParticipate = json['program_participate'];
    profileStatus = json['profile_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['mobile'] = mobile;
    data['name_institution'] = nameInstitution;
    data['address'] = address;
    data['city'] = city;
    data['type_artist'] = typeArtist;
    data['exprience'] = exprience;
    data['gander'] = gander;
    data['date_of_birth'] = dateOfBirth;
    data['instagram_link'] = instagramLink;
    data['facebook_link'] = facebookLink;
    data['youtube_link'] = youtubeLink;
    data['photo'] = photo;
    data['total_program'] = totalProgram;
    data['program_participate'] = programParticipate;
    data['profile_status'] = profileStatus;
    return data;
  }
}
