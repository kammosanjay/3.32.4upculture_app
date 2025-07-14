class EventDetailsResponse {
  bool? status;
  int? code;
  String? type;
  String? message;
  List<SubEvent>? data;

  EventDetailsResponse(
      {this.status, this.code, this.type, this.message, this.data});

  EventDetailsResponse.fromJson(Map<dynamic, dynamic> json) {
    status = json['status'];
    code = json['code'];
    type = json['type'];
    message = json['message'];
    if (json['data'] != null) {
      data = <SubEvent>[];
      json['data'].forEach((v) {
        data!.add(SubEvent.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['code'] = code;
    data['type'] = type;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubEvent {
  int? id;
  String? name;
  String? ayojakName;
  String? startTime;
  String? endTime;
  String? startDate;
  String? endDate;
  String? presentLog;
  String? photo;
  String? about;
  String? address;

  SubEvent(
      {this.id,
      this.name,
      this.ayojakName,
      this.startTime,
      this.endTime,
      this.startDate,
      this.endDate,
      this.presentLog,
      this.photo,
      this.about,
      this.address});

  SubEvent.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    ayojakName = json['ayojak_name'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    presentLog = json['present_log'];
    photo = json['photo'];
    about = json['about'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['ayojak_name'] = ayojakName;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['present_log'] = presentLog;
    data['photo'] = photo;
    data['about'] = about;
    data['address'] = address;
    return data;
  }
}
