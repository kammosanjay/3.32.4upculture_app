class DateWiseEventsResponse {
  bool? status;
  int? code;
  String? type;
  String? message;
  List<Data>? data;
  String? selectDate;

  DateWiseEventsResponse(
      {this.status,
        this.code,
        this.type,
        this.message,
        this.data,
        this.selectDate});

  DateWiseEventsResponse.fromJson(Map<dynamic, dynamic> json) {
    status = json['status'];
    code = json['code'];
    type = json['type'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    selectDate = json['select_date'];
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
    data['select_date'] = selectDate;
    return data;
  }
}

class Data {
  int? id;
  String? name;
  String? ayojakName;
  String? startTime;
  String? endTime;
  String? ayojanStartDate;
  String? ayojanEndDate;
  String? presentLog;
  String? photo;

  Data(
      {this.id,
        this.name,
        this.ayojakName,
        this.startTime,
        this.endTime,
        this.ayojanStartDate,
        this.ayojanEndDate,
        this.presentLog,
        this.photo});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    ayojakName = json['ayojak_name'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    ayojanStartDate = json['ayojan_start_date'];
    ayojanEndDate = json['ayojan_end_date'];
    presentLog = json['present_log'];
    photo = json['photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['ayojak_name'] = ayojakName;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['ayojan_start_date'] = ayojanStartDate;
    data['ayojan_end_date'] = ayojanEndDate;
    data['present_log'] = presentLog;
    data['photo'] = photo;
    return data;
  }
}
