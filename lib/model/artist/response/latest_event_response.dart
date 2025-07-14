class   LatestChangeEventModal {
  String? eventName;
  String? ayojakName;
  String? startDate;
  String? endDate;
  String? eventTime;
  String? eventDay;
  String? totalTime;
  String? ageLimit;
  String? language;
  String? address;
  String? addressMapLink;
  String? about;
  String? photo;
  String? coverPhoto;

  LatestChangeEventModal(
      {this.eventName,
      this.ayojakName,
      this.startDate,
      this.endDate,
      this.eventTime,
      this.eventDay,
      this.totalTime,
      this.ageLimit,
      this.language,
      this.address,
      this.addressMapLink,
      this.about,
      this.photo,
      this.coverPhoto});

  LatestChangeEventModal.fromJson(Map<String, dynamic> json) {
    eventName = json['event_name'];
    ayojakName = json['ayojak_name'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    eventTime = json['event_time'];
    eventDay = json['event_day'];
    totalTime = json['total_time'];
    ageLimit = json['age_limit'];
    language = json['language'];
    address = json['address'];
    addressMapLink = json['address_map_link'];
    about = json['about'];
    photo = json['photo'];
    coverPhoto = json['cover_photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['event_name'] = this.eventName;
    data['ayojak_name'] = this.ayojakName;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['event_time'] = this.eventTime;
    data['event_day'] = this.eventDay;
    data['total_time'] = this.totalTime;
    data['age_limit'] = this.ageLimit;
    data['language'] = this.language;
    data['address'] = this.address;
    data['address_map_link'] = this.addressMapLink;
    data['about'] = this.about;
    data['photo'] = this.photo;
    data['cover_photo'] = this.coverPhoto;
    return data;
  }
}
