class ArtistProfileResponse {
  bool? status;
  int? code;
  String? type;
  String? message;
  Data? data;

  ArtistProfileResponse(
      {this.status, this.code, this.type, this.message, this.data});

  ArtistProfileResponse.fromJson(Map<dynamic, dynamic> json) {
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
  String? email_id;
  String? userProfile;
  String? mobile_number;
  String? nameInstitution;
  String? districts_name;
  String? address;
  String? vidha_name;
  String? cost;
  String? team_member;
  String? seniorArtistName1;
  String? seniorArtistDesignation1;
  String? seniorArtistMobileNumber1;
  String? seniorArtistName2;
  String? seniorArtistDesignation2;
  String? seniorArtistMobileNumber2;
  String? proposed_remuneration;
  String? trainingCertificate;
  String? gradeCertificate;
  String? auditionLink;
  String? otherInfo;

  String? youtubeLink;
  String? area_of_art;
  String? presentation_level;
  String? city;
  String? typeArtist;
  String? experience;
  String? gender;
  String? dateOfBirth;
  String? date;
  String? grade_name;
  String? month;
  String? year;
  String? instagramLink;
  String? facebookLink;

  List<dynamic>? photo;
  int? totalProgram;
  String? programParticipate;
  int? profileStatus;

  Data(
      {this.id,
      this.name,
      this.email_id,
      this.cost,
      this.proposed_remuneration,
      this.userProfile,
      this.team_member,
      this.presentation_level,
      this.vidha_name,
      
      this.grade_name,
      this.seniorArtistName1,
      this.seniorArtistDesignation1,
      this.seniorArtistMobileNumber1,
      this.seniorArtistName2,
      this.seniorArtistDesignation2,
      this.seniorArtistMobileNumber2,
      this.area_of_art,
      this.mobile_number,
      this.nameInstitution,
      this.address,
      this.districts_name,
      this.city,
      this.typeArtist,
      this.experience,
      this.dateOfBirth,
      this.gender,
      this.date,
      this.month,
      this.year,
      this.instagramLink,
      this.facebookLink,
      this.trainingCertificate,
      this.gradeCertificate,
      this.auditionLink,
      this.otherInfo,
      this.youtubeLink,
      this.photo,
      this.totalProgram,
      this.programParticipate,
      this.profileStatus});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    name = json['name'];
    cost =json['cost'];
    team_member = json['team_member'];
    seniorArtistName1 = json['senior_artist_name1'] ?? '';
    seniorArtistDesignation1 = json['senior_artist_designation1'] ?? '';
    seniorArtistMobileNumber1 = json['senior_artist_mobile_number1'] ?? '';
    seniorArtistName2 = json['senior_artist_name2'] ?? '';
    seniorArtistDesignation2 = json['senior_artist_designation2'] ?? '';
    seniorArtistMobileNumber2 = json['senior_artist_mobile_number2'] ?? '';
    email_id = json['email_id'];
    trainingCertificate = json['training_certificate'] ?? '';
    gradeCertificate = json['grade_certificate'] ?? '';
    auditionLink = json['audition_link'] ?? '';
    otherInfo = json['other_info'] ?? '';

    youtubeLink = json['youtube_link'] ?? '';
    presentation_level = json['presentation_level'];
    districts_name = json['districts_name'];
    userProfile = json['user_photo'];
    proposed_remuneration = json['proposed_remuneration'];
    grade_name = json['grade_name'];
    mobile_number = json['mobile_number'];
    area_of_art = json['area_of_art'];
    nameInstitution = json['name_institution'];
    address = json['address'];
    vidha_name = json['vidha_name'];
    city = json['city'];
    typeArtist = json['type_artist'];
    experience = json['experience'];
    gender = json['gender'];
    dateOfBirth = json['date_of_birth'];
    date = json['date'];
    month = json['month'];
    year = json['year'];
    instagramLink = json['instagram_link']??'';
    facebookLink = json['facebook_link']??'';
    // youtubeLink = json['youtube_link'];
    photo = json['photo'];
    totalProgram = json['total_program'];
    programParticipate = json['program_participate'];
    profileStatus = json['profile_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['cost'] = cost;
    data['email_id'] = email_id;
    data['team_member'] = team_member;
    data['user_photo'] = userProfile;
    data['presentation_level'] = presentation_level;
    data['area_of_art'] = area_of_art;
    data['training_certificate'] = trainingCertificate;
    data['grade_certificate'] = gradeCertificate;
    data['audition_link'] = auditionLink;
    data['other_info'] = otherInfo;

    data['youtube_link'] = youtubeLink;
    data['districts_name'] = districts_name;
    data['senior_artist_name1'] = seniorArtistName1;
    data['senior_artist_designation1'] = seniorArtistDesignation1;
    data['senior_artist_mobile_number1'] = seniorArtistMobileNumber1;
    data['senior_artist_name2'] = seniorArtistName2;
    data['senior_artist_designation2'] = seniorArtistDesignation2;
    data['senior_artist_mobile_number2'] = seniorArtistMobileNumber2;
    data['grade_name'] = grade_name;
    data['mobile_number'] = mobile_number;
    data['name_institution'] = nameInstitution;
    data['address'] = address;
    data['vidha_name'] = vidha_name;
    data['city'] = city;
    data['type_artist'] = typeArtist;
    data['experience'] = experience;
    data['gender'] = gender;
    data['date_of_birth'] = dateOfBirth;
    data['date'] = date;
    data['date_of_birth'] = month;
    data['date_of_birth'] = year;
    data['proposed_remuneration'] = proposed_remuneration;
    data['instagram_link'] = instagramLink;
    data['facebook_link'] = facebookLink;
    // data['youtube_link'] = youtubeLink;
    data['photo'] = photo;
    data['total_program'] = totalProgram;
    data['program_participate'] = programParticipate;
    data['profile_status'] = profileStatus;
    return data;
  }
}
