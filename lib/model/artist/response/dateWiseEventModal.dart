import 'package:get/get.dart';

class DateWiseEvent {
  bool? status;
  int? code;
  String? type;
  String? message;
  List<Data>? data;

  DateWiseEvent({this.status, this.code, this.type, this.message, this.data});

  DateWiseEvent.fromJson(Map<dynamic, dynamic> json) {
    status = json['status'];
    code = json['code'];
    type = json['type'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['code'] = this.code;
    data['type'] = this.type;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
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

  Data(
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

  Data.fromJson(Map<String, dynamic> json) {
    eventName = _validateData(json['event_name']);
    ayojakName = _validateData(json['ayojak_name']);
    startDate = _validateData(json['start_date']);
    endDate = _validateData(json['end_date']);
    eventTime = _validateData(json['event_time']);
    eventDay = _validateData(json['event_day']);
    totalTime = _validateData(json['total_time']);
    ageLimit = _validateData(json['age_limit']);
    language = _validateData(json['language']);
    address = _validateData(json['address']);
    addressMapLink = _validateData(json['address_map_link']);
    // about = json['about'];
    about = parseHtmlOrDefault(json['about']);

    photo = json['photo'];
    coverPhoto = json['cover_photo'];
  }
  String parseHtmlOrDefault(String? html,
      {String defaultValue = "No description available"}) {
    if (html == null || html.trim().isEmpty) {
      return defaultValue;
    }

    // Strip HTML tags (optional)
    final RegExp exp =
        RegExp(r'<[^>]*>', multiLine: true, caseSensitive: false);
    return html.replaceAll(exp, '').trim();
  }

  String _validateData(dynamic value, [String defaultValue = ""]) {
    return (value == null || (value is String && value.trim().isEmpty))
        ? defaultValue
        : value.toString();
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
