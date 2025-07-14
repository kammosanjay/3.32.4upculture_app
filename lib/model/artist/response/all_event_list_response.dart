class AllEventListResponse {
  bool? status;
  int? code;
  String? type;
  String? message;
  List<Data>? data;

  AllEventListResponse(
      {this.status, this.code, this.type, this.message, this.data});

  AllEventListResponse.fromJson(Map<dynamic, dynamic> json) {
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

class Data {
  int? id;
  String? date;
  String? day;
  String? dayName;
  String? month;

  Data({this.id, this.date, this.day, this.dayName, this.month});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    day = json['day'];
    dayName = json['day_name'];
    month = json['month'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['date'] = date;
    data['day'] = day;
    data['day_name'] = dayName;
    data['month'] = month;
    return data;
  }
}
