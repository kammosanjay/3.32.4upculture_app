class ArtistEditProfileResponse {
  bool? status;
  int? code;
  String? type;
  String? message;
  Data? data;

  ArtistEditProfileResponse(
      {this.status, this.code, this.type, this.message, this.data});

  ArtistEditProfileResponse.fromJson(Map<dynamic, dynamic> json) {
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
  int? uId;
  String? address;
  String? city;
  String? typeArtist;
  String? exprience;
  String? gander;
  String? dateOfBirth;
  String? createdAt;
  String? updatedAt;
  String? instagramLink;
  String? facebookLink;
  String? youtubeLink;
  String? photo;
  String? programParticipate;
  int? profileStatus;
  String? totalProgram;
  String? nameInstitution;

  Data(
      {this.id,
        this.uId,
        this.address,
        this.city,
        this.typeArtist,
        this.exprience,
        this.gander,
        this.dateOfBirth,
        this.createdAt,
        this.updatedAt,
        this.instagramLink,
        this.facebookLink,
        this.youtubeLink,
        this.photo,
        this.programParticipate,
        this.profileStatus,
        this.totalProgram,
        this.nameInstitution});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uId = json['u_id'];
    address = json['address'];
    city = json['city'];
    typeArtist = json['type_artist'];
    exprience = json['exprience'];
    gander = json['gander'];
    dateOfBirth = json['date_of_birth'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    instagramLink = json['instagram_link'];
    facebookLink = json['facebook_link'];
    youtubeLink = json['youtube_link'];
    photo = json['photo'];
    programParticipate = json['program_participate'];
    profileStatus = json['profile_status'];
    totalProgram = json['total_program'];
    nameInstitution = json['name_institution'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['u_id'] = uId;
    data['address'] = address;
    data['city'] = city;
    data['type_artist'] = typeArtist;
    data['exprience'] = exprience;
    data['gander'] = gander;
    data['date_of_birth'] = dateOfBirth;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['instagram_link'] = instagramLink;
    data['facebook_link'] = facebookLink;
    data['youtube_link'] = youtubeLink;
    data['photo'] = photo;
    data['program_participate'] = programParticipate;
    data['profile_status'] = profileStatus;
    data['total_program'] = totalProgram;
    data['name_institution'] = nameInstitution;
    return data;
  }
}
