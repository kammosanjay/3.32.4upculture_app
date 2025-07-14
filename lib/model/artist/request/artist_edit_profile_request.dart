class ArtistEditProfileRequest {
  int? uId;
  int? exprience;
  int? totalProgram;
  String? programParticipate;
  int? city;
  String? address;
  String? instagramLink;
  String? facebookLink;
  String? youtubeLink;
  String? photo;

  ArtistEditProfileRequest(
      {this.uId,
        this.exprience,
        this.totalProgram,
        this.programParticipate,
        this.city,
        this.address,
        this.instagramLink,
        this.facebookLink,
        this.youtubeLink,
        this.photo});

  ArtistEditProfileRequest.fromJson(Map<dynamic, dynamic> json) {
    uId = json['u_id'];
    exprience = json['exprience'];
    totalProgram = json['total_program'];
    programParticipate = json['program_participate'];
    city = json['city'];
    address = json['address'];
    instagramLink = json['instagram_link'];
    facebookLink = json['facebook_link'];
    youtubeLink = json['youtube_link'];
    photo = json['photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['u_id'] = uId;
    data['exprience'] = exprience;
    data['total_program'] = totalProgram;
    data['program_participate'] = programParticipate;
    data['city'] = city;
    data['address'] = address;
    data['instagram_link'] = instagramLink;
    data['facebook_link'] = facebookLink;
    data['youtube_link'] = youtubeLink;
    data['photo'] = photo;
    return data;
  }
}
